// To parse this JSON data, do
//
//     final kisi = kisiFromJson(jsonString);

import 'dart:convert';

Kisi kisiFromJson(String str) => Kisi.fromJson(json.decode(str));

String kisiToJson(Kisi data) => json.encode(data.toJson());

class Kisi {
    String id;
    String name;
    String num;

    Kisi({
        required this.id,
        required this.name,
        required this.num,
    });

    factory Kisi.fromJson(Map<String, dynamic> json) => Kisi(
        id: json["id"],
        name: json["name"],
        num: json["num"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "num": num,
    };
}
