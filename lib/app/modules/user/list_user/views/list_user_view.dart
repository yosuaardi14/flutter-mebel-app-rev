import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_drawer.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/list_user/controllers/list_user_controller.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => ListUserController();
}

class ListUserView extends StatelessWidget {
  final ListUserController state;
  const ListUserView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar User'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(no: 2),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: state.onTambahUser,
          child: const Icon(Icons.add),
        ),
        body: SizedBox(
          child: RefreshIndicator(
            onRefresh: () async {
              state.listData();
            },
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
                          onTap: () => state.onFilterUser(0),
                        ),
                        CustomTab(
                          label: "Pekerja",
                          color: value == 1 ? Colors.red : Colors.grey,
                          onTap: () => state.onFilterUser(1),
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
                    // ListView(
                    //   shrinkWrap: true,
                    //   clipBehavior: Clip.antiAlias,
                    //   children:
                    //       ? [
                    //           ...state.search!.map(
                    //             (val) => CustomCardUser(
                    //               user: val,
                    //               onTap: () => state.onDetailUser(val["id"]),
                    //             ),
                    //           )
                    //         ]
                    //       : [
                    //           ...state.data!.map(
                    //             (val) => CustomCardUser(
                    //               user: val,
                    //               onTap: () => state.onDetailUser(val["id"]),
                    //             ),
                    //           )
                    //         ],
                    // ),
                  ),
                ),
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
                (val) => CustomCardUser(
                  user: val,
                  onTap: () => state.onDetailUser(val["id"]),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
