// To parse this JSON data, do
//
//     final allcoment = allcomentFromJson(jsonString);

import 'dart:convert';

Allcoment allcomentFromJson(String str) => Allcoment.fromJson(json.decode(str));

String allcomentToJson(Allcoment data) => json.encode(data.toJson());

class Allcoment {
  final NovelData? novelData;
  final List<Comment>? comment;

  Allcoment({
    this.novelData,
    this.comment,
  });

  factory Allcoment.fromJson(Map<String, dynamic> json) => Allcoment(
        novelData: json["novelData"] == null
            ? null
            : NovelData.fromJson(json["novelData"]),
        comment: json["comment"] == null
            ? []
            : List<Comment>.from(
                json["comment"]!.map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "novelData": novelData?.toJson(),
        "comment": comment == null
            ? []
            : List<dynamic>.from(comment!.map((x) => x.toJson())),
      };
}

class Comment {
  final int? cmId;
  final String? bookId;
  final String? epId;
  final String? userId;
  final String? userName;
  final String? comment;
  final DateTime? dateAt;
  final int? likes;
  final dynamic userIdLikes;
  final int? countRead;
  final String? type;
  final String? btepName;
  final dynamic btcsCm;
  final dynamic btcsUserId;
  final dynamic btcsUserName;
  final dynamic btcsComment;
  final dynamic btcsDateAt;
  final dynamic btcsLikes;
  final dynamic btcsUserIdLikes;
  final dynamic btcsCountRead;
  final dynamic btcsUsscmUserId;
  final dynamic btcsUsscmImgProfile;
  final String? uscmImgProfile;
  final List<dynamic>? subcomment;

  Comment({
    this.cmId,
    this.bookId,
    this.epId,
    this.userId,
    this.userName,
    this.comment,
    this.dateAt,
    this.likes,
    this.userIdLikes,
    this.countRead,
    this.type,
    this.btepName,
    this.btcsCm,
    this.btcsUserId,
    this.btcsUserName,
    this.btcsComment,
    this.btcsDateAt,
    this.btcsLikes,
    this.btcsUserIdLikes,
    this.btcsCountRead,
    this.btcsUsscmUserId,
    this.btcsUsscmImgProfile,
    this.uscmImgProfile,
    this.subcomment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        cmId: json["cm_id"],
        bookId: json["bookID"],
        epId: json["epID"],
        userId: json["userID"],
        userName: json["userName"],
        comment: json["comment"],
        dateAt:
            json["date_at"] == null ? null : DateTime.parse(json["date_at"]),
        likes: json["likes"],
        userIdLikes: json["userID_likes"],
        countRead: json["countRead"],
        type: json["type"],
        btepName: json["btep.name"],
        btcsCm: json["btcs.cm"],
        btcsUserId: json["btcs.userID"],
        btcsUserName: json["btcs.userName"],
        btcsComment: json["btcs.comment"],
        btcsDateAt: json["btcs.date_at"],
        btcsLikes: json["btcs.likes"],
        btcsUserIdLikes: json["btcs.userID_likes"],
        btcsCountRead: json["btcs.countRead"],
        btcsUsscmUserId: json["btcs.usscm.userID"],
        btcsUsscmImgProfile: json["btcs.usscm.img_profile"],
        uscmImgProfile: json["uscm.img_profile"],
        subcomment: json["Subcomment"] == null
            ? []
            : List<dynamic>.from(json["Subcomment"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cm_id": cmId,
        "bookID": bookId,
        "epID": epId,
        "userID": userId,
        "userName": userName,
        "comment": comment,
        "date_at": dateAt?.toIso8601String(),
        "likes": likes,
        "userID_likes": userIdLikes,
        "countRead": countRead,
        "type": type,
        "btep.name": btepName,
        "btcs.cm": btcsCm,
        "btcs.userID": btcsUserId,
        "btcs.userName": btcsUserName,
        "btcs.comment": btcsComment,
        "btcs.date_at": btcsDateAt,
        "btcs.likes": btcsLikes,
        "btcs.userID_likes": btcsUserIdLikes,
        "btcs.countRead": btcsCountRead,
        "btcs.usscm.userID": btcsUsscmUserId,
        "btcs.usscm.img_profile": btcsUsscmImgProfile,
        "uscm.img_profile": uscmImgProfile,
        "Subcomment": subcomment == null
            ? []
            : List<dynamic>.from(subcomment!.map((x) => x)),
      };
}

class NovelData {
  final String? img;
  final String? bookId;
  final int? btId;
  final String? btTitle;
  final String? btTag;
  final int? btView;
  final String? btBgimg;
  final int? btScore;
  final String? btDes;
  final int? btRate;
  final String? btName;

  NovelData({
    this.img,
    this.bookId,
    this.btId,
    this.btTitle,
    this.btTag,
    this.btView,
    this.btBgimg,
    this.btScore,
    this.btDes,
    this.btRate,
    this.btName,
  });

  factory NovelData.fromJson(Map<String, dynamic> json) => NovelData(
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
