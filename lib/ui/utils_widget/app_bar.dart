import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../business/auth.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        './assets/images/title.png',
        fit: BoxFit.cover,
        height: 35,
        width: 35,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _signOut(context),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  _signOut(BuildContext context) async {
    try {
      await Auth().signOut();
      if (!context.mounted) return;
      context.go('/sign_in');
    } on FirebaseAuthException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error signing out'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
