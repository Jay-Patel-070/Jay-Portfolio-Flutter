import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/theme_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavigationBar extends ConsumerWidget implements PreferredSizeWidget {
  final Map<String, GlobalKey> sectionKeys;

  const CustomNavigationBar({Key? key, required this.sectionKeys}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _scrollToSection(BuildContext context, GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
    // If it's a mobile drawer, close it
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    Widget themeToggle = IconButton(
      icon: FaIcon(isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon, size: 20, color: Theme.of(context).iconTheme.color),
      onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
    );

    return AppBar(
      title: Text(
        'PORTFOLIO_OS', 
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          letterSpacing: 2, 
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      elevation: 0,
      centerTitle: !isDesktop,
      actions: [
        if (isDesktop) ...[
          for (var entry in sectionKeys.entries)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () => _scrollToSection(context, entry.value),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                child: Text(
                  entry.key, 
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
        themeToggle,
        const SizedBox(width: 16),
      ],
      // If mobile/tablet, it will automatically show the drawer icon if a Drawer is provided in Scaffold.
    );
  }
}

class MobileDrawer extends ConsumerWidget {
  final Map<String, GlobalKey> sectionKeys;

  const MobileDrawer({Key? key, required this.sectionKeys}) : super(key: key);

  void _scrollToSection(BuildContext context, GlobalKey key) {
    Navigator.pop(context); // Close Drawer
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                'PORTFOLIO_OS',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          for (var entry in sectionKeys.entries)
            ListTile(
              title: Text(
                entry.key,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _scrollToSection(context, entry.value),
            ),
        ],
      ),
    );
  }
}
