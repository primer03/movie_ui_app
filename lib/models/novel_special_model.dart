// To parse this JSON data, do
import 'dart:convert';

SpecialPage specialPageFromJson(String str) =>
    SpecialPage.fromJson(json.decode(str));

String specialPageToJson(SpecialPage data) => json.encode(data.toJson());

class SpecialPage {
  final List<SpecialBanner>? specialBanner;
  final List<SpecialCharacter>? specialCharacter;

  SpecialPage({
    this.specialBanner,
    this.specialCharacter,
  });

  factory SpecialPage.fromJson(Map<String, dynamic> json) => SpecialPage(
        specialBanner: json["Special_banner"] == null
            ? []
            : List<SpecialBanner>.from(
                json["Special_banner"]!.map((x) => SpecialBanner.fromJson(x))),
        specialCharacter: json["Special_character"] == null
            ? []
            : List<SpecialCharacter>.from(json["Special_character"]!
                .map((x) => SpecialCharacter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Special_banner": specialBanner == null
            ? []
            : List<dynamic>.from(specialBanner!.map((x) => x.toJson())),
        "Special_character": specialCharacter == null
            ? []
            : List<dynamic>.from(specialCharacter!.map((x) => x.toJson())),
      };
}

class SpecialBanner {
  final int? id;
  final String? name;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final String? type;
  final String? mainId;
  final String? fontImg;
  final String? bgImg;
  final String? character1;
  final String? character2;
  final String? character3;
  final String? banner;
  final String? video;
  final String? videoApp;
  final String? footerImg;
  final DateTime? updateAt;
  final int? view;
  final Sb? sb;

  SpecialBanner({
    this.id,
    this.name,
    this.dateStart,
    this.dateEnd,
    this.type,
    this.mainId,
    this.fontImg,
    this.bgImg,
    this.character1,
    this.character2,
    this.character3,
    this.banner,
    this.video,
    this.videoApp,
    this.footerImg,
    this.updateAt,
    this.view,
    this.sb,
  });

  factory SpecialBanner.fromJson(Map<String, dynamic> json) => SpecialBanner(
        id: json["id"],
        name: json["name"],
        dateStart: json["date_start"] == null
            ? null
            : DateTime.parse(json["date_start"]),
        dateEnd:
            json["date_end"] == null ? null : DateTime.parse(json["date_end"]),
        type: json["type"],
        mainId: json["mainID"],
        fontImg: json["font_img"],
        bgImg: json["bg_img"],
        character1: json["character1"],
        character2: json["character2"],
        character3: json["character3"],
        banner: json["banner"],
        video: json["video"],
        videoApp: json["video_app"],
        footerImg: json["footer_img"],
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        view: json["view"],
        sb: json["sb"] == null ? null : Sb.fromJson(json["sb"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_start":
            "${dateStart!.year.toString().padLeft(4, '0')}-${dateStart!.month.toString().padLeft(2, '0')}-${dateStart!.day.toString().padLeft(2, '0')}",
        "date_end":
            "${dateEnd!.year.toString().padLeft(4, '0')}-${dateEnd!.month.toString().padLeft(2, '0')}-${dateEnd!.day.toString().padLeft(2, '0')}",
        "type": type,
        "mainID": mainId,
        "font_img": fontImg,
        "bg_img": bgImg,
        "character1": character1,
        "character2": character2,
        "character3": character3,
        "banner": banner,
        "video": video,
        "video_app": videoApp,
        "footer_img": footerImg,
        "update_at": updateAt?.toIso8601String(),
        "view": view,
        "sb": sb?.toJson(),
      };
}

class Sb {
  final int? view;
  final int? id;

  Sb({
    this.view,
    this.id,
  });

  factory Sb.fromJson(Map<String, dynamic> json) => Sb(
        view: json["view"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "id": id,
      };
}

class SpecialCharacter {
  final int? id;
  final String? img;
  final String? des;
  final String? name;
  final int? orderBy;
  final DateTime? updateAt;

  SpecialCharacter({
    this.id,
    this.img,
    this.des,
    this.name,
    this.orderBy,
    this.updateAt,
  });

  factory SpecialCharacter.fromJson(Map<String, dynamic> json) =>
      SpecialCharacter(
        id: json["id"],
        img: json["img"],
        des: json["des"],
        name: json["name"],
        orderBy: json["order_by"],
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
        "des": des,
        "name": name,
        "order_by": orderBy,
        "update_at": updateAt?.toIso8601String(),
      };
}
