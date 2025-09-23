import 'dart:io';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  static const String path = '/account';
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _uploading = false;
  String? _localAvatarPath;

  Future<void> _pickAndUpload(ImageSource source) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: source, imageQuality: 90);
    if (x == null) return;

    setState(() {
      _localAvatarPath = x.path;
      _uploading = true;
    });

    String? url;
    try {
      final api = ServerApi();
      url = await api.uploadAvatar(x.path);
    } catch (e) {
      url = null;
    }

    if (!mounted) return;
    setState(() => _uploading = false);

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload avatar')),
      );
      return;
    }

    final bust = 't=${DateTime.now().millisecondsSinceEpoch}';
    final finalUrl = url.contains('?') ? '$url&$bust' : '$url?$bust';

    await AppSettings.getInstance().setUserAvatar(finalUrl);

    if (!mounted) return;
    setState(() {
      _localAvatarPath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avatar updated')),
    );
  }

  void _showPickSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUpload(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUpload(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.getInstance();
    final name     = s.getUserName();
    final email    = s.getUserEmail();
    final token    = s.getToken();
    final avatarUrl = s.getUserAvatar();


    ImageProvider? avatarProvider;
    if (_localAvatarPath != null) {
      avatarProvider = FileImage(File(_localAvatarPath!));
    } else if (avatarUrl.isNotEmpty) {
      avatarProvider = NetworkImage(
        avatarUrl,
        headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
      );
    }

    String initials = '';
    if (name.trim().isNotEmpty) {
      final parts = name.trim().split(RegExp(r'\s+'));
      initials = parts.take(2).map((p) => p[0].toUpperCase()).join();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [

                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColor.accentColor.withOpacity(.15),
                  backgroundImage: avatarProvider,
                  onBackgroundImageError: avatarProvider != null
                      ? (Object error, StackTrace? stack) {
                    debugPrint('Avatar load error: $avatarUrl');
                  }
                      : null,
                  child: avatarProvider == null
                      ? Text(
                    initials.isEmpty ? 'U' : initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name.isEmpty ? 'User' : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: _uploading ? null : _showPickSheet,
                            customBorder: const CircleBorder(),
                            child: _uploading
                                ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Icon(Icons.edit, size: 22, color: AppColor.accentColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColor.descColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Orders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed('orders'),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 67,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.inputFill,
                  foregroundColor: AppColor.accentColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Log out?'),
                      content: const Text('You will need to login again.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Log out'),
                        ),
                      ],
                    ),
                  );
                  if (ok != true) return;

                  await AppSettings.getInstance().logout();
                  if (!context.mounted) return;
                  context.go('/login');
                },
                child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
