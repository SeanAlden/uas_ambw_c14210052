import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uas_ambw_c14210052/get_started_screen.dart';
import 'package:uas_ambw_c14210052/views/app/home_screen.dart';
import 'package:uas_ambw_c14210052/views/auth/login_screen.dart';
import 'package:uas_ambw_c14210052/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);

    final settingsBox = Hive.box('app_settings');
    final getStartedCompleted =
        settingsBox.get('getStartedCompleted', defaultValue: false);

    if (!getStartedCompleted) {
      Get.offAll(() => const GetStartedScreen());
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final refreshToken = prefs.getString('refreshToken');

    if (isLoggedIn && refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await supabase.auth.setSession(refreshToken);
      } catch (_) {}
    }

    if (isLoggedIn) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
