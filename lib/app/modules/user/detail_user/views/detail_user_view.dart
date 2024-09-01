import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/custom_tab.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/detail_card.dart';
import 'package:flutter_mebel_app_rev/app/global_widgets/loader_widget.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/controllers/detail_user_controller.dart';

class DetailUserPage extends StatefulWidget {
  final String? id;
  const DetailUserPage({super.key, this.id});

  @override
  State<DetailUserPage> createState() => DetailUserController();
}

class DetailUserView extends StatelessWidget {
  final DetailUserController state;
  const DetailUserView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail User'),
          centerTitle: true,
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async => state.getData(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: LoaderBooleanNotifierWidget(
                      isLoading: state.isLoading,
                      child: ValueListenableBuilder(
                        valueListenable: state.detail,
                        builder: (context, detail, child) {
                          return ListView(
                            children: [
                              DetailCard(
                                label: "Nama Lengkap",
                                value: detail?["nama"],
                              ),
                              DetailCard(
                                label: "No HP",
                                value: detail?["nohp"],
                              ),
                              DetailCard(
                                label: "Role",
                                value: detail?["role"],
                              ),
                              DetailCard(
                                label: "Alamat",
                                value: detail?["alamat"],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomTab(
                        label: "Ubah",
                        color: Colors.green,
                        onTap: () => state.onEditUser(state.id!),
                      ),
                      CustomTab(
                        label: "Hapus",
                        color: Colors.red,
                        onTap: state.onDeleteUser,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
