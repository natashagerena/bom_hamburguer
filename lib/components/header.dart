import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;

  const AppHeader({
    Key? key,
    required this.title,
    required this.onBack,
    this.trailingIcon,
    this.onTrailingTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[800],
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        if (trailingIcon != null)
          IconButton(
            icon: Icon(trailingIcon, color: Colors.white),
            onPressed: onTrailingTap ?? () {},
          ),
      ],
    );
  }
}
