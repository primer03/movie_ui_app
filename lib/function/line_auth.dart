import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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

Future<String> startLineLogin(BuildContext context) async {
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
    return downloadImage(imgUrl);
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
    return '';
  }
}

void logoutLine() async {
  try {
    await LineSDK.instance.logout();
  } on PlatformException catch (e) {
    print(e.message);
  }
}

Future<String> downloadImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      String fileExtension = '.jpg'; // Default extension

      if (contentType != null) {
        switch (contentType.toLowerCase()) {
          case 'image/jpeg':
            fileExtension = '.jpg';
            break;
          case 'image/png':
            fileExtension = '.png';
            break;
          case 'image/gif':
            fileExtension = '.gif';
            break;
          case 'image/webp':
            fileExtension = '.webp';
            break;
          // Add more cases as needed
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'downloaded_image$fileExtension';
      final filePath = path.join(directory.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
      // print('Image saved at $filePath');
    } else {
      print('Failed to load image: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Error downloading image: $e');
    return '';
  }
}
