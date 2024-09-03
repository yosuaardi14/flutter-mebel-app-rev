import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/core/utils/global_functions.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/list_pesanan/controllers/list_pesanan_controller.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ListPesananPage extends StatefulWidget {
  const ListPesananPage({super.key});

  @override
  State<ListPesananPage> createState() => ListPesananController();
}

class ListPesananView extends StatelessWidget {
  final ListPesananController state;
  const ListPesananView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pesanan'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 0),
        floatingActionButtonLocation:
            isAdmin() ? FloatingActionButtonLocation.centerFloat : null,
        floatingActionButton: isAdmin()
            ? FloatingActionButton(
                onPressed: state.onTambahPesanan,
                child: const Icon(Icons.add),
              )
            : null,
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async => state.listData(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: state.index,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        state.typeList.length,
                        (index) => CustomTab(
                          label: state.typeList[index],
                          color: value == index ? Colors.red : Colors.grey,
                          onTap: () => state.onFilterPesanan(index),
                        ),
                      ),
                      // [
                      // CustomTab(
                      //   label: "Hari Ini",
                      //   color: value == 0 ? Colors.red : Colors.grey,
                      //   onTap: () => state.onFilterPesanan(0),
                      // ),
                      // CustomTab(
                      //   label: "Belum Selesai",
                      //   color: value == 1 ? Colors.red : Colors.grey,
                      //   onTap: () => state.onFilterPesanan(1),
                      // ),
                      // CustomTab(
                      //   label: "Selesai",
                      //   color: value == 2 ? Colors.red : Colors.grey,
                      //   onTap: () => state.onFilterPesanan(2),
                      // ),
                      // ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FormBuilderTextField(
                    controller: state.cari,
                    name: "cari",
                    onChanged: state.searchData,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: state.clearSearch,
                        icon: const Icon(Icons.close),
                      ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      hintText: "Cari",
                    ),
                  ),
                ),
                Expanded(
                  child: LoaderNotifierWidget(
                    status: state.status,
                    child: ValueListenableBuilder(
                      valueListenable: state.cari,
                      builder: (context, value, child) {
                        if (value.text.isNotEmpty) {
                          return listData(state.search);
                        }
                        return listData(state.data);
                      },
                    ),
                  ),
                ),
                // Expanded(
                //   child: GetBuilder<ListPesananController>(
                //     init: controller,
                //     builder: (val) => LoaderWidget(
                //       status: controller.status.value,
                //       child: ListView(
                //         children: controller.cari.text != ""
                //             ? [
                //                 ...controller.search!.map(
                //                   (val) => CustomCardPesanan(
                //                     pesanan: val,
                //                     onTap: () => onDetailPesanan(val["id"]),
                //                   ),
                //                 )
                //               ]
                //             : [
                //                 ...controller.data!.map(
                //                   (val) => CustomCardPesanan(
                //                     pesanan: val,
                //                     onTap: () => onDetailPesanan(val["id"]),
                //                   ),
                //                 )
                //               ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listData(ValueNotifier<List<Map<String, dynamic>>?> valueListenable) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        return ListView(
          children: value!
              .map(
                (val) => CustomCardPesanan(
                  pesanan: val,
                  onTap: () => state.onDetailPesanan(val["id"]),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
