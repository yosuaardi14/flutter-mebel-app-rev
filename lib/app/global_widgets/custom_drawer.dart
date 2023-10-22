import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/routes/app_pages.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  final int no;
  const CustomDrawer({Key? key, required this.no}) : super(key: key);

  void toPesanan() {
    if (no != 0) Get.offNamed(Routes.LIST_PESANAN);
  }

  void toBahanBaku() {
    if (no != 1) Get.offNamed(Routes.LIST_BAHAN_BAKU);
  }

  void toUser() {
    if (no != 2) Get.offNamed(Routes.LIST_USER);
  }

  void toActivity() {
    if (no != 4) Get.offNamed(Routes.LIST_ACTIVITY);
  }

  void toCekPesanan() {
    if (no != 7) Get.toNamed(Routes.CEK_PESANAN);
  }

  void logout() async {
    AuthService authService = AuthService();
    await authService.logout();
    Get.offAllNamed(Routes.HOME);
  }

  Color selectedColor(int selected) {
    return no == selected ? Colors.blue : Colors.black;
  }

  Color selectedColor2(int selected) {
    return no == selected ? Colors.white : Colors.black;
  }

  Color? selectedTileColor(int selected) {
    return no == selected ? Colors.blue : null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              child: FlutterLogo(size: 42),
              backgroundColor: Colors.white,
            ),
            accountName: Text("Halo, ${AuthService.userData["nama"]}"),
            accountEmail: Text("${AuthService.userData["nohp"]}"),
          ),
          ListTile(
            textColor: selectedColor(0),
            iconColor: selectedColor(0),
            leading: const Icon(Icons.assignment),
            title: Text(isPembeli() ? "Histori Pesanan" : "Pesanan",
                style: const TextStyle(fontSize: 16)),
            onTap: toPesanan,
          ),
          if (isAdmin())
            ListTile(
              textColor: selectedColor(1),
              iconColor: selectedColor(1),
              leading: const Icon(Icons.border_all),
              title: const Text("Bahan Baku", style: TextStyle(fontSize: 16)),
              onTap: toBahanBaku,
            ),
          if (isAdmin())
            ListTile(
              textColor: selectedColor(2),
              iconColor: selectedColor(2),
              leading: const Icon(Icons.supervisor_account),
              title: const Text("User", style: TextStyle(fontSize: 16)),
              onTap: toUser,
            ),
          if (!isAdmin() && !isPembeli())
            ListTile(
              textColor: selectedColor(7),
              iconColor: selectedColor(7),
              leading: const Icon(Icons.search),
              title: const Text("Cek Pesanan", style: TextStyle(fontSize: 16)),
              onTap: toCekPesanan,
            ),
          if (isAdmin())
            ListTile(
              textColor: selectedColor(4),
              iconColor: selectedColor(4),
              leading: const Icon(Icons.local_activity),
              title: const Text("Aktivitas", style: TextStyle(fontSize: 16)),
              onTap: toActivity,
            ),
          ListTile(
            textColor: selectedColor(3),
            iconColor: selectedColor(3),
            leading: const Icon(Icons.logout),
            title: const Text("Keluar", style: TextStyle(fontSize: 16)),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
