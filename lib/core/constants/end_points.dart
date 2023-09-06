const baseUrl = 'https://1ece-197-210-55-243.ngrok-free.app/api/';

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
  static const uploadChat = 'consultant/send-message';
  static const uploadFile = 'consultant/uploadFile';
  static clientName({required int clientId}) => 'consultant/getClientName/$clientId';

  static getChats({required int meetingId}) => 'consultant/get-messages/$meetingId';
}
