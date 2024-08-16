import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String userid;
  final String username;
  final String img;
  final Detail detail;
  final String ag;
  final int iat;
  final int exp;

  User({
    required this.userid,
    required this.username,
    required this.img,
    required this.detail,
    required this.ag,
    required this.iat,
    required this.exp,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userid: json["userid"],
        username: json["username"],
        img: json["img"],
        detail: Detail.fromJson(json["detail"]),
        ag: json["ag"],
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "username": username,
        "img": img,
        "detail": detail.toJson(),
        "ag": ag,
        "iat": iat,
        "exp": exp,
      };
}

class Detail {
  final String email;
  final DateTime dateRegis;
  final String status;
  final dynamic packId;
  final DateTime birthdayDate;
  final dynamic des;
  final String gender;
  final dynamic address;
  final dynamic fbLink;
  final dynamic twitterLink;
  final int wheel;
  final int score;
  final dynamic sharedId;
  final List<String?> roles;
  final dynamic dateout;

  Detail({
    required this.email,
    required this.dateRegis,
    required this.status,
    required this.packId,
    required this.birthdayDate,
    required this.des,
    required this.gender,
    required this.address,
    required this.fbLink,
    required this.twitterLink,
    required this.wheel,
    required this.score,
    required this.sharedId,
    required this.roles,
    required this.dateout,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        email: json["email"],
        dateRegis: DateTime.parse(json["date_regis"]),
        status: json["status"],
        packId: json["packID"],
        birthdayDate: DateTime.parse(json["birthday_date"]),
        des: json["des"],
        gender: json["gender"],
        address: json["address"],
        fbLink: json["fb_link"],
        twitterLink: json["twitter_link"],
        wheel: json["wheel"],
        score: json["score"],
        sharedId: json["sharedID"],
        roles: List<String?>.from(json["roles"].map((x) => x)),
        dateout: json["dateout"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "date_regis": dateRegis.toIso8601String(),
        "status": status,
        "packID": packId,
        "birthday_date":
            "${birthdayDate.year.toString().padLeft(4, '0')}-${birthdayDate.month.toString().padLeft(2, '0')}-${birthdayDate.day.toString().padLeft(2, '0')}",
        "des": des,
        "gender": gender,
        "address": address,
        "fb_link": fbLink,
        "twitter_link": twitterLink,
        "wheel": wheel,
        "score": score,
        "sharedID": sharedId,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "dateout": dateout,
      };
}
