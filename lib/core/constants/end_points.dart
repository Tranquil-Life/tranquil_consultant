// const baseUrl = 'https://tranquil-api.herokuapp.com/api/';
const baseUrl = 'https://f555-2a00-23ee-17f0-3600-94bc-ed30-c459-fb33.ngrok-free.app/api/';

abstract class AuthEndPoints {
  static const login = 'consultant/login';
  static const register = 'consultant/register';
  static const passwordReset = 'consultant/requestPasswordReset';
  static const logOut = 'consultant/logOut';
}

abstract class ConsultationEndPoints{
  static const getSlots = 'consultant/getSlots';
  static const saveSlots = 'consultant/saveSlots';
  static const deleteSlot = 'consultant/deleteSlot';
  static getMeetings({required int page}) => 'consultant/myMeetings?page=$page';
}

abstract class WalletEndpoints {
  static const getWallet = 'client/getWallet';
  static const pay = 'client/pay';
  static getTransactions({required int page, required int limit}) => 'client/listTransactions/$page/$limit';
}

abstract class JournalEndPoints{
  static const getNotes = 'consultant/listNotes';
}

abstract class MediaEndpoints{
  static const uploadFile = 'consultant/uploadFile';
}
