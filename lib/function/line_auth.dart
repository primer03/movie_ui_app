import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void lineSDKInit() async {
  await LineSDK.instance.setup("2002469697").then((_) {
    print("LineSDK is Prepared");
  });
}

Future getAccessToken() async {
  try {
    final result = await LineSDK.instance.currentAccessToken;
    return result!.value;
  } on PlatformException catch (e) {
    print(e.message);
  }
}

void startLineLogin(BuildContext context) async {
  try {
    final result = await LineSDK.instance.login(scopes: ["profile"]);
    // Navigator.of(context).pop();
    print(result.toString());
    var accesstoken = await getAccessToken();
    var displayname = result.userProfile?.displayName;
    var statusmessage = result.userProfile?.statusMessage;
    var imgUrl = result.userProfile?.pictureUrl;
    var userId = result.userProfile?.userId;

    print("AccessToken> " + accesstoken);
    print("DisplayName> " + displayname!);
    print("StatusMessage> " + statusmessage!);
    print("ProfileURL> " + imgUrl!);
    print("userId> " + userId!);
  } on PlatformException catch (e) {
    print(e);
    switch (e.code.toString()) {
      case "CANCEL":
        print("User Cancel the login");
        break;
      case "AUTHENTICATION_AGENT_ERROR":
        print("User decline the login");
        break;
      default:
        print("Unknown but failed to login");
        break;
    }
  }
}

void logoutLine() async {
  try {
    await LineSDK.instance.logout();
  } on PlatformException catch (e) {
    print(e.message);
  }
}
