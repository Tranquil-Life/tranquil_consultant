import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';

import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/client_note.dart';
import 'package:tl_consultant/features/journal/presentation/screens/consultant_note.dart';
import 'package:tl_consultant/features/journal/presentation/screens/selected_note_view.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tab_bar.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

class JournalTab extends StatelessWidget {
  const JournalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Journal",
        // centerTitle: true,

        hideBackButton: false,
        actions: [
          AppBarAction(
            onPressed: () {},
            child: const Icon(Icons.filter_list_alt),
          ),
        ],
      ),
      body: const UnFocusWidget(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: JournalBody(),
        ),
      ),
    );
  }
}

class JournalBody extends StatefulWidget {
  const JournalBody({super.key});

  @override
  State<JournalBody> createState() => _JournalBodyState();
}

class _JournalBodyState extends State<JournalBody>
    with TickerProviderStateMixin {
  late TabController? controller = TabController(length: 2, vsync: this);

  final searchBarController = TextEditingController();
  int index = 0;
  litenToController() {
    controller!.addListener(
      () {
        setState(() {
          index = controller!.index;
        });
      },
    );
  }

  final NotesController _ = Get.put(NotesController());

  @override
  void initState() {
    _.loadfirstNotes();
    _.scrollController = ScrollController()
      ..addListener(() => _.loadMoreNotes());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            CustomTabbar(
                controller: controller,
                whathappensontap: (int tabindex) {
                  setState(() {
                    HapticFeedback.lightImpact();
                    index = tabindex;
                  });
                },
                tabviewlabel1: "My notes",
                tabviewlabel2: "Client notes"),
            // const SearchBar(),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.filter_1,
                  ),
                ),
                const Text("Filter"),
              ],
            ),
            Expanded(
              child: TabBarView(controller: controller, children: const [
                ConsultantNote(),
                ClientNote(),
              ]),
            ),

            // when the _loadMore function is running
            if (_.isLoadMoreRunning.value == true)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(color: ColorPalette.green),
                ),
              ),
          ],
        ));
  }
}

// class SearchBar extends StatelessWidget {
//   const SearchBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         color: const Color(0xfff2f2f2),
//         child: TextField(
//           autocorrect: false,
//           keyboardType: TextInputType.text,
//           textInputAction: TextInputAction.search,
//           decoration: const InputDecoration(
//             hintText: 'Search',
//             prefixIcon: Padding(
//               padding: EdgeInsets.only(left: 6),
//               child: Icon(Icons.search_rounded),
//             ),
//             prefixIconConstraints: BoxConstraints(minWidth: 48),
//             contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
//             fillColor: Color(0xfff2f2f2),
//             border: InputBorder.none,
//           ),
//           onSubmitted: (val) {},
//         ),
//       ),
//     );
//   }
// }

class NoteGrid extends StatelessWidget {
  const NoteGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
      builder: (_) => Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          controller: _.scrollController,
          itemCount: _.journal.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(
              left: 4,
              right: 4,
              bottom: 8,
              top: 8,
            ),
            child: SelectableNoteWidget(
              sharedNote: _.journal[index],
              onTap: () async {
                await Get.to(
                  NoteView(sharedNote: _.journal[index]),
                );
              },
            ),
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 14,
            mainAxisSpacing: 16,
          ),
        ),
      ),
    );
  }
}

class SelectableNoteWidget extends StatelessWidget {
  final SharedNote sharedNote;
  final Function()? onTap;

  const SelectableNoteWidget({super.key, required this.sharedNote, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: onTap!,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: displayWidth(context) * 0.3,
              ),
              child: NoteWidget(sharedNote: sharedNote)),
        ),
      ],
    );
  }
}
