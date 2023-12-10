// const baseUrl = 'https://tranquil-api.herokuapp.com/api/';
const host = 'https://2e73-102-88-63-195.ngrok-free.app';
const baseUrl = '$host/api/';


abstract class AuthEndPoints {
  static const login = 'consultant/login';
  static const register = 'consultant/register';
  static const passwordReset = 'consultant/requestPasswordReset';
  static const logOut = 'consultant/logOut';
}

abstract class ProfileEndPoints {
  static const get = 'client/getProfile';
  static const edit = 'client/edit';
}

abstract class ConsultationEndPoints{
  static const getSlots = 'consultant/getSlots';
  static const saveSlots = 'consultant/saveSlots';
  static const deleteSlot = 'consultant/deleteSlot';
  static getMeetings({required int page}) => 'consultant/myMeetings?page=$page';
}

abstract class WalletEndpoints {
  static const getWallet = 'consultant/getWallet';
  static const pay = 'consultant/pay';
  static getTransactions({required int page, required int limit}) => 'consultant/listTransactions/$page/$limit';
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
  static const sendChat = 'consultant/send-message';
  static const generateToken = 'consultant/generateToken';
  static const getChatInfo = 'consultant/create-chat';
  static getRecentMessages({required int chatId}) => 'client/get-recent-messages/$chatId';
  static getOlderMessages({
    required int chatId,
    required int lastMessageId}) => 'client/get-older-messages/$chatId/$lastMessageId';
}
