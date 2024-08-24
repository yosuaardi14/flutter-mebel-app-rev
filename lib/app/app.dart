import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/themes/app_theme.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Mebel App",
      theme: AppTheme.themeData,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
