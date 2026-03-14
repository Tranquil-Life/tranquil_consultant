import 'dart:ui_web' as ui;
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:web/web.dart' as web;
import 'dart:html' as html; // Use dart:html for the global window listener
import 'package:flutter/material.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class DocusignPage extends StatefulWidget {
  const DocusignPage({super.key});

  @override
  State<DocusignPage> createState() => _DocusignPageState();
}

class _DocusignPageState extends State<DocusignPage> {
  final authController = AuthController.instance;
  final String viewId = 'docusign-${DateTime.now().millisecondsSinceEpoch}';
  late Future<String> _urlFuture;
  bool _isFactoryRegistered = false;

  @override
  void initState() {
    super.initState();

    // Listen for the postMessage signal from the iframe
    html.window.onMessage.listen((event) {
      // Basic security check: ensure the data is what we expect
      if (event.data == 'SIGNING_COMPLETE') {
        print("Message received from Laravel: ${event.data}");

        authController.signUp();

        // 1. Show your Success SnackBar
        // CustomSnackBar.successSnackBar(body: "Account created successfully!");

        // 2. Navigate the user to the next screen (e.g., Home or Login)
        // Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    _urlFuture = authController.getDocusignUrl().then((url) {
      _registerFactory(url);
      return url;
    });
  }

  void _registerFactory(String url) {
    if (_isFactoryRegistered) return;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
      final iframe = web.HTMLIFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';

      // 1. Hook up the listener first
      iframe.onLoad.listen((event) async{
        print("Iframe successfully loaded!");
        // Give the browser a tiny moment (200ms) to update the security context
        await Future.delayed(const Duration(milliseconds: 200));

        try {
          final window = iframe.contentWindow as web.Window;

          // Accessing .href is the most reliable way to check the origin
          final String currentUrl = window.location.href;
          print("Successfully accessed URL: $currentUrl");

          final String? screenMessage = window.document.body?.innerText;
          print("Screen message: $screenMessage");

          if (screenMessage != null && screenMessage.contains("Thanks!")) {
            CustomSnackBar.successSnackBar(body: "Contract Signed!");
            // Navigate away here
          }
        } catch (e) {
          // This will catch the security error while on DocuSign domain
          debugPrint("On DocuSign domain (URL access restricted)");
        }
      });

      // 2. Set the src last
      iframe.src = url;
      return iframe;
    });

    setState(() {
      _isFactoryRegistered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sign Document',
        centerTitle: true,
        backgroundColor: ColorPalette.scaffoldColor,
      ),
      backgroundColor: ColorPalette.scaffoldColor,
      body: FutureBuilder<String>(
        future: _urlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading document"));
          }

          // Use the registered viewId
          return HtmlElementView(viewType: viewId);
        },
      ),
    );
  }
}
