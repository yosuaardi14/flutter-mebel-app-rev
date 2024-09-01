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

class LoaderNotifierWidget extends StatelessWidget {
  final ValueNotifier<Status> status;
  final Widget child;

  const LoaderNotifierWidget({
    super.key,
    required this.status,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: status,
      builder: (context, value, child) {
        switch (value) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());
          case Status.success:
            return child!;
          case Status.error:
            return const Center(child: Text("Terjadi Kesalahan"));
          case Status.empty:
            return const Center(child: Text("Kosong"));
          default:
            return const SizedBox.shrink();
        }
      },
      child: child,
    );
  }
}

class LoaderBooleanNotifierWidget extends StatelessWidget {
  final ValueNotifier<bool> isLoading;
  final Widget child;

  const LoaderBooleanNotifierWidget({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, child) {
        if (value) {
          return const Center(child: CircularProgressIndicator());
        }
        return child!;
      },
      child: child,
    );
  }
}
