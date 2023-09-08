import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:share_plus/share_plus.dart';

class DynamicLinkGenerator {
  Future<String> createLink(String userId) async {
    final String url = "https://tranquillife.page.link?link=$userId";

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(url),
      uriPrefix: "https://tranquillife.page.link",
      androidParameters: const AndroidParameters(
          packageName: "com.tranquillife.client", minimumVersion: 1),
      iosParameters:
          const IOSParameters(bundleId: "6450511306", minimumVersion: '1'),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }

  void initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri link = instanceLink.link;

      // Share.share(link.path);
    }
  }
}
