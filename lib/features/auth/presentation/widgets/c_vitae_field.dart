import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_webview.dart';
import 'package:tl_consultant/app/presentation/widgets/dialogs.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

class CurriculumVitaeField extends StatelessWidget {
  CurriculumVitaeField({Key? key}) : super(key: key);

  final authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cvField(
          onTap: () async{
            showDialog(
                context: Get.context!,
                builder: (_)=>
                    UploadFileDialog(
                      child: GetBuilder<AuthController>(
                        init: AuthController(),
                        builder: (value){
                          return Obx(()=>SizedBox(
                              height: value.uploading.value ? 350 : 264,
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child:
                                  Column(
                                    mainAxisAlignment: value.uploading.value ? MainAxisAlignment.start :MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(value.uploadUrl.value.isNotEmpty)
                                        DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(12),
                                            padding: EdgeInsets.all(6),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              child: GestureDetector(
                                                child: Container(
                                                  height: 200,
                                                  child: CustomWebView(url: value.uploadUrl.value),
                                                  //child: SizedBox(),
                                                ),
                                              ),
                                            )
                                        )
                                      else
                                        DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(12),
                                        padding: EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          child: GestureDetector(
                                            onTap:() async{
                                              if(authController.params.firstName.isNotEmpty
                                                  && authController.params.lastName.isNotEmpty)
                                              {
                                                await MediaService.selectDocument();
                                              }
                                              else{
                                                CustomSnackBar.showSnackBar(
                                                    context: context,
                                                    title: "Error",
                                                    message: "First name and last name are required",
                                                    backgroundColor: ColorPalette.red
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 200,
                                              color: Colors.grey[200],
                                              child: Center(
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: value.uploading.value ?
                                                    [
                                                      const Icon(Icons.upload, color: ColorPalette.green, size: 40),
                                                      const SizedBox(height: 8),
                                                      const Text("Uploading...")
                                                    ] :
                                                    [
                                                      const Icon(Icons.upload, color: ColorPalette.green),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'Browse ',
                                                          children: const [
                                                            TextSpan(
                                                              text: 'your files',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: ColorPalette.black
                                                              ),
                                                            ),
                                                          ],
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              height: 1.4,
                                                              fontFamily: AppFonts.josefinSansRegular,
                                                              color: Theme.of(Get.context!).primaryColor
                                                          ),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const Text("Maximum upload size of 2 MB")
                                                    ]
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Visibility(
                                        visible: value.uploading.value,
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Icons.picture_as_pdf, color: ColorPalette.green),
                                                SizedBox(width: 4),
                                                Text(value.uploadUrl.value.length > 30 ? "${value.uploadUrl.value.substring(0, 30)}..." : ""),
                                                SizedBox(width: 4),
                                                Icon(Icons.cancel, color: Colors.grey,)
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              )
                          ));
                        },
                      ),
                    )).whenComplete((){
                      authController.uploading.value = false;
                      authController.uploadUrl.value = "";
                      authController.cvTEC.text = authController.params.cvUrl;
                    });

          },
        ),
      ),
    );
  }
}
