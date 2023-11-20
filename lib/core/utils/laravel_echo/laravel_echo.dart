import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:tl_consultant/core/constants/end_points.dart';

class LaravelEcho{
  static LaravelEcho? _singleton;
  static late Echo _echo;
  final String token;

  LaravelEcho({required this.token}){
    _echo = createLaravelEcho(token);
  }

  factory LaravelEcho.init({
    required String token
  }){
    if(_singleton == null || token != _singleton?.token){
      _singleton = LaravelEcho(token: token);
    }

    return _singleton!;
  }

  static Echo get instance => _echo;
  static String get socketId => _echo.socketId() ?? "1111.1111111";

}


class PusherConfig{
  static const appId = "1703011";
  static const key = "ae0d0595bd7cd23b5dd5";
  static const secret = "9f5b8760320dca0a5a30";
  static const cluster = "eu";
  static const hostEndPoint = host;
  static const hostAuthEndPoint = '$hostEndPoint/broadcasting/auth';
  // static const hostAuthEndPoint = "$hostEndPoint/api/broadcasting/auth";
  static const port = 6001;
}

PusherClient createPusherClient(String token) {
   PusherOptions options = PusherOptions(
      cluster: PusherConfig.cluster,
      host: PusherConfig.hostEndPoint,
      wsPort: PusherConfig.port,
      encrypted: true,
      auth: PusherAuth(
        PusherConfig.hostAuthEndPoint,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      )
   );

   PusherClient pusherClient = PusherClient(
       PusherConfig.key,
       options,
       autoConnect: false,
       enableLogging: true
   );

   return pusherClient;
}

Echo createLaravelEcho(String token){
  return Echo(
      client: createPusherClient(token),
      broadcaster: EchoBroadcasterType.Pusher
  );
}