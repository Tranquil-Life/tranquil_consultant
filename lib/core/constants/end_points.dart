//const baseUrl = 'https://tranquil-api.herokuapp.com/api/';
const baseUrl = 'https://42d2-197-210-78-170.ngrok-free.app/api/';

abstract class AuthEndPoints {
  static const login = 'consultant/login';
  static const register = 'consultant/register';
  static const isAuthenticated = 'consultant/isAuthenticated';
  static const passwordReset = 'consultant/requestPasswordReset';
  static const logOut = 'consultant/logOut';
}

abstract class ConsultationEndPoints{
  static const getSlots = 'consultant/getSlots';
  static const saveSlots = 'consultant/saveSlots';
  static const deleteSlot = 'client/deleteSlot';
  static const getMeetings = 'client/getMeetings';
}

abstract class JournalEndPoints{
  static const getNotes = 'consultant/listNotes';
}

abstract class MediaEndpoints{
  static const uploadFile = 'consultant/uploadFile';
}
