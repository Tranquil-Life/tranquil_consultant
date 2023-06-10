//const baseUrl = 'https://tranquil-api.herokuapp.com/api/';
const baseUrl = 'https://abea-197-210-79-110.ngrok-free.app/api/';

abstract class AuthEndPoints {
  static const login = 'client/login';
  static const register = 'client/register';
  static const isAuthenticated = 'client/isAuthenticated';
  static const passwordReset = 'client/requestPasswordReset';
  static const logOut = 'client/logOut';
}

abstract class MediaEndpoints{
  static const uploadFile = 'consultant/uploadFile';
}
