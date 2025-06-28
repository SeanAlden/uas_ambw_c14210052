// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uas_ambw_c14210052/main.dart';
// import 'package:uas_ambw_c14210052/models/user.dart';

// class ProfileController extends GetxController {
//   final isLoading = false.obs;
//   final avatarUrl = ''.obs;

//   Rx<User?> userProfile = Rx<User?>(null);

//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserProfile();
//   }

//   Future<void> _loadUserProfile() async {
//     final userId = supabase.auth.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final data =
//           await supabase.from('users').select().eq('auth_id', userId).single();
//       userProfile.value = User.fromMap(data);

//       final avatarPath = userProfile.value?.avatarPath;
//       if (avatarPath != null && avatarPath.isNotEmpty) {
//         avatarUrl.value =
//             supabase.storage.from('avatars').getPublicUrl(avatarPath);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Gagal memuat profil: ${e.toString()}',
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     }
//   }

//   Future<void> uploadAvatar() async {
//     final picker = ImagePicker();

//     final imageFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );

//     if (imageFile == null) {
//       return;
//     }

//     isLoading.value = true;

//     try {
//       final file = File(imageFile.path);
//       final fileExt = imageFile.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
//       final userId = supabase.auth.currentUser!.id;
//       final filePath = '$userId/$fileName';

//       await supabase.storage.from('avatars').upload(filePath, file);

//       await supabase
//           .from('users')
//           .update({'avatar_path': filePath}).eq('auth_id', userId);

//       avatarUrl.value = supabase.storage.from('avatars').getPublicUrl(filePath);

//       Get.snackbar('Berhasil', 'Gambar profil berhasil diperbarui!',
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Gagal mengunggah gambar: ${e.toString()}',
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateUserProfile(String newUsername, String newPhone) async {
//     isLoading.value = true;
//     try {
//       final userId = supabase.auth.currentUser!.id;
//       await supabase.from('users').update({
//         'username': newUsername,
//         'phone_number': newPhone,
//       }).eq('auth_id', userId);

//       userProfile.value = userProfile.value?.copyWith(
//         username: newUsername,
//         phoneNumber: newPhone,
//       );
//       userProfile.refresh();

//       Get.back();
//       Get.snackbar('Berhasil', 'Profil berhasil diperbarui.',
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Gagal memperbarui profil: ${e.toString()}',
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updatePassword(String newPassword) async {
//     isLoading.value = true;
//     try {
//       await supabase.auth.updateUser(
//         UserAttributes(password: newPassword),
//       );
//       Get.back();
//       Get.snackbar('Berhasil', 'Password Anda telah berhasil diubah.',
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Gagal mengubah password: ${e.toString()}',
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_ambw_c14210052/main.dart';

// Memberi prefix 'model' pada import model User Anda
import 'package:uas_ambw_c14210052/models/user.dart' as model;

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final avatarUrl = ''.obs;

  // Menggunakan 'model.User' untuk merujuk ke kelas User dari file model Anda
  Rx<model.User?> userProfile = Rx<model.User?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // `supabase.auth.currentUser` tetap menggunakan `User` dari Supabase, tidak perlu diubah
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final data =
          await supabase.from('users').select().eq('auth_id', userId).single();
      // Menggunakan 'model.User.fromMap' untuk membuat instance dari model Anda
      userProfile.value = model.User.fromMap(data);

      final avatarPath = userProfile.value?.avatarPath;
      if (avatarPath != null && avatarPath.isNotEmpty) {
        avatarUrl.value =
            supabase.storage.from('avatars').getPublicUrl(avatarPath);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: ${e.toString()}',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> uploadAvatar() async {
    final picker = ImagePicker();

    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (imageFile == null) {
      return;
    }

    isLoading.value = true;

    try {
      final file = File(imageFile.path);
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final userId = supabase.auth.currentUser!.id;
      final filePath = '$userId/$fileName';

      await supabase.storage.from('avatars').upload(filePath, file);

      await supabase
          .from('users')
          .update({'avatar_path': filePath}).eq('auth_id', userId);

      avatarUrl.value = supabase.storage.from('avatars').getPublicUrl(filePath);

      Get.snackbar('Berhasil', 'Gambar profil berhasil diperbarui!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengunggah gambar: ${e.toString()}',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile(String newUsername, String newPhone) async {
    isLoading.value = true;
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('users').update({
        'username': newUsername,
        'phone_number': newPhone,
      }).eq('auth_id', userId);

      // Tidak perlu prefix di sini karena `userProfile.value` sudah bertipe `model.User?`
      userProfile.value = userProfile.value?.copyWith(
        username: newUsername,
        phoneNumber: newPhone,
      );
      userProfile.refresh();

      Get.back();
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui.',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: ${e.toString()}',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    isLoading.value = true;
    try {
      // `updateUser` dari Supabase secara internal sudah tahu `User` yang mana yang dimaksud
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      Get.back();
      Get.snackbar('Berhasil', 'Password Anda telah berhasil diubah.',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah password: ${e.toString()}',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}