import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/web.dart';

class NovelRepository {
  static const String _baseUrl = 'https://pzfbh88v-3002.asse.devtunnels.ms/api';
  static const String _apiKey =
      'NGYyMDNlYmMtYjYyZi00OWMzLTg0NmItYThiZmI4NjhhYzUx';
  static const String _clientDomain = 'https://bookfet.com';
  late final Allsearch allsearch;
  Future<Welcome> getNovels() async {
    final url = Uri.parse('$_baseUrl/Allnovel');
    try {
      final response = await _getRequest(url);
      final decodedData = _decodeResponse(response);
      return _parseWelcome(decodedData);
    } catch (e) {
      throw Exception('Failed to load novels: $e');
    }
  }

  Future<List<Searchnovel>> searchNovels(int cateID) async {
    final url = Uri.parse('$_baseUrl/Allsearch');
    List<Searchnovel> search;
    if (novelBox.get('cateID') == cateID) {
      print('ใช้ข้อมูลเก่า');
      search = (json.decode(novelBox.get('searchData')) as List)
          .map<Searchnovel>((item) => Searchnovel.fromJson(item))
          .toList();
      return search;
    }
    try {
      final response = await _getRequest(url);
      final decodedData = _decodeResponse(response);
      Allsearch allsearch = Allsearch.fromJson(decodedData);
      search = allsearch.searchnovel
          .where((element) =>
              cateID == 0 ||
              element.cat1 == cateID.toString() ||
              element.cat2 == cateID.toString())
          .toList();
      Logger().i('searchNovels: ${search.length}');
      novelBox.put('cateID', cateID);
      novelBox.put('searchData', json.encode(search));
      return search;
    } catch (e) {
      throw Exception('Failed to search novels: $e');
    }
  }

  Future<http.Response> _getRequest(Uri url) async {
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'x-client-domain': _clientDomain,
      },
    );
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
    return json.decode(json.decode(response.body)['data']);
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
