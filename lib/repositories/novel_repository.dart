import 'package:aescryptojs/aescryptojs.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
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
      // Logger().i('cateList: $cateList');
      List<Cate> catex = _parseList<Cate>(cateList, Cate.fromJson);
      List<int> cateID =
          catex.where((e) => e.name.contains(query)).map((e) => e.id).toList();

      search = allsearch.searchnovel
          .where((e) =>
              e.name.contains(query) ||
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
    // print('getnovelById: $novelId');
    // Logger().i('getnovelById: $token');
    try {
      final response = await _getRequest(url, token: token);
      final decodedData = _decodeResponse(response);
      // Logger().i('getnovelById: $decodedData');
      Noveldetail noveldetail = Noveldetail.fromJson(decodedData);
      // Logger().i('getnovelById: ${noveldetail.toJson()}');
      return noveldetail.dataNovel;
    } catch (e) {
      Logger().e('Failed to load novel by id: $e');
      throw Exception('Failed to load novel by id: $e');
    }
  }

  // Future<void> getnovelByIdtest(int novelId) async {
  //   final url = Uri.parse('$_baseUrl/novel/$novelId');
  //   String token = novelBox.get('usertoken');
  //   print('getnovelById: $novelId');
  //   // Logger().i('getnovelById: $token');
  //   try {
  //     final response = await _getRequest(url, token: token);
  //     final decodedData = _decodeResponse(response);
  //     Noveldetail noveldetail = Noveldetail.fromJson(decodedData);
  //     Logger().i('dataNovel: ${noveldetail.dataNovel.toJson()}');
  //     // Logger().i('getnovelById: ${decodedData}');
  //   } catch (e) {
  //     Logger().e('Failed to load novel by id: $e');
  //     throw Exception('Failed to load novel by id: $e');
  //   }
  // }

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
    // Logger().i('response.body: ${response.body}');
    final des = decryptAESCryptoJS(json.decode(response.body)['data'], pass);
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