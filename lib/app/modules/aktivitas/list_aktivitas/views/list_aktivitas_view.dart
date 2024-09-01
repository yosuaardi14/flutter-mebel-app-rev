import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/controllers/list_aktivitas_controller.dart';

class ListAktivitasPage extends StatefulWidget {
  const ListAktivitasPage({super.key});

  @override
  State<ListAktivitasPage> createState() => ListAktivitasController();
}

class ListAktivitasView extends StatelessWidget {
  final ListAktivitasController state;
  const ListAktivitasView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Aktivitas'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 4),
        floatingActionButtonLocation:
            isAdmin() ? FloatingActionButtonLocation.centerFloat : null,
        floatingActionButton: isAdmin()
            ? FloatingActionButton(
                onPressed: state.onTambahAktivitas,
                child: const Icon(Icons.add),
              )
            : null,
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async {
              state.listData();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // GetBuilder<ListAktivitasController>(
                //   init: controller,
                //   builder: (val) => Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       CustomTab(
                //         label: "Hari Ini",
                //         color: controller.index.value == 0
                //             ? Colors.red
                //             : Colors.grey,
                //         onTap: () {
                //           controller.index(0);
                //           controller.type("today");
                //           controller.listData();
                //         },
                //       ),
                //       CustomTab(
                //         label: "Belum Selesai",
                //         color: controller.index.value == 1
                //             ? Colors.red
                //             : Colors.grey,
                //         onTap: () {
                //           controller.index(1);
                //           controller.type("belumSelesai");
                //           controller.listData();
                //         },
                //       ),
                //       CustomTab(
                //         label: "Selesai",
                //         color: controller.index.value == 2
                //             ? Colors.red
                //             : Colors.grey,
                //         onTap: () {
                //           controller.index(2);
                //           controller.type("selesai");
                //           controller.listData();
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 4),
                //   child: FormBuilderTextField(
                //     controller: controller.cari,
                //     name: "cari",
                //     onChanged: (value) {
                //       controller.searchData();
                //     },
                //     decoration: InputDecoration(
                //       prefixIcon: const Icon(Icons.search),
                //       suffixIcon: IconButton(
                //         onPressed: () {
                //           controller.cari.text = "";
                //         },
                //         icon: const Icon(Icons.close),
                //       ),
                //       errorMaxLines: 2,
                //       border: const OutlineInputBorder(),
                //       isDense: true,
                //       hintText: "Cari",
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: GetBuilder<ListAktivitasController>(
                //     init: controller,
                //     builder: (val) => LoaderWidget(
                //       status: state.status.value,
                //       child: ListView(
                //         children: [
                //           ...state.data!.map(
                //             (val) => CustomCardAktivitas(
                //               aktivitas: val,
                //               onTap: () => onEditAktivitas(val["id"]),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: LoaderNotifierWidget(
                    status: state.status,
                    child: ValueListenableBuilder(
                      valueListenable: state.data,
                      builder: (context, value, child) {
                        return ListView(
                          children: [
                            ...value!.map(
                              (val) => CustomCardAktivitas(
                                aktivitas: val,
                                onTap: () => state.onEditAktivitas(val["id"]),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
