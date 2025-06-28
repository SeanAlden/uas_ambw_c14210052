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
    required String username,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    if (username.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar(
        "Validasi Gagal",
        "Semua field wajib diisi.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final authResult = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {
          'username': username.trim(),
        },
      );

      if (authResult.user != null) {
        await supabase.from('users').insert({
          'auth_id': authResult.user!.id,
          'username': username.trim(),
          'phone_number': phoneNumber.trim(),
          'email': email.trim(),
        });

        final session = authResult.session;
        if (session != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('refreshToken', session.refreshToken ?? '');
          await prefs.setString('userEmail', authResult.user?.email ?? '');
          Get.offAll(() => const HomeScreen());
        } else {
          Get.snackbar(
            'Registrasi Berhasil',
            'Silakan cek email Anda untuk verifikasi akun.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
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
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: ${e.toString()}",
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
