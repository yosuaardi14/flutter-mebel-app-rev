import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/bindings/add_aktivitas_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/views/add_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/bindings/list_aktivitas_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/views/list_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/bindings/cek_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/views/cek_pesanan_view.dart';
import 'package:get/get.dart';

import '../modules/add_bahan_baku/bindings/add_bahan_baku_binding.dart';
import '../modules/add_bahan_baku/views/add_bahan_baku_view.dart';
import '../modules/add_pesanan/bindings/add_pesanan_binding.dart';
import '../modules/add_pesanan/views/add_pesanan_view.dart';
import '../modules/add_user/bindings/add_user_binding.dart';
import '../modules/add_user/views/add_user_view.dart';
import '../modules/detail_bahan_baku/bindings/detail_bahan_baku_binding.dart';
import '../modules/detail_bahan_baku/views/detail_bahan_baku_view.dart';
import '../modules/detail_pesanan/bindings/detail_pesanan_binding.dart';
import '../modules/detail_pesanan/views/detail_pesanan_view.dart';
import '../modules/detail_user/bindings/detail_user_binding.dart';
import '../modules/detail_user/views/detail_user_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/list_bahan_baku/bindings/list_bahan_baku_binding.dart';
import '../modules/list_bahan_baku/views/list_bahan_baku_view.dart';
import '../modules/list_pesanan/bindings/list_pesanan_binding.dart';
import '../modules/list_pesanan/views/list_pesanan_view.dart';
import '../modules/list_user/bindings/list_user_binding.dart';
import '../modules/list_user/views/list_user_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LIST_BAHAN_BAKU,
      page: () => ListBahanBakuView(),
      binding: ListBahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.LIST_USER,
      page: () => ListUserView(),
      binding: ListUserBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_BAHAN_BAKU,
      page: () => DetailBahanBakuView(),
      binding: DetailBahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BAHAN_BAKU,
      page: () => AddBahanBakuView(),
      binding: AddBahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.ADD_USER,
      page: () => AddUserView(),
      binding: AddUserBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_USER,
      page: () => DetailUserView(),
      binding: DetailUserBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PESANAN,
      page: () => AddPesananView(),
      binding: AddPesananBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PESANAN,
      page: () => DetailPesananView(),
      binding: DetailPesananBinding(),
    ),
    GetPage(
      name: _Paths.LIST_PESANAN,
      page: () => ListPesananView(),
      binding: ListPesananBinding(),
    ),
    GetPage(
      name: _Paths.CEK_PESANAN,
      page: () => CekPesananView(),
      binding: CekPesananBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ACTIVITY,
      page: () => AddAktivitasView(),
      binding: AddAktivitasBinding(),
    ),
    GetPage(
      name: _Paths.LIST_ACTIVITY,
      page: () => ListAktivitasView(),
      binding: ListAktivitasBinding(),
    ),
  ];
}