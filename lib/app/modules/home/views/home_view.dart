import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_button.dart';
import 'package:flutter_mebel_app_rev/app/modules/home/controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomeController();
}

class HomeView extends StatelessWidget {
  final HomeController state;
  const HomeView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beranda'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                label: "MASUK",
                onPressed: state.onLogin,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: "MASUK SEBAGAI PEMBELI",
                onPressed: state.onLoginPembeli,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: "CEK PESANAN",
                onPressed: state.onCekPesanan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
