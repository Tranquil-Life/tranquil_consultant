import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/utils/services/location_service.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/bg.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({Key? key}) : super(key: key);

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();

  Future<void> _getCurrentPosition() async {
    try{
      final hasPermission = await LocationService.handleLocationPermission();
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => authController.currentPosition = position);
        _getAddressFromLatLng(authController.currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });
    }catch(e){
      print("Error: $e");
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        authController.currentAddress =
        '${place.administrativeArea}, ${place.country}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Timer.periodic(const Duration(seconds: 2), (timer) async{
     if(authController.currLocationTEC.text.isNotEmpty){
       timer.cancel();
     }else{
       authController.currLocationTEC.text = authController.currentAddress.toString();
      }
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return CustomBGWidget(
      title: 'Sign Up',
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32, bottom: 20),
              child: Text('Register Account', style: TextStyle(fontSize: 36)),
            ),
            const Text('Complete your profile', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  //Current location
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: currentRegion(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
