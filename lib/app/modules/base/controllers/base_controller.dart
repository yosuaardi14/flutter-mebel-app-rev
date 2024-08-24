// ignore_for_file: avoid_shadowing_type_parameters

import 'package:flutter/material.dart';

abstract class BaseController<T extends StatefulWidget> extends State<T> {
  ThemeData get theme => Theme.of(context);
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  ModalRoute? get modalRoute => ModalRoute.of(context);

  Future<T?> openDialog<T>(
    Widget dialog, {
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
}
