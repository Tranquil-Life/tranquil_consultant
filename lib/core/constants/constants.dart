import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:uuid/uuid.dart';


const insuficientFundsMessage = 'You dont have enough funds to schedule a meeting with this consultant';
const cardSaveLimitExceededMessage = 'Your card slot is full';
const agoraId = 'a2782460e26a405cb9ffda0ae62e8038';
const paystackPublicKey = 'pk_test_2442c1c75c79a8cbd1fdd8cba558a68ea1dd8524';
const pusherKey = '39b14815ce63a5589bf0';
// const agoraAppId = 'ade6f0310bfd4bb1958909adb2565cba';
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