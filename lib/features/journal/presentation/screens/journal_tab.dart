import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

enum JournalSelectType { none, share, delete }

class JournalTab extends StatefulWidget {
  const JournalTab({Key? key}) : super(key: key);

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  NotesController controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Journal",
        centerTitle: true,
        actions: [
          AppBarAction(
              onPressed: (){},
              child: Icon(Icons.filter_list_alt)
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(12),
        child: GetBuilder<NetworkController>(
          init: NetworkController(),
          builder: (value){
            return Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Color(0xfff2f2f2),
                          child: TextField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(Icons.search_rounded),
                              ),
                              prefixIconConstraints: BoxConstraints(minWidth: 48),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                              fillColor: Color(0xfff2f2f2),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (val) {},
                          ),
                        )
                    ),

                    SizedBox(height: 8),

                    Obx(()=>Visibility(
                      visible: value.connectionStatus.value == 0,
                      child: GestureDetector(
                        onTap: ()async => await controller.getJournal().then((value) =>setState(() {})),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No internet connection", style: TextStyle(color: ColorPalette.red),),
                            Icon(Icons.signal_wifi_connected_no_internet_4, color: ColorPalette.red)
                          ],
                        ),
                      ),
                    )),

                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
