import 'dart:convert';

List<Bookmark> bookmarkFromJson(String str) =>
    List<Bookmark>.from(json.decode(str).map((x) => Bookmark.fromJson(x)));

String bookmarkToJson(List<Bookmark> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookmark {
  final String bookId;
  final String userId;
  final DateTime updateAt;
  final String sbtImg;
  final int sbtId;
  final String sbtName;
  final String sbtTag;
  final String sbtEnd;
  final int sbtAllep;
  final String sbtCate1;
  final String sbtCate2;

  Bookmark({
    required this.bookId,
    required this.userId,
    required this.updateAt,
    required this.sbtImg,
    required this.sbtId,
    required this.sbtName,
    required this.sbtTag,
    required this.sbtEnd,
    required this.sbtAllep,
    required this.sbtCate1,
    required this.sbtCate2,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        bookId: json["bookID"],
        userId: json["userID"],
        updateAt: DateTime.parse(json["update_at"]),
        sbtImg: json["sbt.img"],
        sbtId: json["sbt.id"],
        sbtName: json["sbt.name"],
        sbtTag: json["sbt.tag"],
        sbtEnd: json["sbt.end"],
        sbtAllep: json["sbt.Allep"],
        sbtCate1: json["sbt.cat1"],
        sbtCate2: json["sbt.cat2"],
      );

  Map<String, dynamic> toJson() => {
        "bookID": bookId,
        "userID": userId,
        "update_at": updateAt.toIso8601String(),
        "sbt.img": sbtImg,
        "sbt.id": sbtId,
        "sbt.name": sbtName,
        "sbt.tag": sbtTag,
        "sbt.end": sbtEnd,
        "sbt.Allep": sbtAllep,
        "sbt.cat1": sbtCate1,
        "sbt.cat2": sbtCate2,
      };
}
