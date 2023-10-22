import 'package:flutter/material.dart';

enum Status { none, loading, empty, success, error }

class LoaderWidget extends StatelessWidget {
  final Status status;
  final Widget child;
  const LoaderWidget({super.key, required this.status, required this.child});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.loading:
        return const Center(child: CircularProgressIndicator());
      case Status.success:
        return child;
      case Status.error:
        return const Center(child: Text("Terjadi Kesalahan"));
      case Status.empty:
        return const Center(child: Text("Kosong"));
      default:
        return const SizedBox.shrink();
    }
  }
}
