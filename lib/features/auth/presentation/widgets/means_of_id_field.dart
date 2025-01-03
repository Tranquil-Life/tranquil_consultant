import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_webview.dart';
import 'package:tl_consultant/app/presentation/widgets/dialogs.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';


final authController = AuthController.instance;

class MeansOfIdField extends StatefulWidget {
  const MeansOfIdField({Key? key}) : super(key: key);

  @override
  State<MeansOfIdField> createState() => _MeansOfIdFieldState();
}

class _MeansOfIdFieldState extends State<MeansOfIdField> {
  AuthController authController = Get.put(AuthController());

  String dLicense = "Driver’s License";
  String passport = "Passport";

  bool changeType = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: meansOfIdField(
          onTap: () async{
            showDialog(
                context: Get.context!,
                builder: (_)=>AlertDialog(
                  content: SizedBox(
                    height: 168,
                    child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.back();

                                  showDialog(context: context, builder: (_)
                                  =>AlertDialog(
                                    title: RichText(
                                        text: TextSpan(
                                          text: dLicense,

                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: AppFonts.josefinSansRegular,
                                              color: ColorPalette.black
                                          ),
                                        ),
                                        textAlign: TextAlign.center
                                    ),
                                    content: UploadOptionDialog(option: dLicense))
                                  );
                                },
                                child: Text(
                                  dLicense,
                                  style: TextStyle(fontSize: AppFonts.defaultSize),
                                ),
                              ),

                              const Text(
                                "Or",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20
                                ),
                              ),

                              GestureDetector(
                                onTap: (){
                                  Get.back();
                                  showDialog(context: context, builder: (_)
                                  =>AlertDialog(
                                      title: RichText(
                                          text: TextSpan(
                                            text: passport,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: AppFonts.josefinSansRegular,
                                                color: ColorPalette.black
                                            ),
                                          ),
                                          textAlign: TextAlign.center
                                      ),
                                      content: UploadOptionDialog(option: passport)));
                                },
                                child: Text(
                                  passport,
                                  style: const TextStyle(fontSize: AppFonts.defaultSize),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                )

            ).whenComplete((){
              authController.uploading.value = false;
              authController.uploadUrl.value = "";
              // authController.identityTEC.text = authController.params.identityUrl;
            });

          },
        ),
      ),
    );
  }

  Container UploadOptionDialog({required String option}){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: "Take Photo",
              onPressed: () {
                Get.back();

                MediaService.openCamera()
                    .then((value) => showDialog(context: context, builder: (_)=>UploadDialog()));

              },
            ),

            SizedBox(height: 16),

            CustomButton(
              text: "Upload from Gallery",
              onPressed: () {
                Get.back();

                MediaService.selectImage()
                .then((value) => showDialog(context: context, builder: (_)=>UploadDialog()));
              },
            ),
          ],
        )
    );
  }
}

class UploadDialog extends StatelessWidget {
  UploadDialog({Key? key}) : super(key: key);

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return UploadFileDialog(
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
                                child: SizedBox(
                                  height: 200,
                                  child: CustomWebView(url: value.uploadUrl.value),
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
                                //..
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
                        child: Column(
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

                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    child: CustomButton(
                                      text: "Done",
                                      onPressed: (){
                                        authController.uploading.value = false;
                                        value.uploadUrl.value = "";
                                        // authController.identityTEC.text = authController.params.identityUrl;

                                        Get.back();
                                      },
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  )
              )
          ));
        },
      ),
    );
  }
}
