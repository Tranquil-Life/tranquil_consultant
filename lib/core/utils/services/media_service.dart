import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

abstract class MediaService {
  static final _filePicker = FilePicker.platform;
  static final _imagePicker = ImagePicker();
  static final _imageCropper = ImageCropper();

  static Future<File?> openCamera([
    ImageSource source = ImageSource.camera,
  ]) async {
    final XFile? capturedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
      maxHeight: 720,
      maxWidth: 720,
    );
    if (capturedFile == null) return null;
    return _cropImage(File(capturedFile.path));
  }

  static Future<File?> selectImage([
    ImageSource source = ImageSource.gallery,
  ]) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
      maxHeight: 720,
      maxWidth: 720,
    );
    if (pickedFile == null) return null;
    // return _cropImage(File(pickedFile.path));
    recognizedText(pickedFile.path);
    return null;
  }

  static Future<File?> selectAudio() => _selectFile(type: FileType.audio);

  static Future<File?> selectDocument(
          {List<String>? allowedExtensions, String? uploadTpe}) =>
      _selectFile(
          type: FileType.any,
          allowedExtensions: allowedExtensions,
          uploadType: uploadTpe);

  ///Returns a jpg image file
  static Future<File?> generateVideoThumb(
    String path, {
    bool fromFile = false,
    int? maxHeight,
  }) async {
    if (fromFile) {
      final data = await VideoThumbnail.thumbnailData(
        maxHeight: chatBoxMaxWidth!.round(),
        imageFormat: ImageFormat.JPEG,
        quality: 75,
        video: path,
      );
      if (data == null) return null;
      return File.fromRawPath(data);
    }
    final data = await VideoThumbnail.thumbnailFile(
      maxHeight: maxHeight ?? chatBoxMaxWidth!.round(),
      imageFormat: ImageFormat.JPEG,
      quality: 75,
      video: path,
    );
    if (data == null) return null;
    return File(data);
  }

  static Future<File?> _selectFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    String? uploadType,
  }) async {
    FilePickerResult? result = await _filePicker.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    if (result == null) return null;

    if (uploadType == "cv") {
      AuthController.instance.uploadCv(file: File(result.files.first.path!));
    }

    return File(result.files.first.path!);
  }

  static Future<File?> _cropImage(File file) async {
    var croppedFile = await _imageCropper.cropImage(
        sourcePath: file.path, compressQuality: 75);
    if (croppedFile == null) return null;
    AuthController.instance.uploadID(file: File(croppedFile.path));
    return File(croppedFile.path);
  }

  //Recognize image text method
  static Future<void> recognizedText(String pickedImage) async {
    var extractedText;
    if (pickedImage == null) {
      Get.snackbar("Error", "image is not selected",
          backgroundColor: ColorPalette.red);
    } else {
      extractedText = '';
      var textRecognizer = GoogleMlKit.vision.textRecognizer();
      final visionImage = InputImage.fromFilePath(pickedImage);
      try {
        var visionText = await textRecognizer.processImage(visionImage);
        for (TextBlock textBlock in visionText.blocks) {
          for (TextLine textLine in textBlock.lines) {
            for (TextElement textElement in textLine.elements) {
              extractedText = extractedText + textElement.text;
            }
          }
        }
        // var found = extractSubstring(extractedText);
        // print(findLastExpSubstring(extractedText));
        // print(found);
        print('extractedText: $extractedText');
        var next35 =
            extractCharAfterLastExp(extractedText.toString().toLowerCase());
        print(next35);
      } catch (e) {
        Get.snackbar("Error", e.toString(), backgroundColor: ColorPalette.red);
      }
    }
  }

  static String extractCharAfterLastExp(String input) {
    List<String> wordsAndSentences = input.split(' ');

    String result = '';
    int lastExpIndex = -1;

    for (int i = 0; i < wordsAndSentences.length; i++) {
      String wordOrSentence = wordsAndSentences[i];

      if (wordOrSentence.contains('exp')) {
        lastExpIndex = wordOrSentence.lastIndexOf('exp');

        if (lastExpIndex + 35 < wordOrSentence.length) {
          result =
              wordOrSentence.substring(lastExpIndex + 3, lastExpIndex + 38);

          if (i + 1 < wordsAndSentences.length) {
            result += ' ${wordsAndSentences[i + 1]}';
          }
          break;
        }
      }
    }

    return result;
  }
}
//"FEDERAL REPUBLIC OF NIGERIA NATIONAL DRIVERS LICENCE LINO AKWO6968AA2 L1 SAMPLE QLami Sample SAMPLE, JELANI 123 MAIN STREET LEGAL DEPT, FRSC HQTRS WUSE ZONE 7, ABUJA SEX M DofB 06-11-1974EXP06-11-2014 BG A+ PRIVATE END M,1 Nof K 000-000-0000 HOLDER'S HT 1.75M FIMARKs N SIGNATURE LAGOS STATE CLASS B BISs 24-04-2009 DATE OF 1st ISS 24-04-2009 1st iSs ST FCT GL N REP0 REN 0 AUTHoRISED SIGNATORY 1,024 x 568 "
//"JNITED KINGDOM OF GREAT BRITAIN AND NORTH PASSPORT PASSEPORT Type/Type P Surname/Nom (1) Code/Code GBR Given names/Prénoms (2) Nationality/Nationalité (3) BRITISH CITIZEN Date of birth/Date de naissance (4) Passpor Sex/Sexe (5) Place of birth/Lieu de naissance (6) F 0CC. PALESTINIAN T. Date of issue/Date de délivrance (7) 08 JUN /JUIN 21 Date of expiry/Date d'expiration (9) 08 JUN /JUIN 31 Authority/ Autorité HMPO "
//"UNITED STATES OF AMIERICA *PASPORT CAAD * M6131821-07 Nation ality USA Surname TRAVELER Given Names HAPPY Passport Card ho C03005988 EXEMPLAR Sex Date of Birth M1 JAN 1981 Ptace ot Birth NEW YORK. U.S.A. Jasued On Expires On 30 NOV 2009 29 NOV 2019 1-02781-0 UNITED STATrEe DEPARTMENT OF BTATE Mi Sprinie "
//PASSPORT PASSEPORT TypeType me/Nom MARTIN SARAH Natio CANADA Issuing CountrylPays emeteur CAN mes/Prenoms lationalité CANADIAN/CANADIENNE 01 AUG/AOÛT 1990 Place of bitl OTTAWA CAN halssac 14 JANlJAN 2023 Date d'expiration AuthoritylAutorité delivrance 14JAN/JAN 2033 GATINEAU PPCANMARTINK<SARAH<<<<«<««< P123456A A0CAN9008010F3301144< Passport No.IN de passeport P123456AA SexiSexe Sex 01081990 N2033+01AI K<<<<<<<<06 1,000 x 658
