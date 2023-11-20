import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

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

                    const SizedBox(height: 8),

                    // Obx(()=>Visibility(
                    //   visible: value.connectionStatus.value == 0,
                    //   child: GestureDetector(
                    //     onTap: ()async => await controller.getJournal().then((value) =>setState(() {})),
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text("No internet connection", style: TextStyle(color: ColorPalette.red),),
                    //         Icon(Icons.signal_wifi_connected_no_internet_4, color: ColorPalette.red)
                    //       ],
                    //     ),
                    //   ),
                    // )),

                    // Expanded(
                    //   child: FutureBuilder<List<Note>>(
                    //     future: controller.getJournal(),
                    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                    //       switch(snapshot.connectionState){
                    //         case ConnectionState.waiting:
                    //           return const Center(
                    //             child:  CircularProgressIndicator(color: ColorPalette.green),
                    //           );
                    //         case ConnectionState.active:
                    //         case ConnectionState.done:
                    //           if (!snapshot.hasData || (snapshot.data is List && (snapshot.data as List).isEmpty)) {
                    //             return Column(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 const Text(
                    //                   'You’ll see notes here \nwhen clients share them with you',
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontSize: AppFonts.defaultSize
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 12),
                    //                 Image.asset(
                    //                   'assets/images/no_meeting.png',
                    //                   height: 300,
                    //                   width: 300,
                    //                 ),
                    //               ],
                    //             );
                    //           }
                    //           else{
                    //             return RefreshIndicator(
                    //               color: ColorPalette.green,
                    //               onRefresh: () async => await controller.getJournal().then((value) =>setState(() {})),
                    //               child: SingleChildScrollView(
                    //                 child: Container(
                    //                   margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
                    //                   child: StaggeredGrid.count(
                    //                       crossAxisCount: 2,
                    //                       mainAxisSpacing: 16,
                    //                       crossAxisSpacing: 14,
                    //                       children: List.generate(
                    //                         snapshot.data.length,
                    //                             (i) => NoteWidget(note: snapshot.data[i]),
                    //                       )),
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //         case ConnectionState.none:
                    //         default:
                    //           return const Center(
                    //             child: CircularProgressIndicator(color: ColorPalette.green),
                    //           );
                    //       }
                    //     },
                    //   ),
                    // )

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
