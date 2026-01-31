import 'dart:io';

import 'package:businesstrack/app/myapp.dart';
import 'package:businesstrack/features/users/presentation/view_model/user_viewmodel.dart';
import 'package:businesstrack/features/users/presentation/widgets/Settingtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _profileImage;

  // ================= PERMISSION =================
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "Camera or Gallery permission is required to change profile photo.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  // ================= CAMERA =================
  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _profileImage = photo;
      });

      // image to server
      await ref
          .read(userViewmodelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  // ================= GALLERY =================
  Future<void> _pickFromGallery() async {
    final hasPermission = await _requestPermission(Permission.photos);
    if (!hasPermission) return;

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = image;
      });

      await ref
          .read(userViewmodelProvider.notifier)
          .uploadPhoto(File(image.path));
    }
  }

  // ================= BOTTOM SHEET =================
  void _showPickImageSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          // PROFILE SECTION
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showPickImageSheet,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : const AssetImage(
                                'assets/icons/person.jpg'
                              ),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rohan Yadav",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Tap to change profile photo",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // ACCOUNT
          Settingtile(icon: Icons.person, title: "Edit Profile"),
          Settingtile(icon: Icons.lock, title: "Change Password"),
          Settingtile(icon: Icons.email, title: "Change Email"),

          const Divider(),

          // APPEARANCE
          Settingtile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: ValueListenableBuilder<ThemeMode>(
              valueListenable: MyApp.themeNotifier,
              builder: (context, themeMode, _) {
                return Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (isDark) {
                    MyApp.themeNotifier.value =
                        isDark ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),
          ),

          const Divider(),

          // PRIVACY
          Settingtile(icon: Icons.privacy_tip, title: "Privacy"),
          Settingtile(icon: Icons.security, title: "Security"),

          const Divider(),

          // LOGOUT
          Settingtile(icon: Icons.logout, title: "Logout", onTap: () {}),
        ],
      ),
    );
  }
}
