import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  final List<Promote> promote;
  final List<Recomnovel> recomnovel;
  final List<Cate> cate;
  final List<HitNovel> top10;
  final List<HitNovel> hitNovel;
  final List<List<Columnnovel>> columnnovel;
  final Newnovelupdate newnovelupdate;

  Welcome({
    required this.promote,
    required this.recomnovel,
    required this.cate,
    required this.top10,
    required this.hitNovel,
    required this.columnnovel,
    required this.newnovelupdate,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        promote:
            List<Promote>.from(json["promote"].map((x) => Promote.fromJson(x))),
        recomnovel: List<Recomnovel>.from(
            json["recomnovel"].map((x) => Recomnovel.fromJson(x))),
        cate: List<Cate>.from(json["cate"].map((x) => Cate.fromJson(x))),
        top10:
            List<HitNovel>.from(json["top10"].map((x) => HitNovel.fromJson(x))),
        hitNovel: List<HitNovel>.from(
            json["hitNovel"].map((x) => HitNovel.fromJson(x))),
        columnnovel: List<List<Columnnovel>>.from(json["columnnovel"].map((x) =>
            List<Columnnovel>.from(x.map((x) => Columnnovel.fromJson(x))))),
        newnovelupdate: Newnovelupdate.fromJson(json["newnovelupdate"]),
      );

  Map<String, dynamic> toJson() => {
        "promote": List<dynamic>.from(promote.map((x) => x.toJson())),
        "recomnovel": List<dynamic>.from(recomnovel.map((x) => x.toJson())),
        "cate": List<dynamic>.from(cate.map((x) => x.toJson())),
        "top10": List<dynamic>.from(top10.map((x) => x.toJson())),
        "hitNovel": List<dynamic>.from(hitNovel.map((x) => x.toJson())),
        "columnnovel": List<dynamic>.from(columnnovel
            .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "newnovelupdate": newnovelupdate.toJson(),
      };
}

class Cate {
  final int id;
  final String name;
  final String des;
  final String img;

  Cate({
    required this.id,
    required this.name,
    required this.des,
    required this.img,
  });

  factory Cate.fromJson(Map<String, dynamic> json) => Cate(
        id: json["id"],
        name: json["name"],
        des: json["des"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "des": des,
        "img": img,
      };
}

class Columnnovel {
  final String colName;
  final int columnId;
  final List<Item> items;

  Columnnovel({
    required this.colName,
    required this.columnId,
    required this.items,
  });

  factory Columnnovel.fromJson(Map<String, dynamic> json) => Columnnovel(
        colName: json["colName"],
        columnId: json["columnID"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "colName": colName,
        "columnID": columnId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  final int id;
  final String bookId;
  final int orderBy;
  final DateTime updateAt;
  final int bclorBy;
  final int allep;
  final int colColId;
  final int colBcorBy;
  final int btcolId;
  final String btcolImg;
  final String btcolBgimg;
  final String btcolName;
  final String btcolTag;
  final int btcolView;
  final End btcolEnd;

  Item({
    required this.id,
    required this.bookId,
    required this.orderBy,
    required this.updateAt,
    required this.bclorBy,
    required this.allep,
    required this.colColId,
    required this.colBcorBy,
    required this.btcolId,
    required this.btcolImg,
    required this.btcolBgimg,
    required this.btcolName,
    required this.btcolTag,
    required this.btcolView,
    required this.btcolEnd,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        bookId: json["bookID"],
        orderBy: json["order_by"],
        updateAt: DateTime.parse(json["update_at"]),
        bclorBy: json["bclor_by"],
        allep: json["Allep"],
        colColId: json["col.colID"],
        colBcorBy: json["col.bcor_by"],
        btcolId: json["btcol.id"],
        btcolImg: json["btcol.img"],
        btcolBgimg: json["btcol.bgimg"],
        btcolName: json["btcol.name"],
        btcolTag: json["btcol.tag"],
        btcolView: json["btcol.view"],
        btcolEnd: endValues.map[json["btcol.end"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookID": bookId,
        "order_by": orderBy,
        "update_at": updateAt.toIso8601String(),
        "bclor_by": bclorBy,
        "Allep": allep,
        "col.colID": colColId,
        "col.bcor_by": colBcorBy,
        "btcol.id": btcolId,
        "btcol.img": btcolImg,
        "btcol.bgimg": btcolBgimg,
        "btcol.name": btcolName,
        "btcol.tag": btcolTag,
        "btcol.view": btcolView,
        "btcol.end": endValues.reverse[btcolEnd],
      };
}

enum End { END, NOT_END }

final endValues = EnumValues({"end": End.END, "not_end": End.NOT_END});

class HitNovel {
  final int id;
  final HitNovelType type;
  final String bookId;
  final String img;
  final String bgimg;
  final String name;
  final String title;
  final String tag;
  final String cat1;
  final String cat2;
  final int rate;
  final String des;
  final DateTime updateAt;
  final DateTime updateEp;
  final Status status;
  final int view;
  final DateTime dateAt;
  final End end;
  final String language;
  final NotiAdd setHit;
  final NotiAdd random;
  final String partnerId;
  final int rating;
  final int? setTop;
  final String copyrightName;
  final String? authorName;
  final String? transName;
  final int score;
  final NotiAdd setRecomment;
  final NotiAdd notiAdd;
  final int allep;

  HitNovel({
    required this.id,
    required this.type,
    required this.bookId,
    required this.img,
    required this.bgimg,
    required this.name,
    required this.title,
    required this.tag,
    required this.cat1,
    required this.cat2,
    required this.rate,
    required this.des,
    required this.updateAt,
    required this.updateEp,
    required this.status,
    required this.view,
    required this.dateAt,
    required this.end,
    required this.language,
    required this.setHit,
    required this.random,
    required this.partnerId,
    required this.rating,
    required this.setTop,
    required this.copyrightName,
    required this.authorName,
    required this.transName,
    required this.score,
    required this.setRecomment,
    required this.notiAdd,
    required this.allep,
  });

  factory HitNovel.fromJson(Map<String, dynamic> json) => HitNovel(
        id: json["id"],
        type: hitNovelTypeValues.map[json["type"]]!,
        bookId: json["bookID"],
        img: json["img"],
        bgimg: json["bgimg"],
        name: json["name"],
        title: json["title"],
        tag: json["tag"],
        cat1: json["cat1"],
        cat2: json["cat2"],
        rate: json["rate"],
        des: json["des"],
        updateAt: DateTime.parse(json["update_at"]),
        updateEp: DateTime.parse(json["update_ep"]),
        status: statusValues.map[json["status"]]!,
        view: json["view"],
        dateAt: DateTime.parse(json["date_at"]),
        end: endValues.map[json["end"]]!,
        language: json["language"],
        setHit: notiAddValues.map[json["set_hit"]]!,
        random: notiAddValues.map[json["random"]]!,
        partnerId: json["partnerID"],
        rating: json["rating"],
        setTop: json["set_top"],
        copyrightName: json["copyright_name"],
        authorName: json["author_name"],
        transName: json["trans_name"],
        score: json["score"],
        setRecomment: notiAddValues.map[json["set_recomment"]]!,
        notiAdd: notiAddValues.map[json["noti_add"]]!,
        allep: json["Allep"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": hitNovelTypeValues.reverse[type],
        "bookID": bookId,
        "img": img,
        "bgimg": bgimg,
        "name": name,
        "title": title,
        "tag": tag,
        "cat1": cat1,
        "cat2": cat2,
        "rate": rate,
        "des": des,
        "update_at": updateAt.toIso8601String(),
        "update_ep": updateEp.toIso8601String(),
        "status": statusValues.reverse[status],
        "view": view,
        "date_at":
            "${dateAt.year.toString().padLeft(4, '0')}-${dateAt.month.toString().padLeft(2, '0')}-${dateAt.day.toString().padLeft(2, '0')}",
        "end": endValues.reverse[end],
        "language": language,
        "set_hit": notiAddValues.reverse[setHit],
        "random": notiAddValues.reverse[random],
        "partnerID": partnerId,
        "rating": rating,
        "set_top": setTop,
        "copyright_name": copyrightName,
        "author_name": authorName,
        "trans_name": transName,
        "score": score,
        "set_recomment": notiAddValues.reverse[setRecomment],
        "noti_add": notiAddValues.reverse[notiAdd],
        "Allep": allep,
      };
}

enum NotiAdd { NO, YES }

final notiAddValues = EnumValues({"no": NotiAdd.NO, "yes": NotiAdd.YES});

enum Status { PUBLISH }

final statusValues = EnumValues({"publish": Status.PUBLISH});

enum HitNovelType { MAIN }

final hitNovelTypeValues = EnumValues({"main": HitNovelType.MAIN});

class Newnovelupdate {
  final List<HitNovel> upnovel;

  Newnovelupdate({
    required this.upnovel,
  });

  factory Newnovelupdate.fromJson(Map<String, dynamic> json) => Newnovelupdate(
        upnovel: List<HitNovel>.from(
            json["Upnovel"].map((x) => HitNovel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Upnovel": List<dynamic>.from(upnovel.map((x) => x.toJson())),
      };
}

class Promote {
  final int id;
  final String img;
  final PromoteType type;
  final String dataVal;
  final DateTime updateAt;
  final String? imgApp;
  final int allep;

  Promote({
    required this.id,
    required this.img,
    required this.type,
    required this.dataVal,
    required this.updateAt,
    required this.imgApp,
    required this.allep,
  });

  factory Promote.fromJson(Map<String, dynamic> json) => Promote(
        id: json["id"],
        img: json["img"],
        type: promoteTypeValues.map[json["type"]]!,
        dataVal: json["data_val"],
        updateAt: DateTime.parse(json["update_at"]),
        imgApp: json["img_app"],
        allep: json["Allep"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
        "type": promoteTypeValues.reverse[type],
        "data_val": dataVal,
        "update_at": updateAt.toIso8601String(),
        "img_app": imgApp,
        "Allep": allep,
      };
}

enum PromoteType { BOOK, LINK, NONE }

final promoteTypeValues = EnumValues({
  "book": PromoteType.BOOK,
  "link": PromoteType.LINK,
  "none": PromoteType.NONE
});

class Recomnovel {
  final int id;
  final String bookId;
  final HitNovelType type;
  final String img;
  final String name;
  final String title;
  final String tag;
  final int view;
  final int score;
  final End end;
  final DateTime updateAt;
  final int allep;

  Recomnovel({
    required this.id,
    required this.bookId,
    required this.type,
    required this.img,
    required this.name,
    required this.title,
    required this.tag,
    required this.view,
    required this.score,
    required this.end,
    required this.updateAt,
    required this.allep,
  });

  factory Recomnovel.fromJson(Map<String, dynamic> json) => Recomnovel(
        id: json["id"],
        bookId: json["bookID"],
        type: hitNovelTypeValues.map[json["type"]]!,
        img: json["img"],
        name: json["name"],
        title: json["title"],
        tag: json["tag"],
        view: json["view"],
        score: json["score"],
        end: endValues.map[json["end"]]!,
        updateAt: DateTime.parse(json["update_at"]),
        allep: json["Allep"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookID": bookId,
        "type": hitNovelTypeValues.reverse[type],
        "img": img,
        "name": name,
        "title": title,
        "tag": tag,
        "view": view,
        "score": score,
        "end": endValues.reverse[end],
        "update_at": updateAt.toIso8601String(),
        "Allep": allep,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
