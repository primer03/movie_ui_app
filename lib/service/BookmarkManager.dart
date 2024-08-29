import 'dart:async';

import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';

class BookmarkManager extends ChangeNotifier {
  final BuildContext context;
  final Function(bool) updateBookmarkState;
  bool _isProcessing = false;
  Timer? _cooldownTimer;
  final int _cooldownDuration = 5;
  late FToast fToast; // seconds

  BookmarkManager(this.context, this.updateBookmarkState) {
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> removeBookmark(String bookId) async {
    if (_isProcessing) {
      _showToast('กรุณารอสักครู่ก่อนดำเนินการอีกครั้ง');
      return;
    }

    _isProcessing = true;
    try {
      bool checkRemove = await NovelRepository().removeBookmark(bookId);
      Logger().i('checkremove: $checkRemove');
      updateBookmarkState(!checkRemove);
      String msg = checkRemove
          ? 'ลบหนังสือออกจากชั้นหนังสือแล้ว'
          : 'ลบหนังสือออกจากชั้นหนังสือไม่สำเร็จ';
      _showToast(msg);
    } catch (e) {
      _showToast(e.toString().split(':').last);
    } finally {
      _startCooldown();
    }
  }

  Future<void> addBookmark(DataNovel dataNovel) async {
    if (_isProcessing) {
      _showToast('กรุณารอสักครู่ก่อนดำเนินการอีกครั้ง');
      return;
    }

    _isProcessing = true;
    try {
      bool checkAdd =
          await NovelRepository().addBookmark(dataNovel.novel.bookId);
      Logger().i('checkadd: $checkAdd');
      updateBookmarkState(checkAdd);
      String msg = checkAdd
          ? 'เพิ่มเข้าชั้นหนังสือแล้ว'
          : 'เพิ่มหนังสือเข้าชั้นหนังสือไม่สำเร็จ';
      _showToast(msg);
    } catch (e) {
      _showToast(e.toString().split(':').last);
    } finally {
      _startCooldown();
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(Duration(seconds: _cooldownDuration), () {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cooldownTimer?.cancel();
  }

  _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.archive_add, color: Colors.white),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: GoogleFonts.athiti(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
