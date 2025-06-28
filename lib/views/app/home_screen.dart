import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ambw_c14210052/views/app/add_todo_screen.dart';
import 'package:uas_ambw_c14210052/views/app/archived_screen.dart';
import 'package:uas_ambw_c14210052/controllers/auth_controller.dart';
import 'package:uas_ambw_c14210052/controllers/todo_controller.dart';
import 'package:uas_ambw_c14210052/views/app/profile_screen.dart';
import 'package:uas_ambw_c14210052/views/app/removed_screen.dart';
import 'package:uas_ambw_c14210052/views/app/todo_detail_screen.dart';
import 'package:uas_ambw_c14210052/models/todo.dart';
import 'package:uas_ambw_c14210052/controllers/profile_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Get.put(ProfileController());
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    final controller2 = Get.put(AuthController());
    final profileController = Get.find<ProfileController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Daily Planner',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() {
              final imageUrl = profileController.avatarUrl.value;
              return GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileScreen());
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 22,
                          color: colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
              );
            }),
          ),
          IconButton(
            onPressed: controller2.signOut,
            icon: Icon(Icons.logout, color: colorScheme.onPrimary),
            tooltip: 'Logout',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              focusNode: _searchFocusNode,
              onChanged: (val) => controller.searchQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Cari tugas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final imageUrl = profileController.avatarUrl.value;
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: colorScheme.onPrimary.withOpacity(0.9),
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty
                          ? Icon(
                              Icons.person_pin,
                              size: 30,
                              color: colorScheme.primary,
                            )
                          : null,
                    );
                  }),
                  const SizedBox(height: 10),
                  Text(
                    'Daily Planner',
                    style: GoogleFonts.poppins(
                        color: colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text(
                      controller.userEmail.value,
                      style: GoogleFonts.poppins(
                          color: colorScheme.onPrimary.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: Text('Archive', style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                Get.to(() => const ArchiveScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: Text('Removed Todos', style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                Get.to(() => const RemovedScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout', style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                controller2.signOut();
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: Obx(() {
          final grouped = controller.groupedTodos;
          if (grouped.isEmpty && controller.searchQuery.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Tidak ada tugas',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: Colors.grey)),
                  Text(
                    'Tekan tombol + untuk menambah tugas baru.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          if (grouped.isEmpty && controller.searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Tugas Tidak Ditemukan',
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: Colors.grey)),
                  Text(
                    'Tidak ada hasil untuk "${controller.searchQuery.value}"',
                    style: GoogleFonts.poppins(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Obx(() {
                  final username =
                      profileController.userProfile.value?.username;

                  final greetingName = username != null && username.isNotEmpty
                      ? username
                      : 'User';

                  return Text(
                    'Hello, $greetingName 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  );
                }),
              ),
              ...grouped.entries.expand((entry) {
                final key = entry.key;
                final todos = entry.value;
                return [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      key,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  ...todos
                      .map((todo) => _buildTodoItem(todo, controller, context)),
                ];
              }),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => const AddTodoScreen());
          if (result == true) {
            controller.refreshTodos();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Tugas',
      ),
    );
  }

  Widget _buildTodoItem(
      Todo todo, TodoController controller, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: todo.isCompleted
          ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
          : colorScheme.surfaceVariant.withOpacity(0.5),
      child: ListTile(
        onTap: () {
          Get.to(() => TodoDetailScreen(todo: todo));
        },
        leading: Checkbox(
          activeColor: colorScheme.primary,
          value: todo.isCompleted,
          onChanged: (bool? value) async {
            await controller.toggleTodoCompletion(todo, value);
          },
        ),
        title: Text(
          todo.taskName,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
            color: todo.isCompleted ? Colors.grey : textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description?.isNotEmpty ?? false)
              Text(todo.description!,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(DateFormat('HH:mm').format(todo.dueDate)),
            if (todo.category != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  todo.category!,
                  style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: colorScheme.primary),
              onPressed: () async {
                if (todo.isCompleted) {
                  Get.snackbar('Perhatian',
                      'Tugas yang sudah selesai tidak bisa diedit.',
                      backgroundColor: Colors.orange);
                  return;
                }

                final result = await Get.to(() => AddTodoScreen(todo: todo));
                if (result == true) {
                  controller.refreshTodos();
                }
              },
            ),
            IconButton(
                icon: Icon(Icons.archive_outlined, color: Colors.green),
                onPressed: () async {
                  await controller.archiveTodo(todo);
                }),
            IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error),
              onPressed: () async {
                if (todo.isCompleted) {
                  Get.snackbar('Perhatian',
                      'Tugas yang sudah selesai tidak bisa dihapus.',
                      backgroundColor: Colors.orange);
                  return;
                }
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: Text('Hapus tugas "${todo.taskName}"?'),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Batal')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error),
                        onPressed: () => Get.back(result: true),
                        child: Text('Hapus',
                            style: TextStyle(color: colorScheme.onError)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await controller.deleteTodo(todo);
                  controller.refreshTodos();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
