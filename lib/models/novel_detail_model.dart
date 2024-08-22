import 'dart:convert';

Noveldetail noveldetailFromJson(String str) =>
    Noveldetail.fromJson(json.decode(str));

String noveldetailToJson(Noveldetail data) => json.encode(data.toJson());

class Noveldetail {
  final DataNovel dataNovel;
  final int addbook;
  final List<dynamic> hisRead;

  Noveldetail({
    required this.dataNovel,
    required this.addbook,
    required this.hisRead,
  });

  factory Noveldetail.fromJson(Map<String, dynamic> json) => Noveldetail(
        dataNovel: DataNovel.fromJson(json["dataNovel"]),
        addbook: json["addbook"],
        hisRead: List<dynamic>.from(json["HisRead"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "dataNovel": dataNovel.toJson(),
        "addbook": addbook,
        "HisRead": List<dynamic>.from(hisRead.map((x) => x)),
      };
}

class DataNovel {
  final Novel novel;
  final List<NovelEp> novelEp;

  DataNovel({
    required this.novel,
    required this.novelEp,
  });

  factory DataNovel.fromJson(Map<String, dynamic> json) => DataNovel(
        novel: Novel.fromJson(json["Novel"]),
        novelEp:
            List<NovelEp>.from(json["NovelEP"].map((x) => NovelEp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Novel": novel.toJson(),
        "NovelEP": List<dynamic>.from(novelEp.map((x) => x.toJson())),
      };
}

class Novel {
  final String img;
  final String bookId;
  final int btId;
  final String btTitle;
  final String btTag;
  final int btView;
  final String btBgimg;
  final int btScore;
  final String btDes;
  final int btRate;
  final String btName;

  Novel({
    required this.img,
    required this.bookId,
    required this.btId,
    required this.btTitle,
    required this.btTag,
    required this.btView,
    required this.btBgimg,
    required this.btScore,
    required this.btDes,
    required this.btRate,
    required this.btName,
  });

  factory Novel.fromJson(Map<String, dynamic> json) => Novel(
        img: json["img"],
        bookId: json["bookID"],
        btId: json["bt.id"],
        btTitle: json["bt.title"],
        btTag: json["bt.tag"],
        btView: json["bt.view"],
        btBgimg: json["bt.bgimg"],
        btScore: json["bt.score"],
        btDes: json["bt.des"],
        btRate: json["bt.rate"],
        btName: json["bt.name"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "bookID": bookId,
        "bt.id": btId,
        "bt.title": btTitle,
        "bt.tag": btTag,
        "bt.view": btView,
        "bt.bgimg": btBgimg,
        "bt.score": btScore,
        "bt.des": btDes,
        "bt.rate": btRate,
        "bt.name": btName,
      };
}

class NovelEp {
  final int id;
  final String name;
  final String bookId;
  final String epId;
  final int orderBy;
  final TypeRead typeRead;
  final DateTime publishDate;
  final String publishTime;
  final Publish publish;

  NovelEp({
    required this.id,
    required this.name,
    required this.bookId,
    required this.epId,
    required this.orderBy,
    required this.typeRead,
    required this.publishDate,
    required this.publishTime,
    required this.publish,
  });

  factory NovelEp.fromJson(Map<String, dynamic> json) => NovelEp(
        id: json["id"],
        name: json["name"],
        bookId: json["bookID"],
        epId: json["epID"],
        orderBy: json["order_by"],
        typeRead: typeReadValues.map[json["typeRead"]]!,
        publishDate: DateTime.parse(json["publishDate"]),
        publishTime: json["publishTime"],
        publish: publishValues.map[json["publish"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bookID": bookId,
        "epID": epId,
        "order_by": orderBy,
        "typeRead": typeReadValues.reverse[typeRead],
        "publishDate":
            "${publishDate.year.toString().padLeft(4, '0')}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}",
        "publishTime": publishTime,
        "publish": publishValues.reverse[publish],
      };
}

enum Publish { PRIVATE, PUBLISH }

final publishValues =
    EnumValues({"private": Publish.PRIVATE, "publish": Publish.PUBLISH});

enum TypeRead { COIN, FREE }

final typeReadValues =
    EnumValues({"coin": TypeRead.COIN, "free": TypeRead.FREE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
