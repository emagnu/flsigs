//   //
// Import LIBRARIES
import 'package:flutter/material.dart';
// Import FILES
//  PARTS
//  SIGNALS
//   //

class NavItem extends StatelessWidget {
  final String label;
  final Widget screen;

  const NavItem({
    required this.label,
    required this.screen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          ),
        },
      ),
    );
  }
}
