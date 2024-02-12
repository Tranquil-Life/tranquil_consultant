import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/features/journal/presentation/screens/consultant_note.dart';

class JournalTab extends HookWidget {
  const JournalTab({super.key});

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
                  children: const [
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
