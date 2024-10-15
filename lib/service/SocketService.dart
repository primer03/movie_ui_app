import 'dart:convert';
import 'package:bloctest/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/web.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bloctest/models/user_model.dart' as userModel;

IO.Socket? socket;

Future<bool> checkInternetConnection() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  // ถ้า connectivityResult มีค่า none แสดงว่าไม่มีการเชื่อมต่ออินเทอร์เน็ต
  print('Connectivity result: $connectivityResult');
  // false แสดงว่าไม่มีการเชื่อมต่ออินเทอร์เน็ต
  return connectivityResult.contains(ConnectivityResult.none) ? false : true;
}

void setupSocket() async {
  // ถ้า socket ไม่ใช่ null หรือยังไม่ได้เชื่อมต่อ ให้ตั้งค่าใหม่
  if (socket != null && socket!.connected) {
    Logger().i('Socket is already connected');
    return; // ถ้ามีการเชื่อมต่ออยู่แล้ว ไม่ต้องเชื่อมต่อใหม่
  } else {
    Logger().i('Socket is not connected $socket');
  }

  // Check internet connection
  if (!await checkInternetConnection()) {
    Logger().i('No internet connection. Cannot connect to socket');
    return;
  } else {
    Logger().i('Internet connection available. Connecting to socket...');
  }

  socket = IO.io(
    'https://pzfbh88v-3002.asse.devtunnels.ms',
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );

  // ฟังก์ชันที่ใช้เมื่อเชื่อมต่อสำเร็จ
  socket!.onConnect((_) async {
    // print('Connected');
    Logger().i('Socket connected');
    // print('User token: ${await novelBox.get('usertoken')}');
    userModel.User user =
        userModel.User.fromJson(json.decode(await novelBox.get('user')));
    // print('User ID: ${user.userid}');
    socket!.emit('usermobile_online', user.userid);
  });

  socket!.on('message', (data) {
    print('Message from server: $data');
  });

  socket!.onDisconnect((_) async {
    if (!await checkInternetConnection()) {
      Logger().i('Disconnected from socket. No internet connection');
    } else {
      Logger().i('Disconnected from socket. Reconnecting...');
    }
    Logger().e('Socket disconnected');
  });

  socket!.connect();
}

void disconnectSocket() {
  if (socket != null && socket!.connected) {
    socket!.disconnect();
    socket!.clearListeners(); // Remove all listeners
    socket = null; // Clear socket reference
    if (socket == null) {
      Logger().i('Socket disconnected and cleared');
    }
  }
}

void reconnectSocket() async {
  if (socket == null || !socket!.connected) {
    // Check internet connection before reconnecting
    if (await checkInternetConnection()) {
      print('Reconnecting to socket...');
      setupSocket();
      print('Socket reconnected');
    } else {
      print('No internet connection. Cannot reconnect to socket.');
    }
  }
}
