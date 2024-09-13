import 'dart:convert';

BookfetNovelRead bookfetNovelReadFromJson(String str) =>
    BookfetNovelRead.fromJson(json.decode(str));

String bookfetNovelReadToJson(BookfetNovelRead data) =>
    json.encode(data.toJson());

class BookfetNovelRead {
  final BookfetReadnovel readnovel;

  BookfetNovelRead({
    required this.readnovel,
  });

  factory BookfetNovelRead.fromJson(Map<String, dynamic> json) =>
      BookfetNovelRead(
        readnovel: BookfetReadnovel.fromJson(json["Readnovel"]),
      );

  Map<String, dynamic> toJson() => {
        "Readnovel": readnovel.toJson(),
      };
}

class BookfetReadnovel {
  final BookfetNovelBook novelBook;
  final BookfetNovelEp novelEp;
  final List<BookfetAllep> allep;
  final BookfetPreviousOrNext previousOrNext;

  BookfetReadnovel({
    required this.novelBook,
    required this.novelEp,
    required this.allep,
    required this.previousOrNext,
  });

  factory BookfetReadnovel.fromJson(Map<String, dynamic> json) =>
      BookfetReadnovel(
        novelBook: BookfetNovelBook.fromJson(json["NovelBook"]),
        novelEp: BookfetNovelEp.fromJson(json["NovelEP"]),
        allep: List<BookfetAllep>.from(
            json["Allep"].map((x) => BookfetAllep.fromJson(x))),
        previousOrNext: BookfetPreviousOrNext.fromJson(json["PreviousOrNext"]),
      );

  Map<String, dynamic> toJson() => {
        "NovelBook": novelBook.toJson(),
        "NovelEP": novelEp.toJson(),
        "Allep": List<dynamic>.from(allep.map((x) => x.toJson())),
        "PreviousOrNext": previousOrNext.toJson(),
      };
}

class BookfetAllep {
  final int id;
  final String name;
  final String epId;
  final int orderBy;
  final BookfetTypeRead typeRead;
  final String bookId;
  final DateTime publishDate;
  final String publishTime;
  final BookfetPublish publish;

  BookfetAllep({
    required this.id,
    required this.name,
    required this.epId,
    required this.orderBy,
    required this.typeRead,
    required this.bookId,
    required this.publishDate,
    required this.publishTime,
    required this.publish,
  });

  factory BookfetAllep.fromJson(Map<String, dynamic> json) => BookfetAllep(
        id: json["id"],
        name: json["name"],
        epId: json["epID"],
        orderBy: json["order_by"],
        typeRead: bookfetTypeReadValues.map[json["typeRead"]]!,
        bookId: json["bookID"],
        publishDate: DateTime.parse(json["publishDate"]),
        publishTime: json["publishTime"],
        publish: bookfetPublishValues.map[json["publish"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "epID": epId,
        "order_by": orderBy,
        "typeRead": bookfetTypeReadValues.reverse[typeRead],
        "bookID": bookId,
        "publishDate":
            "${publishDate.year.toString().padLeft(4, '0')}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}",
        "publishTime": publishTime,
        "publish": bookfetPublishValues.reverse[publish],
      };
}

enum BookfetPublish { PUBLISH }

final bookfetPublishValues =
    BookfetEnumValues({"publish": BookfetPublish.PUBLISH});

enum BookfetTypeRead { COIN, FREE }

final bookfetTypeReadValues = BookfetEnumValues(
    {"coin": BookfetTypeRead.COIN, "free": BookfetTypeRead.FREE});

class BookfetNovelBook {
  final String type;
  final String bookId;
  final String img;
  final String name;
  final String title;
  final String tag;
  final int view;
  final int score;
  final int rate;
  final int id;
  final String pnPartner;
  final int count;

  BookfetNovelBook({
    required this.type,
    required this.bookId,
    required this.img,
    required this.name,
    required this.title,
    required this.tag,
    required this.view,
    required this.score,
    required this.rate,
    required this.id,
    required this.pnPartner,
    required this.count,
  });

  factory BookfetNovelBook.fromJson(Map<String, dynamic> json) =>
      BookfetNovelBook(
        type: json["type"],
        bookId: json["bookID"],
        img: json["img"],
        name: json["name"],
        title: json["title"],
        tag: json["tag"],
        view: json["view"],
        score: json["score"],
        rate: json["rate"],
        id: json["id"],
        pnPartner: json["pn.partner"],
        count: json["Count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "bookID": bookId,
        "img": img,
        "name": name,
        "title": title,
        "tag": tag,
        "view": view,
        "score": score,
        "rate": rate,
        "id": id,
        "pn.partner": pnPartner,
        "Count": count,
      };
}

class BookfetNovelEp {
  // final String epId;
  // final String bookId;
  // final String? detail;
  // final String name;
  // final int? ep;
  // final DateTime publishDate;
  // final String publishTime;
  // final BookfetPublish publish;

  final int? id;
  final String name;
  final String epId;
  final int? orderBy;
  final BookfetTypeRead typeRead;
  final String bookId;
  final DateTime publishDate;
  final String publishTime;
  final BookfetPublish publish;
  final String? detail;
  final int? ep;

  BookfetNovelEp({
    this.id,
    required this.name,
    required this.epId,
    this.orderBy,
    required this.typeRead,
    required this.bookId,
    required this.publishDate,
    required this.publishTime,
    required this.publish,
    this.detail,
    this.ep,
  });

  factory BookfetNovelEp.fromJson(Map<String, dynamic> json) => BookfetNovelEp(
        id: json["id"],
        epId: json["epID"],
        orderBy: json["order_by"],
        typeRead: bookfetTypeReadValues.map[json["typeRead"]]!,
        bookId: json["bookID"],
        detail: json["detail"],
        name: json["name"],
        ep: json["ep"],
        publishDate: DateTime.parse(json["publishDate"]),
        publishTime: json["publishTime"],
        publish: bookfetPublishValues.map[json["publish"]]!,
      );

  Map<String, dynamic> toJson() => {
        "epID": epId,
        "bookID": bookId,
        "detail": detail,
        "name": name,
        "ep": ep,
        "publishDate":
            "${publishDate.year.toString().padLeft(4, '0')}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}",
        "publishTime": publishTime,
        "publish": bookfetPublishValues.reverse[publish],
      };
}

class BookfetPreviousOrNext {
  final BookfetNovelEp? previous; // Change to nullable
  final BookfetNovelEp? next; // Change to nullable

  BookfetPreviousOrNext({
    required this.previous,
    required this.next,
  });

  factory BookfetPreviousOrNext.fromJson(Map<String, dynamic> json) =>
      BookfetPreviousOrNext(
        previous: json["Previous"] == null
            ? null
            : BookfetNovelEp.fromJson(json["Previous"]),
        next:
            json["Next"] == null ? null : BookfetNovelEp.fromJson(json["Next"]),
      );

  Map<String, dynamic> toJson() => {
        "Previous": previous?.toJson(),
        "Next": next?.toJson(),
      };
}

// enum TypeRead { COIN, FREE }

// final typeReadValues =
//     BookfetEnumValues({"coin": TypeRead.COIN, "free": TypeRead.FREE});

class BookfetEnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  BookfetEnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
