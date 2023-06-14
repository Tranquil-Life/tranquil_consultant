//const baseUrl = 'https://tranquil-api.herokuapp.com/api/';
const baseUrl = 'https://9191-197-210-79-91.ngrok-free.app/api/';

abstract class AuthEndPoints {
  static const login = 'consultant/login';
  static const register = 'consultant/register';
  static const isAuthenticated = 'consultant/isAuthenticated';
  static const passwordReset = 'consultant/requestPasswordReset';
  static const logOut = 'consultant/logOut';
}

abstract class MediaEndpoints{
  static const uploadFile = 'consultant/uploadFile';
}
