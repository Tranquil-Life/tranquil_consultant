import 'dart:ui_web' as ui;
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class DocusignPage extends StatefulWidget {
  const DocusignPage({super.key});

  @override
  State<DocusignPage> createState() => _DocusignPageState();
}

class _DocusignPageState extends State<DocusignPage> {
  final authController = AuthController.instance;
  final String viewType = 'docusign-iframe-${DateTime.now().millisecondsSinceEpoch}'; // Unique ID
  late Future<String> _urlFuture;

  @override
  void initState() {
    super.initState();
    // Start fetching the URL immediately
    _urlFuture = authController.getDocusignUrl();
  }

  void _registerFactory(String url) {
    ui.platformViewRegistry.registerViewFactory(
      viewType,
          (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

        iframe.onLoad.listen((event) {
          try {
            // This will only work if the redirect URL is on YOUR domain (CORS)
            // Cast LocationBase to Location to access the 'href' getter
            final location = (iframe.contentWindow as web.Window).location;
            final currentUrl = location.href;
            if (currentUrl.isNotEmpty && currentUrl.contains('event=signing_complete')) {
              debugPrint("Success! Redirected to: $currentUrl");
              CustomSnackBar.successSnackBar(body: "Success! Redirected to: $currentUrl");
              // Call your navigation logic here
            }
          } catch (e) {
            // Expected while on DocuSign domain
            CustomSnackBar.errorSnackBar("Security boundary: Cannot read URL yet.");
          }
        });

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _urlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Error loading signing document."));
          }

          // Register the factory once we have the data
          _registerFactory(snapshot.data!);

          return HtmlElementView(viewType: viewType);
        },
      ),
    );
  }
}