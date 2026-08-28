import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Stands in for a tab whose real screen hasn't landed yet, so the nav bar
/// has somewhere to go instead of go_router throwing on an unknown route.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: colors.mutedForeground),
            const SizedBox(height: 12),
            Text(
              '$title is on the way',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
