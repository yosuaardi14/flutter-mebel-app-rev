import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String label;
  final void Function()? onTap;
  final Color? color;

  const CustomTab({Key? key, required this.label, this.onTap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color,
        elevation: 3,
        child: ListTile(
          onTap: onTap ?? () {},
          title: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
