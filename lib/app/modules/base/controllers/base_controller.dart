// ignore_for_file: avoid_shadowing_type_parameters

import 'package:flutter/material.dart';

abstract class BaseController<T extends StatefulWidget> extends State<T> {
  final ValueNotifier<bool> showOverlay = ValueNotifier(false);

  ThemeData get theme => Theme.of(context);
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  ModalRoute? get modalRoute => ModalRoute.of(context);

  void back() {
    Navigator.pop(context);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Future<T?> openDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) async {
    return showDialog(
      context: context,
      builder: (ctx) => dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }

  Future<void> showInfoDialog({
    required String title,
    required String content,
    void Function()? onPressed,
  }) {
    return openDialog(
      barrierDismissible: false,
      dialog: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onPressed == null) {
                return;
              }
              onPressed();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  Future<bool> showConfirmationDialog({
    required String title,
    required String content,
  }) async {
    return await openDialog<bool?>(
          barrierDismissible: false,
          dialog: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Tidak"),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Ya"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> showConfirmationDeleteDialog(BuildContext context) async {
    return showConfirmationDialog(
      title: "Konfirmasi Hapus",
      content: "Apa Anda yakin ingin menghapus ini?",
    );
  }

  Future<bool> showConfirmationAddDialog(BuildContext context) async {
    return showConfirmationDialog(
      title: "Konfirmasi Tambah",
      content: "Apa Anda yakin ingin menambah ini?",
    );
  }

  Future<bool> showConfirmationEditDialog(BuildContext context) async {
    return showConfirmationDialog(
      title: "Konfirmasi Ubah",
      content: "Apa Anda yakin ingin mengubah ini?",
    );
  }

  Future<bool> showConfirmationSaveDialog(BuildContext context) async {
    return showConfirmationDialog(
      title: "Konfirmasi Simpan",
      content: "Apa Anda yakin ingin menyimpan perubahan ini?",
    );
  }
}
