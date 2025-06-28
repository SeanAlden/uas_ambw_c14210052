import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ambw_c14210052/controllers/todo_controller.dart';
import 'package:uas_ambw_c14210052/models/todo.dart';

class RemovedScreen extends StatelessWidget {
  const RemovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Removed Todos',
            style: GoogleFonts.poppins(
                color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (controller.removedTodos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_sweep_outlined,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('Keranjang sampah kosong',
                    style: textTheme.headlineSmall
                        ?.copyWith(color: Colors.grey.shade600)),
                Text('Tidak ada tugas yang dihapus.',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey.shade600)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          itemCount: controller.removedTodos.length,
          itemBuilder: (context, index) {
            final todo = controller.removedTodos[index];
            final deletedDate =
                DateFormat('d MMM y, HH:mm', 'id_ID').format(todo.deletedAt!);
            return Card(
              color: colorScheme.errorContainer,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.delete, color: colorScheme.error),
                title: Text(todo.taskName,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onErrorContainer,
                    )),
                subtitle: Text('Dihapus pada: $deletedDate',
                    style: TextStyle(
                      color: colorScheme.onErrorContainer.withOpacity(0.7),
                    )),
                trailing: Obx(() {
                  if (controller.processingTodoId.value == todo.id) {
                    return SizedBox(
                      width: 96,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colorScheme.primary,
                        ),
                      ),
                    );
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.restore_from_trash,
                              color: colorScheme.primary),
                          tooltip: 'Restore',
                          onPressed: () =>
                              _showRestoreDialog(context, controller, todo),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever,
                              color: colorScheme.error),
                          tooltip: 'Delete Permanently',
                          onPressed: () => _showPermanentDeleteDialog(
                              context, controller, todo),
                        ),
                      ],
                    );
                  }
                }),
              ),
            );
          },
        );
      }),
    );
  }

  void _showRestoreDialog(
      BuildContext context, TodoController controller, Todo todo) {
    Get.dialog(AlertDialog(
      title: const Text('Kembalikan Tugas?'),
      content: Text('Anda yakin ingin mengembalikan tugas "${todo.taskName}"?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await controller.restoreTodo(todo);
            Get.snackbar(
                'Berhasil', 'Tugas "${todo.taskName}" telah dikembalikan.',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(10));
          },
          child: const Text('Ya, Kembalikan'),
        ),
      ],
    ));
  }

  void _showPermanentDeleteDialog(
      BuildContext context, TodoController controller, Todo todo) {
    final colorScheme = Theme.of(context).colorScheme;
    Get.dialog(AlertDialog(
      title: const Text('Hapus Permanen?'),
      content: Text(
          'Anda yakin ingin menghapus tugas "${todo.taskName}" secara permanen? Aksi ini tidak dapat dibatalkan.'),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: () async {
            Get.back();
            await controller.deleteTodoPermanently(todo);
            Get.snackbar(
                'Terhapus', 'Tugas "${todo.taskName}" telah dihapus permanen.',
                backgroundColor: colorScheme.error,
                colorText: colorScheme.onError,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(10));
          },
          child: const Text('Hapus'),
        ),
      ],
    ));
  }
}
