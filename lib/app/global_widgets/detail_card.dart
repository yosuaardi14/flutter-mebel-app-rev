import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String? label;
  final String? value;

  const DetailCard({
    Key? key,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          Card(
            elevation: 3,
            child: ListTile(
              dense: true,
              title: Text(
                value ?? "",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ]);
  }
}
