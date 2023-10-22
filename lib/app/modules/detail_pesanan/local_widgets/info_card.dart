import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/values/constant.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text("${LABEL[label] ?? label}:",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${LABEL[value] ?? value}"),
        ],
      ),
    );
  }
}