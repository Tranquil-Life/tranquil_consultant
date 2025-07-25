import 'package:tl_consultant/core/constants/constants.dart';

const staging = 'https://tranquil-api-staging-205081a15c84.herokuapp.com';
const production = 'https://tranquil-api.herokuapp.com';
const exchangeHost = "https://v6.exchangerate-api.com/v6";
const baseUrl = '$staging/api/';
const countriesNowBaseUrl = "https://countriesnow.space/api/v0.1/";

abstract class AuthEndPoints {
  static const login = '$consultant/login';
  static const register = '$consultant/register';
  static const passwordReset = '$consultant/requestPasswordReset';
  static const logOut = '$consultant/logOut';
  static const updateFcmToken = '$consultant/generate-device-id';
  static const generateAgoraToken = '$consultant/generateToken';
  static const checkAuthStatus = '$consultant/isAuthenticated';

  //Verify account
  static const requestVerificationToken = '$consultant/accountVerifyRequest';
  static const verifyAccount = '$consultant/verifyAccount';

  //Reset password
  static const requestResetPwdToken = '$consultant/requestPasswordReset';
  static const verifyResetToken = '$consultant/verifyPasswordResetToken';
  static const updatePassword = '$consultant/resetPassword';
}

abstract class ProfileEndPoints {
  static const get = '$consultant/getProfile';
  static const edit = '$consultant/edit';
  static const getContinent =
      'https://raw.githubusercontent.com/samayo/country-json/master/src/country-by-continent.json';
  static const updateLocation = '$consultant/updateMyLocation';
  static const deleteQualification = '$consultant/deleteQualification';
}

abstract class ConsultationEndPoints {
  static const getSlots = '$consultant/getSlots';
  static const saveSlots = '$consultant/saveSlots';
  static const deleteSlot = '$consultant/deleteSlot';
  static getMeetings({required int page}) =>
      '$consultant/myMeetings?page=$page';
}

abstract class WalletEndpoints {
  static const getWallet = '$consultant/getEarnings';
  static const pay = '$consultant/pay';
  static getTransactions({required int page, required int limit}) =>
      '$consultant/listTransactions/$page/$limit';
}

abstract class EarningsEndpoints {
  static const getInfo = '$consultant/getEarnings';
  static const getTransactions = '$consultant/getEarnings';
}

abstract class JournalEndPoints {
  static const addNote = '$consultant/addNote';
  static const fetchNote = "$consultant/listMyNotes/1/10";
  static const updateNote = "$consultant/updateNote";
  static const deleteNote = "$consultant/deleteNote";

  static sharedNotes({required int page, required int limit}) =>
      '$consultant/listSharedNotes/$page/$limit';
  static personalNotes({required int page, required int limit}) =>
    '$consultant/listMyNotes/$page/$limit';    
}

abstract class MediaEndpoints {
  static const uploadFile = '$consultant/uploadFile';
}

abstract class ChatEndPoints {
  static const sendChat = '$consultant/send-message';
  static const generateToken = '$consultant/generateToken';
  static const getChatInfo = '$consultant/create-chat';
  static getRecentMessages({required int chatId}) =>
      'client/get-recent-messages/$chatId';
  static getOlderMessages({required int chatId, required int lastMessageId}) =>
      'client/get-older-messages/$chatId/$lastMessageId';
  static const triggerPusherEvent = '$consultant/triggerPusherEvent';
}

abstract class ActivityEndpoints {
  static getNotifications({required int page, required int limit}) =>
      '$consultant/myActivity/$page/$limit';
  static const unreadNotifications = '$consultant/unreadNotifications';
}

abstract class CountriesNowEndpoints {
  static get getCountries => 'countries';
  static getStates({required String country}) => 'countries/states/q?country=$country';
  static getCities({required String country, required String state}) => 'countries/state/cities/q?country=$country&state=$state';
}