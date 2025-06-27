import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ambw_c14210052/controllers/todo_controller.dart';
import 'package:uas_ambw_c14210052/views/app/todo_detail_screen.dart';
import 'package:uas_ambw_c14210052/models/todo_model.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Archived Todos',
          style: GoogleFonts.poppins(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.archivedTodos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Arsip kosong',
                  style: textTheme.headlineSmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
                Text(
                  'Tidak ada tugas yang diarsipkan.',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.archivedTodos.length,
          itemBuilder: (context, index) {
            final todo = controller.archivedTodos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: colorScheme.surfaceVariant,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                onTap: () => Get.to(() => TodoDetailScreen(todo: todo)),
                leading:
                    Icon(Icons.archive_rounded, color: colorScheme.secondary),
                title: Text(
                  todo.taskName,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Diarsipkan',
                  style: textTheme.bodySmall?.copyWith(
                      color: textTheme.bodySmall?.color?.withOpacity(0.7)),
                ),
                trailing: TextButton.icon(
                  icon: const Icon(Icons.unarchive),
                  label: const Text('Batal Arsip'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                  ),
                  onPressed: () =>
                      _showUnarchiveDialog(context, controller, todo),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showUnarchiveDialog(
      BuildContext context, TodoController controller, Todo todo) {
    final colorScheme = Theme.of(context).colorScheme;

    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Keluarkan "${todo.taskName}" dari arsip?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text('Ya, Keluarkan'),
            onPressed: () {
              controller.unarchiveTodo(todo);
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Tugas telah dikembalikan ke daftar utama.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }
}
