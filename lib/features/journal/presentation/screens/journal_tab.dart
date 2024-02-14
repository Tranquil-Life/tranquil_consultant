import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/selected_note_view.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

class JournalTab extends StatelessWidget {
  const JournalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Journal",
        centerTitle: true,
        hideBackButton: true,
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

class JournalBody extends HookWidget {
  const JournalBody({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    final tabIndex = useState(0);
    useEffect(() {
      tabController.addListener(() {
        tabIndex.value = tabController.index;
      });
      return () {
        tabController.dispose();
      };
    }, [tabController]);

    return Scaffold(
      appBar: const CustomAppBar(
        centerTitle: false,
        title: "My Journal",
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            30,
          ),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                onTap: (v) {
                  tabIndex.value = v;
                },
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return states.contains(MaterialState.focused)
                        ? null
                        : Colors.transparent;
                  },
                ),
                dividerHeight: 2.5,
                dividerColor: ColorPalette.green,
                indicatorColor: Colors.transparent,
                tabs: [
                  Container(
                    height: 40,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      color: tabIndex.value == 0
                          ? ColorPalette.green
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "My notes",
                        style: TextStyle(
                          color:
                              tabIndex.value == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      color: tabIndex.value == 1
                          ? ColorPalette.green
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "Client notes",
                        style: TextStyle(
                          color:
                              tabIndex.value == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ConsultantNote(),
                    SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: const Color(0xfff2f2f2),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            fillColor: Color(0xfff2f2f2),
            border: InputBorder.none,
          ),
          onSubmitted: (val) {},
        ),
      ),
    );
  }
}

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
