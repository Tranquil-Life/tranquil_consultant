import 'package:tl_consultant/core/constants/constants.dart';
const baseUrl = 'https://tranquil-api.herokuapp.com/api/';

const host = 'https://eeb9-102-88-68-54.ngrok-free.app';
const exchangeHost = "https://v6.exchangerate-api.com/v6";
// const baseUrl = '$host/api/';

abstract class AuthEndPoints {
  static const login = '$thisUserType/login';
  static const register = '$thisUserType/register';
  static const passwordReset = '$thisUserType/requestPasswordReset';
  static const logOut = '$thisUserType/logOut';
}

abstract class ProfileEndPoints {
  static const get = '$thisUserType/getProfile';
  static const edit = '$thisUserType/edit';
  static const getContinent =
      'https://raw.githubusercontent.com/samayo/country-json/master/src/country-by-continent.json';
  static const updateLocation = '$thisUserType/updateMyLocation';
}

abstract class ConsultationEndPoints {
  static const getSlots = '$thisUserType/getSlots';
  static const saveSlots = '$thisUserType/saveSlots';
  static const deleteSlot = '$thisUserType/deleteSlot';
  static getMeetings({required int page}) =>
      '$thisUserType/myMeetings?page=$page';
}

abstract class WalletEndpoints {
  static const getWallet = '$thisUserType/getEarnings';
  static const pay = '$thisUserType/pay';
  static getTransactions({required int page, required int limit}) =>
      '$thisUserType/listTransactions/$page/$limit';
}

abstract class EarningsEndpoints {
  static const getInfo = '$thisUserType/getEarnings';
  static const getTransactions = '$thisUserType/getEarnings';
}

abstract class JournalEndPoints {
  static const addNote = '$thisUserType/addNote';
  static const fetchNote = "$thisUserType/listMyNotes/1/10";
  static const updateNote = "$thisUserType/updateNote";
  static const deleteNote = "$thisUserType/deleteNote";

  static sharedNotes({required int page, required int limit}) =>
      '$thisUserType/listSharedNotes/$page/$limit';
}

abstract class MediaEndpoints {
  static const uploadFile = '$thisUserType/uploadFile';
}

abstract class ChatEndPoints {
  static const sendChat = '$thisUserType/send-message';
  static const generateToken = '$thisUserType/generateToken';
  static const getChatInfo = '$thisUserType/create-chat';
  static getRecentMessages({required int chatId}) =>
      'client/get-recent-messages/$chatId';
  static getOlderMessages({required int chatId, required int lastMessageId}) =>
      'client/get-older-messages/$chatId/$lastMessageId';
}
