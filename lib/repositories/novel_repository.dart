import 'package:aescryptojs/aescryptojs.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';

class NovelRepository {
  static const String _baseUrl = 'https://pzfbh88v-3002.asse.devtunnels.ms/api';
  static const String _apiKey =
      'NGYyMDNlYmMtYjYyZi00OWMzLTg0NmItYThiZmI4NjhhYzUx';
  static const String _clientDomain = 'https://bookfet.com';
  late final Allsearch allsearch;
  final pass =
      'e28a5df015869f8f673ce00d6c4953fce3a05ba8d1c192a3c3e4744fe2d9bf5d';

  Future<Welcome> getNovels() async {
    final url = Uri.parse('$_baseUrl/Allnovel');
    try {
      final response = await _getRequest(url);
      // print('response: ${response.body}');

      final decodedData = _decodeResponse(response);
      return _parseWelcome(decodedData);
    } catch (e) {
      throw Exception('Failed to load novels: $e');
    }
  }

  Future<List<Searchnovel>> searchNovels(int cateID) async {
    final url = Uri.parse('$_baseUrl/Allsearch');
    List<Searchnovel> search;
    try {
      final response = await _getRequest(url);
      final decodedData = _decodeResponse(response);
      Allsearch allsearch = Allsearch.fromJson(decodedData);
      search = allsearch.searchnovel;
      // Logger().i('searchNovels: ${search.length}');
      // Logger().i('cateID: $cateID');
      novelBox.put('cateID', cateID);
      novelBox.put('searchData', json.encode(search));
      return search;
    } catch (e) {
      throw Exception('Failed to search novels: $e');
    }
  }

  Future<List<Searchnovel>> filterNovelByGenre(String category,
      {String? query}) async {
    if (novelBox.get('searchDatabyName') == null) {
      return await searchNovelByName(query!);
    }
    if (category == '0') {
      if (query == null) {
        throw ArgumentError('Query must not be null when category is "0"');
      }
      return await searchNovelByName(query);
    }

    try {
      print('categoryxxx: $category');
      List<Searchnovel> search = _parseList<Searchnovel>(
          json.decode(await novelBox.get('searchDatabyName')),
          Searchnovel.fromJson);
      return search
          .where((e) => e.cat1 == category || e.cat2 == category)
          .toList();
    } catch (e) {
      throw Exception('Failed to filter novels: $e');
    }
  }

  Future<List<Searchnovel>> searchNovelByName(String query) async {
    final url = Uri.parse('$_baseUrl/Allsearch');
    List<Searchnovel> search;
    try {
      final response = await _getRequest(url);
      final decodedData = _decodeResponse(response);
      Allsearch allsearch = Allsearch.fromJson(decodedData);
      List<dynamic> cateList = json.decode(await novelBox.get('categoryData'));
      List<Cate> catex = _parseList<Cate>(cateList, Cate.fromJson);
      List<int> cateID =
          catex.where((e) => e.name.contains(query)).map((e) => e.id).toList();

      search = allsearch.searchnovel
          .where((e) =>
              e.name.contains(query) ||
              e.tag.contains(query) ||
              cateID.contains(e.cat1 != '' ? int.parse(e.cat1) : 0) ||
              cateID.contains(e.cat2 != '' ? int.parse(e.cat2) : 0))
          .toList();
      novelBox.put('searchDatabyName', json.encode(search));
      return search;
    } catch (e) {
      throw Exception('Failed to search novels: $e');
    }
  }

  Future<DataNovel> getnovelById(int novelId) async {
    final url = Uri.parse('$_baseUrl/novel/$novelId');
    String token = novelBox.get('usertoken');
    try {
      final response = await _getRequest(url, token: token);
      final decodedData = _decodeResponse(response);
      Noveldetail noveldetail = Noveldetail.fromJson(decodedData);
      return noveldetail.dataNovel;
    } catch (e) {
      Logger().e('Failed to load novel by id: $e');
      throw Exception('Failed to load novel by id: $e');
    }
  }

  Future<bool> addBookmark(String bookId) async {
    final url = Uri.parse('$_baseUrl/addbook');
    String token = novelBox.get('usertoken');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'x-client-domain': _clientDomain,
          'Authorization': token,
        },
        body: json.encode({'BookID': bookId}),
      );

      Logger().i('addBookmark: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('เกิดข้อผิดพลาดในการเพิ่ม Bookmark');
      }

      var message = json.decode(response.body)['message'];
      Logger().i('message: $message');

      if (message == 'อยู่ในชั้นหนังสือแล้ว') {
        throw Exception(message);
      }

      await novelBox.delete('bookmarkData');
      await getBookmark();
      return true;
    } catch (e) {
      Logger().e('Failed to add bookmark: $e');
      rethrow;
    }
  }

  Future<List<Bookmark>> getBookmark() async {
    if (novelBox.get('bookmarkData') != null) {
      return _parseList<Bookmark>(
          json.decode(novelBox.get('bookmarkData')), Bookmark.fromJson);
    }

    try {
      final response = await _getRequest(
          Uri.parse('$_baseUrl/cheackbook/member'),
          token: novelBox.get('usertoken'));

      if (response.statusCode == 200) {
        final des =
            decryptAESCryptoJS(json.decode(response.body)['data'], pass);
        final bookmark =
            _parseList<Bookmark>(json.decode(des), Bookmark.fromJson);
        novelBox.put('bookmarkData', json.encode(bookmark));
        return bookmark;
      } else {
        throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูล Bookmark');
      }
    } catch (e) {
      throw Exception('Failed to get bookmark: $e');
    }
  }

  Future<bool> removeBookmark(String bookId) async {
    final url = Uri.parse('$_baseUrl/delebook');
    String token = novelBox.get('usertoken');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'x-client-domain': _clientDomain,
          'Authorization': token,
        },
        body: json.encode({'BookID': bookId}),
      );

      Logger().i('removeBookmark: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('เกิดข้อผิดพลาดในการลบ Bookmark');
      }

      await novelBox.delete('bookmarkData');
      await getBookmark();
      return true;
    } catch (e) {
      Logger().e('Failed to remove bookmark: $e');
      rethrow;
    }
  }

  Future<List<Bookmark>> searchBookmark(String? cateID, String? query) async {
    try {
      final bookmarkData = novelBox.get('bookmarkData');
      final List<Bookmark> bookmarks = bookmarkData != null
          ? _parseList<Bookmark>(json.decode(bookmarkData), Bookmark.fromJson)
          : await getBookmark();
      final List<Bookmark> result;
      if (query != null && cateID == '0') {
        result = bookmarks.where((e) => e.sbtName.contains(query)).toList();
      } else if (query != null && cateID != '0') {
        result = bookmarks
            .where((e) =>
                e.sbtName.contains(query) &&
                (e.sbtCate1 == cateID || e.sbtCate2 == cateID))
            .toList();
      } else if (query == null && cateID != '0') {
        result = bookmarks
            .where((e) => e.sbtCate1 == cateID || e.sbtCate2 == cateID)
            .toList();
      } else {
        result = bookmarks;
      }
      return result;
    } catch (e) {
      throw Exception('Failed to get bookmark by cate: $e');
    }
  }

  Future<http.Response> _getRequest(Uri url, {String? token}) async {
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'x-client-domain': _clientDomain,
        'Authorization': token ?? '',
      },
    );
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
    // Logger().i('response.body: ${json.decode(response.body)}');
    final des = decryptAESCryptoJS(json.decode(response.body)['data'], pass);
    // Logger().i('des: $des');
    return json.decode(des);
  }

  Welcome _parseWelcome(Map<String, dynamic> data) {
    return Welcome(
      promote: _parseList<Promote>(data['promote'], Promote.fromJson),
      recomnovel:
          _parseList<Recomnovel>(data['recomnovel'], Recomnovel.fromJson),
      cate: _parseCateList(data['cate']),
      top10: _parseList<HitNovel>(data['top10'], HitNovel.fromJson),
      hitNovel: _parseList<HitNovel>(data['hitNovel'], HitNovel.fromJson),
      columnnovel: _parseColumnnovel(data['columnnovel']),
      newnovelupdate: Newnovelupdate.fromJson(data['newnovelupdate']),
    );
  }

  List<T> _parseList<T>(
      List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
    return list.map<T>((item) => fromJson(item)).toList();
  }

  List<Cate> _parseCateList(List<dynamic> cateList) {
    List<Cate> cate = [Cate(id: 0, name: 'ทั้งหมด', img: 'img', des: '')];
    cate.addAll(_parseList<Cate>(cateList, Cate.fromJson));
    novelBox.put('categoryData', json.encode(cate));
    return cate;
  }

  List<List<Columnnovel>> _parseColumnnovel(List<dynamic> columnnovelList) {
    return columnnovelList
        .map<List<Columnnovel>>((outerItem) => (outerItem as List)
            .map<Columnnovel>((innerItem) =>
                Columnnovel.fromJson(innerItem as Map<String, dynamic>))
            .toList())
        .toList();
  }
}
