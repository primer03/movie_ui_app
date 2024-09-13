// To parse this JSON data, do
//
//     final allsearch = allsearchFromJson(jsonString);

import 'dart:convert';

Allsearch allsearchFromJson(String str) => Allsearch.fromJson(json.decode(str));

String allsearchToJson(Allsearch data) => json.encode(data.toJson());

class Allsearch {
  final List<Searchnovel> searchnovel;
  final List<Searchcartoon> searchcartoon;

  Allsearch({
    required this.searchnovel,
    required this.searchcartoon,
  });

  factory Allsearch.fromJson(Map<String, dynamic> json) => Allsearch(
        searchnovel: List<Searchnovel>.from(
            json["searchnovel"].map((x) => Searchnovel.fromJson(x))),
        searchcartoon: List<Searchcartoon>.from(
            json["searchcartoon"].map((x) => Searchcartoon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "searchnovel": List<dynamic>.from(searchnovel.map((x) => x.toJson())),
        "searchcartoon":
            List<dynamic>.from(searchcartoon.map((x) => x.toJson())),
      };
}

class Searchcartoon {
  final int id;
  final String cartoonId;
  final String type;
  final String typeCartoon;
  final String img;
  final String banner;
  final String mainCharacter;
  final String name;
  final String title;
  final String tag;
  final int view;
  final End end;
  final String des;
  final String catId;
  final int allep;

  Searchcartoon({
    required this.id,
    required this.cartoonId,
    required this.type,
    required this.typeCartoon,
    required this.img,
    required this.banner,
    required this.mainCharacter,
    required this.name,
    required this.title,
    required this.tag,
    required this.view,
    required this.end,
    required this.des,
    required this.catId,
    required this.allep,
  });

  factory Searchcartoon.fromJson(Map<String, dynamic> json) => Searchcartoon(
        id: json["id"],
        cartoonId: json["cartoonID"],
        type: json["type"],
        typeCartoon: json["type_cartoon"],
        img: json["img"],
        banner: json["banner"],
        mainCharacter: json["main_character"],
        name: json["name"],
        title: json["title"],
        tag: json["tag"],
        view: json["view"],
        end: endValues.map[json["end"]]!,
        des: json["des"],
        catId: json["catID"],
        allep: json["Allep"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cartoonID": cartoonId,
        "type": type,
        "type_cartoon": typeCartoon,
        "img": img,
        "banner": banner,
        "main_character": mainCharacter,
        "name": name,
        "title": title,
        "tag": tag,
        "view": view,
        "end": endValues.reverse[end],
        "des": des,
        "catID": catId,
        "Allep": allep,
      };
}

enum End { END, NOT_END }

final endValues = EnumValues({"end": End.END, "not_end": End.NOT_END});

class Searchnovel {
  final int id;
  final String bookId;
  final Type type;
  final String img;
  final String name;
  final String title;
  final String tag;
  final int view;
  final int score;
  final String copyrightName;
  final String authorName;
  final String transName;
  final End end;
  final String des;
  final String cat1;
  final String cat2;
  final DateTime updateEp;
  final int allep;

  Searchnovel({
    required this.id,
    required this.bookId,
    required this.type,
    required this.img,
    required this.name,
    required this.title,
    required this.tag,
    required this.view,
    required this.score,
    required this.copyrightName,
    required this.authorName,
    required this.transName,
    required this.end,
    required this.des,
    required this.cat1,
    required this.cat2,
    required this.updateEp,
    required this.allep,
  });

  factory Searchnovel.fromJson(Map<String, dynamic> json) => Searchnovel(
        id: json["id"],
        bookId: json["bookID"],
        type: typeValues.map[json["type"]]!,
        img: json["img"],
        name: json["name"],
        title: json["title"],
        tag: json["tag"],
        view: json["view"],
        score: json["score"],
        copyrightName: json["copyright_name"],
        authorName: json["author_name"],
        transName: json["trans_name"],
        end: endValues.map[json["end"]]!,
        des: json["des"],
        cat1: json["cat1"],
        cat2: json["cat2"],
        updateEp: DateTime.parse(json["update_ep"]),
        allep: json["Allep"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookID": bookId,
        "type": typeValues.reverse[type],
        "img": img,
        "name": name,
        "title": title,
        "tag": tag,
        "view": view,
        "score": score,
        "copyright_name": copyrightName,
        "author_name": authorName,
        "trans_name": transName,
        "end": endValues.reverse[end],
        "des": des,
        "cat1": cat1,
        "cat2": cat2,
        "update_ep": updateEp.toIso8601String(),
        "Allep": allep,
      };

  // Override == and hashCode for content comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Searchnovel && other.id == id && other.bookId == bookId;
  }

  @override
  int get hashCode => id.hashCode ^ bookId.hashCode;
}

enum Type { MAIN }

final typeValues = EnumValues({"main": Type.MAIN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
