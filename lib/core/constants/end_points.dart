const baseUrl = 'https://3509-197-210-78-22.ngrok-free.app/api/';

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

abstract class EarningsEndpoints {
  static const getInfo = 'consultant/getEarnings';
  static const getTransactions = 'consultant/getEarnings';
}

abstract class JournalEndPoints{
  static const getNotes = 'consultant/listNotes';
}

abstract class MediaEndpoints{
  static const uploadFile = 'consultant/uploadFile';
}

abstract class ChatEndPoints{
  static const uploadChat = 'client/send-message';
  static const uploadFile = 'client/uploadFile';

  static getChats({required int meetingId}) => 'client/get-messages/$meetingId';
}
