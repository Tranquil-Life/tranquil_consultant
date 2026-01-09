import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:uuid/uuid.dart';

const insuficientFundsMessage =
    'You dont have enough funds to schedule a meeting with this consultant';
const cardSaveLimitExceededMessage = 'Your card slot is full';
const fileMaxSize = "File must be less than 2 MB";
const emptyCvField = "Your resumé is required";
const emptyIdField = "A means of identification is required";

const cardAspectRatio = 1.586;

double? chatBoxMaxWidth;
const uidGenerator = Uuid();

final deviceInfoPlugin = DeviceInfoPlugin();
num? androidVersion;

// const secureStore = FlutterSecureStorage();
final fluttermojiFunctions = FluttermojiFunctions();

//Meeting extension
const requestingExtension = "requesting-extension";
const acceptedExtension = "accepted-extension";
const declinedExtension = "declined-extension";
const meetingExtended = "meeting-extended";

//video call
const incomingCall = "incoming-call";
const declinedCall = "declined-call";
const acceptedCall = "accepted-call";
const cancelledCall = "cancelled-call";

//User types
const consultant = "consultant";
const client = "client";

int myId = UserModel.fromJson(userDataStore.user).id!;
String authToken = UserModel.fromJson(userDataStore.user).authToken!;
String? stripeAccountId = UserModel.fromJson(userDataStore.user).stripeAccountId;

const String payout = "payout";
const String transfer = "transfer";

//firebase vars
const chatsCollection = "chats";
const messagesCollection = "chat_messages";

//upload types
const profileImage = "profile_image";
const voiceNote = "chat_audio";
const videoIntro = "video_intro";

//notes list view types

const grid = "grid";
const list = "list";

const noInputBio = "No bio available. Please add a short description about yourself.";
const hintBio = "I am a licensed mental health therapist with a decade of experience. I help clients overcome various challenges and enhance their well-being. I apply various therapy modalities to ensure my clients receive the best treatment and care. I offers a safe, supportive, and collaborative space for my clients where they can grow and thrive.";

const successfulUploadMsg = "Upload successful";
const compressingVideoMsg = "Compressing video...";
const uploadingVideoMsg = "Uploading video";

List<String> modalityOptions = [
  "Attachment-Based Therapy",
  "Acceptance & Commitment Therapy",
  "Behavioral Therapy",
  "Behavioral Health Therapy",
  "Bioenergetic Analysis",
  "Cognitive Therapy",
  "Cognitive Behavioral Therapy",
  "Counseling",
  "Dialectical Behavioral Therapy",
  "Dreamwork Therapy",
  "Emotional Freedom Technique",
  "Existential Therapy",
  "Eye Movement Desensitization & Reprocessing",
  "Family & Systemic Psychotherapy",
  "Gestalt Therapy",
  "Integrative Therapy",
];

final titleOptions = [
  'Dr',
  'LPC',
  'LMHC',
  'LCSW',
  'MFT or LMFT',
  'LBA or BCBA',
  'LPC, LMFT, LCSW',
  'Reverend, e.t.c',
  'CADC',
  'ATR or ATR-BC',
  'LPA',
  'BCC'
];

final recipientCountries = [
  'United States',
  'Nigeria',
  'United Kingdom',
  'Ghana',
  'Canada',
  'South Africa'
];

const solo = "solo";
const agency = "agency";
const video = "video";
const picture = "picture";

const verifyIdentityTitle = "Verify your identity";
const agencyVerifyIdentityMsg = "Confirm your affiliation with our partner agency by entering the verification code supplied by your organization. This will ensure a smooth and secure connection between you and Tranquil Life";
const contactAgencyForCodeMsg = "It seems the code you used is incorrect. Please check the code and try again to make sure it is correct. If the issue persists, contact your clinic or reach out to our team at ";
const verifyFailedMsg = "Verification failed";
const verifySuccessMsg = "Verification confirmed";

const email = "email";
const firstName = "first_name";
const lastName = "last_name";
const phoneNumber = "phone_number";
const avatarUrl = "avatar_url";

const verificationCodeMsg = "Check your email or spam for the verification code";
const withdrawFundsTitle = "Withdraw funds";
const withdrawFundsDesc = "Enter your details to receive payment to your local account";
const notConnectedAccountMsg = "No connected account found for this user.";

const String sentryDSN = "https://ffcc9ccf78c403bfe74b17a7ed1b4d1c@o4508213507588096.ingest.us.sentry.io/4510109029498880";

//Settings

var settings = <String, List<Map<String, dynamic>>>{
  "general": [
    {
      "prefix": SvgElements.svgShareIcon,
      "label": "Invite friends",
      "suffix": SvgElements.svgArrowRight,
      "onTap": (){}
    },
    {
      "prefix": SvgElements.svgAboutUs,
      "label": "About Us",
      "suffix": SvgElements.svgArrowRight
    },
    {
      "prefix": SvgElements.svgTermsOfUse,
      "label": "Terms of Use",
      "suffix": SvgElements.svgArrowRight
    },
    {
      "prefix": SvgElements.svgPrivacyPolicy,
      "label": "Privacy Policy",
      "suffix": SvgElements.svgArrowRight
    },
    {
      "prefix": SvgElements.svgWebsite,
      "label": "www.tranquillife.app",
      "suffix": SvgElements.svgArrowRight
    },
  ],
  "security": [
    {
      "prefix": SvgElements.svgManagePwd,
      "label": "Manage password",
      "suffix": SvgElements.svgArrowRight,
      "onTap": (){
        Get.toNamed(Routes.FORGOT_PASSWORD);
      }
    },
    {
      "prefix": SvgElements.svgPinReset,
      "label": "Pin reset",
      "suffix": SvgElements.svgArrowRight
    }
  ],
  "support": [
    {
      "prefix": SvgElements.svgContactUs,
      "label": "Contact us",
      "suffix": SvgElements.svgArrowRight,
      "onTap": (){
      }
    },
    {
      "prefix": SvgElements.svgFeedback,
      "label": "Support & Feedback",
      "suffix": SvgElements.svgArrowRight
    },
    {
      "prefix": SvgElements.svgFaqs,
      "label": "Frequently asked questions (FAQs)",
      "suffix": SvgElements.svgArrowRight
    }
  ]
};

final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();