import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_theme.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(widget.title),
      actions: <Widget>[
        Switch.adaptive(
          value: themeProvider.isDarkMode(context),
          onChanged: (value) {
            themeProvider.toggleTheme(value);
          },
        ),
      ],
    );
  }
}
