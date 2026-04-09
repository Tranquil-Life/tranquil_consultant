// ignore_for_file: camel_case_types
class window {
  static var location;
  static var localStorage;
}

class document {
  static var body;
}

class FileUploadInputElement {
  String? accept;
  void click() {}
  Stream<dynamic> get onChange => Stream.empty();
  List<dynamic>? files;
}

class FileReader {
  void readAsArrayBuffer(dynamic file) {}
  Stream<dynamic> get onLoadEnd => Stream.empty();
  dynamic result;
}