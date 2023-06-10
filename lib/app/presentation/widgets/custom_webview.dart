import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  WebViewController _controller = WebViewController();

  //late String url;
  late bool completed = false;

  @override
  void initState() {
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    }
    else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(
          JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              //TODO: Do not uncomment this
              // if (progress > 50) _onCancelLoading(context);
              //debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              // Get.to(const PaymentWebView(), arguments: {'url': url})!
              //     .then((value) async=> Get.back());

            },
            onPageFinished: (String url) async{
              // if(url.contains("status=completed")){
              //   WalletController.instance.balance.value += double.parse(WalletController.instance.amountController.text);
              //   await Future.delayed(Duration(seconds: 2));
              //   Get.back();
              //}
            },
            // onWebResourceError: (_)=>_onCancelLoading(context),
            onNavigationRequest: (NavigationRequest request) {
              // if (request.url.startsWith(url)) {
              //   debugPrint('blocking navigation to ${request.url}');
              //   Future.delayed(const Duration(seconds: 1),(){
              //     return NavigationDecision.prevent;
              //   });
              // }
              // debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
          )
      )..loadRequest(Uri.parse(widget.url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body:Column(
              children: [
                Expanded(
                  child: WebViewWidget(
                    controller: _controller,
                  ),
                ),
              ],
            )
        )
    );
  }
}
