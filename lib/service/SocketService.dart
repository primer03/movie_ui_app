import 'dart:convert';

import 'package:bloctest/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bloctest/models/user_model.dart' as userModel;

IO.Socket? socket;

void setupSocket() async {
  // ถ้า socket ไม่ใช่ null หรือยังไม่ได้เชื่อมต่อ ให้ตั้งค่าใหม่
  if (socket != null && socket!.connected) {
    print('Socket is already connected');
    return; // ถ้ามีการเชื่อมต่ออยู่แล้ว ไม่ต้องเชื่อมต่อใหม่
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
    print('Connected');
    print('User token: ${await novelBox.get('usertoken')}');
    userModel.User user =
        userModel.User.fromJson(json.decode(await novelBox.get('user')));
    print('User ID: ${user.userid}');
    socket!.emit('usermobile_online', user.userid);
  });

  socket!.on('message', (data) {
    print('Message from server: $data');
  });

  socket!.onDisconnect((_) {
    print('Disconnected');
  });

  socket!.connect();
}

void disconnectSocket() {
  if (socket != null && socket!.connected) {
    socket!.disconnect();
    socket!.clearListeners(); // Remove all listeners
    socket = null; // Clear socket reference
    print('Socket disconnected and cleared');
  }
}

void reconnectSocket() {
  if (socket == null || !socket!.connected) {
    setupSocket(); // เรียกฟังก์ชัน setupSocket เพื่อเชื่อมต่อใหม่
    print('Socket reconnected');
  }
}
