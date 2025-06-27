import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_ambw_c14210052/main.dart';
import 'package:uas_ambw_c14210052/models/todo_model.dart';

class TodoController extends GetxController {
  RxString userEmail = 'User'.obs;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  RxString searchQuery = ''.obs;
  var processingTodoId = Rxn<int>();

  RxList<Todo> activeTodos = <Todo>[].obs;
  RxList<Todo> archivedTodos = <Todo>[].obs;
  RxList<Todo> removedTodos = <Todo>[].obs;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  var selectedDate = Rxn<DateTime>();
  var selectedCategory = RxnString();

  final categories = ['Pekerjaan', 'Pribadi', 'Belajar', 'Olahraga', 'Lainnya'];

  Todo? editingTodo;

  @override
  void onInit() {
    super.onInit();
    _loadUserEmail();
    _subscribeToTodos();
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    userEmail.value = prefs.getString('userEmail') ?? 'User';
  }

  void _subscribeToTodos() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    _subscription?.cancel();
    _subscription = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('due_date', ascending: true)
        .order('task_name')
        .listen((maps) {
          final allData = maps.map((e) => Todo.fromJson(e)).toList();

          activeTodos.value = allData
              .where((t) => !t.isArchived && t.deletedAt == null)
              .toList();
          archivedTodos.value = allData
              .where((t) => t.isArchived && t.deletedAt == null)
              .toList();
          removedTodos.value =
              allData.where((t) => t.deletedAt != null).toList();
        });
  }

  void init(Todo? todo) {
    editingTodo = todo;
    nameController.text = todo?.taskName ?? '';
    descController.text = todo?.description ?? '';
    selectedDate.value = todo?.dueDate ?? DateTime.now();
    selectedCategory.value = todo?.category;
  }

  Future<void> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate.value ?? DateTime.now()),
    );
    if (time == null) return;

    selectedDate.value =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> saveTodo() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate.value == null) {
      Get.snackbar('Error', 'Silakan pilih tanggal dan waktu',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (selectedCategory.value == null || selectedCategory.value!.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih kategori',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final userId = supabase.auth.currentUser!.id;

    final data = {
      'user_id': userId,
      'task_name': nameController.text.trim(),
      'description': descController.text.trim(),
      'category': selectedCategory.value,
      'due_date': selectedDate.value!.toIso8601String(),
      'is_archived': editingTodo?.isArchived ?? false,
    };

    try {
      if (editingTodo == null) {
        await supabase.from('todos').insert(data);
      } else {
        await supabase.from('todos').update(data).eq('id', editingTodo!.id);
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      Get.back(result: false);
    }
  }

  String getFormattedDate() {
    if (selectedDate.value == null) return 'Pilih waktu';
    return DateFormat('EEE, d MMM y HH:mm', 'id_ID')
        .format(selectedDate.value!);
  }

  Map<String, List<Todo>> get groupedTodos {
    final Map<String, List<Todo>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final filteredTodos = activeTodos.where((todo) {
      final query = searchQuery.value.toLowerCase();
      return todo.taskName.toLowerCase().contains(query) ||
          (todo.description?.toLowerCase().contains(query) ?? false) ||
          (todo.category?.toLowerCase().contains(query) ?? false);
    }).toList();

    for (var todo in filteredTodos) {
      final todoDate =
          DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
      String key;
      if (todoDate.isAtSameMomentAs(today)) {
        key = 'Hari Ini';
      } else if (todoDate.isAtSameMomentAs(tomorrow)) {
        key = 'Besok';
      } else {
        key = DateFormat('EEEE, d MMMM y', 'id_ID').format(todoDate);
      }
      grouped[key] ??= [];
      grouped[key]!.add(todo);
    }
    return grouped;
  }

  Future<void> toggleTodoCompletion(Todo todo, bool? value) async {
    await supabase
        .from('todos')
        .update({'is_completed': value}).eq('id', todo.id);
  }

  Future<void> deleteTodo(Todo todo) async {
    await supabase.from('todos').update(
        {'deleted_at': DateTime.now().toIso8601String()}).eq('id', todo.id);
  }

  Future<void> archiveTodo(Todo todo) async {
    await supabase
        .from('todos')
        .update({'is_archived': true}).eq('id', todo.id);
  }

  Future<void> unarchiveTodo(Todo todo) async {
    await supabase
        .from('todos')
        .update({'is_archived': false}).eq('id', todo.id);
  }

  Future<void> restoreTodo(Todo todo) async {
    processingTodoId.value = todo.id;
    try {
      await supabase
          .from('todos')
          .update({'deleted_at': null}).eq('id', todo.id);
    } finally {
      processingTodoId.value = null;
    }
  }

  Future<void> deleteTodoPermanently(Todo todo) async {
    processingTodoId.value = todo.id;
    try {
      await supabase.from('todos').delete().eq('id', todo.id);

      removedTodos.removeWhere((item) => item.id == todo.id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus tugas: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      processingTodoId.value = null;
    }
  }

  void refreshTodos() => _subscribeToTodos();

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    _subscription?.cancel();
    super.onClose();
  }
}
