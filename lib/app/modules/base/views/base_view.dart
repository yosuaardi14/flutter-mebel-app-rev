import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/modules/base/controllers/base_controller.dart';

class BaseView<T extends BaseController> extends StatelessWidget {
  final T state;
  final Widget child;
  const BaseView({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          child,
          ValueListenableBuilder(
            valueListenable: state.showOverlay,
            builder: (context, value, child) {
              if (value) {
                return child!;
              }
              return const SizedBox();
            },
            child: const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: state.showOverlay,
            builder: (context, value, child) {
              if (value) {
                return child!;
              }
              return const SizedBox();
            },
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
