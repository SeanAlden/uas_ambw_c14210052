import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ambw_c14210052/controllers/todo_controller.dart';
import 'package:uas_ambw_c14210052/models/todo_model.dart';

class AddTodoScreen extends StatelessWidget {
  final Todo? todo;

  const AddTodoScreen({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

    final colorScheme = Theme.of(context).colorScheme;

    controller.init(todo);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          todo == null ? 'Tambah Tugas Baru' : 'Edit Tugas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: controller.saveTodo,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Simpan',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.nameController,
                  decoration: _buildInputDecoration(context, 'Nama Tugas'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tugas tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.descController,
                  decoration:
                      _buildInputDecoration(context, 'Deskripsi (Opsional)'),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedCategory.value,
                      decoration: _buildInputDecoration(context, 'Kategori'),
                      dropdownColor: colorScheme.surfaceVariant,
                      items: controller.categories
                          .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (value) =>
                          controller.selectedCategory.value = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih kategori';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 16),
                Obx(() => ListTile(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: colorScheme.outline),
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: colorScheme.surfaceVariant,
                      onTap: () => controller.pickDateTime(context),
                      leading: Icon(Icons.calendar_today,
                          color: colorScheme.primary),
                      title: Text(
                        'Waktu & Tanggal',
                        style: GoogleFonts.poppins(),
                      ),
                      subtitle: Text(
                        controller.getFormattedDate(),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colorScheme.primary),
      filled: true,
      fillColor: colorScheme.surfaceVariant,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
