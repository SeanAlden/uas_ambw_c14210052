import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_ambw_c14210052/controllers/auth_controller.dart';
import 'package:uas_ambw_c14210052/controllers/profile_controller.dart';
import 'package:uas_ambw_c14210052/views/app/edit_password_screen.dart';
import 'package:uas_ambw_c14210052/views/app/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    final AuthController authController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Obx(() {
                final imageUrl = profileController.avatarUrl.value;
                final isLoading = profileController.isLoading.value;

                return GestureDetector(
                  onTap: profileController.uploadAvatar,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        child: (imageUrl.isEmpty && !isLoading)
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: colorScheme.onPrimaryContainer,
                              )
                            : null,
                      ),
                      if (isLoading) const CircularProgressIndicator(),
                      if (!isLoading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: colorScheme.secondary,
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: colorScheme.onSecondary,
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                final username = profileController.userProfile.value?.username;
                return Text(
                  username ?? authController.user?.email ?? 'Memuat...',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                );
              }),
              const SizedBox(height: 8),
              Text(
                'Selamat datang di Daily Planner!',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 40),
              _buildSettingsContainer(context, authController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(
      BuildContext context, AuthController authController) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuOption(
            context,
            icon: Icons.edit_outlined,
            title: 'Edit Profil',
            onTap: () {
              Get.to(() => const EditProfileScreen());
            },
          ),
          _buildMenuOption(
            context,
            icon: Icons.lock_outline,
            title: 'Ganti Password',
            onTap: () {
              Get.to(() => const EditPasswordScreen());
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuOption(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            isDestructive: true,
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Get.back();
                        authController.signOut();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                      ),
                      child: Text(
                        'Keluar',
                        style: TextStyle(color: colorScheme.onError),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor =
        isDestructive ? colorScheme.error : colorScheme.onSurface;
    final iconColor = isDestructive ? colorScheme.error : colorScheme.primary;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
