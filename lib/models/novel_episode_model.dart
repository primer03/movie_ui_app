import 'dart:convert';

Episode episodeFromJson(String str) => Episode.fromJson(json.decode(str));

String episodeToJson(Episode data) => json.encode(data.toJson());

class Episode {
  final String epData;
  final int addbook;
  final List<HisRead> hisRead;

  Episode({
    required this.epData,
    required this.addbook,
    required this.hisRead,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        epData: json["epData"],
        addbook: json["Addbook"],
        hisRead:
            List<HisRead>.from(json["HisRead"].map((x) => HisRead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "epData": epData,
        "Addbook": addbook,
        "HisRead": List<dynamic>.from(hisRead.map((x) => x.toJson())),
      };
}

class HisRead {
  final String epId;

  HisRead({
    required this.epId,
  });

  factory HisRead.fromJson(Map<String, dynamic> json) => HisRead(
        epId: json["epID"],
      );

  Map<String, dynamic> toJson() => {
        "epID": epId,
      };
}
