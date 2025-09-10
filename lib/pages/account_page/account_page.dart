import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_settings.dart';
import '../../utils/colors.dart';

class AccountPage extends StatelessWidget {
  static const String path = '/account';
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.getInstance();
    final name  = s.getUserName();
    final email = s.getUserEmail();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('Account', style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),)
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                _Avatar(name: name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? 'User' : name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(color: AppColor.descColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {

                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),


          const ListTile(
            leading: Icon(Icons.inventory_2_outlined),
            title: Text('Orders'),
            trailing: Icon(Icons.chevron_right),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.inputFill,
                  foregroundColor: AppColor.accentColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Log out?'),
                      content: const Text('You will need to login again.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true),  child: const Text('Log out')),
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (name.trim().isNotEmpty) {
      final parts = name.trim().split(RegExp(r'\s+'));
      initials = parts.take(2).map((p) => p[0].toUpperCase()).join();
    }
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColor.accentColor.withOpacity(.15),
      child: Text(initials.isEmpty ? 'U' : initials,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    );
  }
}
