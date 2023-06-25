const baseUrl = 'https://d6e7-102-90-43-164.ngrok-free.app/api/';

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
  static const deleteSlot = 'consultant/deleteSlot';
  static const getMeetings = 'consultant/getMeetings';
}

abstract class JournalEndPoints{
  static const getNotes = 'consultant/listNotes';
}

abstract class MediaEndpoints{
  static const uploadFile = 'consultant/uploadFile';
}
