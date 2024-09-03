import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/list_bahan_baku/controllers/list_bahan_baku_controller.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ListBahanBakuPage extends StatefulWidget {
  const ListBahanBakuPage({super.key});

  @override
  State<ListBahanBakuPage> createState() => ListBahanBakuController();
}

class ListBahanBakuView extends StatelessWidget {
  final ListBahanBakuController state;
  const ListBahanBakuView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Bahan Baku'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: state.onTambahBahanBaku,
          child: const Icon(Icons.add),
        ),
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async => state.listData(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ValueListenableBuilder(
                  valueListenable: state.index,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomTab(
                          label: "Semua",
                          color: value == 0 ? Colors.red : Colors.grey,
                          onTap: () => state.onFilterBahanBaku(0),
                        ),
                        CustomTab(
                          label: "Kosong",
                          color: value == 1 ? Colors.red : Colors.grey,
                          onTap: () => state.onFilterBahanBaku(1),
                        ),
                      ],
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
                //   flex: 8,
                //   child: GetBuilder<ListBahanBakuController>(
                //     init: controller,
                //     builder: (val) => LoaderWidget(
                //       status: controller.status.value,
                //       child: ListView(
                //         children: controller.cari.text != ""
                //             ? [
                //                 ...controller.search!.map(
                //                   (val) => CustomCardBahanBaku(
                //                     bahanBaku: val,
                //                     onTap: () => onDetailBahanBaku(val["id"]),
                //                   ),
                //                 )
                //               ]
                //             : [
                //                 ...controller.data!.map(
                //                   (val) => CustomCardBahanBaku(
                //                     bahanBaku: val,
                //                     onTap: () => onDetailBahanBaku(val["id"]),
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
                (val) => CustomCardBahanBaku(
                  bahanBaku: val,
                  onTap: () => state.onDetailBahanBaku(val["id"]),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
