import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:uuid/uuid.dart';

const insuficientFundsMessage =
    'You dont have enough funds to schedule a meeting with this consultant';
const cardSaveLimitExceededMessage = 'Your card slot is full';
const agoraId = 'a2782460e26a405cb9ffda0ae62e8038';
const paystackPublicKey = 'pk_test_2442c1c75c79a8cbd1fdd8cba558a68ea1dd8524';
const agoraAppId = 'a2782460e26a405cb9ffda0ae62e8038';
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

//User types
const consultant = "consultant";
const client = "client";

const thisUserType = consultant;

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
