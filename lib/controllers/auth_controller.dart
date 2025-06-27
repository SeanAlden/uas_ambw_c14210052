import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../views/app/home_screen.dart';
import '../views/auth/login_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  final emailController = ''.obs;
  final passwordController = ''.obs;

  User? get user => supabase.auth.currentUser;

  Future<void> signIn() async {
    isLoading.value = true;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.value.trim(),
        password: passwordController.value.trim(),
      );

      final session = response.session;
      if (session != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('accessToken', session.accessToken);
        await prefs.setString('refreshToken', session.refreshToken ?? '');
        await prefs.setString('userEmail', session.user.email ?? '');
        Get.offAll(() => const HomeScreen());
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Login Gagal",
        e.message,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (_) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan tak terduga.",
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Validasi Gagal",
        "Semua field wajib diisi.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Email Tidak Valid",
        "Masukkan email yang benar.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        "Password Terlalu Pendek",
        "Password minimal 6 karakter.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Password Tidak Cocok",
        "Konfirmasi password tidak sesuai.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final session = result.session;

      if (result.user != null) {
        if (session != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('refreshToken', session.refreshToken ?? '');
          await prefs.setString('userEmail', result.user?.email ?? '');
          Get.offAll(() => const HomeScreen());
        } else {
          Get.snackbar(
            'Registrasi Berhasil',
            'Silakan cek email untuk konfirmasi.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAll(() => const LoginScreen());
        }
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Registrasi Gagal",
        e.message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (_) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan tak terduga.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const LoginScreen());
  }
}
