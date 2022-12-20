// To parse this JSON data, do
//
//     final locationModel = locationModelFromMap(jsonString);

import 'dart:convert';

class LocationModel {
    LocationModel({
        this.type,
        this.query,
        this.features,
        this.attribution,
    });

    String? type;
    List<double>? query;
    List<Feature>? features;
    String? attribution;

    factory LocationModel.fromJson(String str) => LocationModel.fromMap(json.decode(str));

    factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        type: json["type"] ?? '',
        query: json["query"] == null ? null : List<double>.from(json["query"].map((x) => x.toDouble())),
        features: json["features"] == null ? null : List<Feature>.from(json["features"].map((x) => Feature.fromMap(x))),
        attribution: json["attribution"] ?? '',
    );

}

class Feature {
    Feature({
        this.id,
        this.type,
        this.placeType,
        this.relevance,
        this.properties,
        this.text,
        this.placeName,
        this.center,
        this.geometry,
        this.address,
        this.context,
    });

    String? id;
    String? type;
    List<String>? placeType;
    int? relevance;
    Properties? properties;
    String? text;
    String? placeName;
    List<double>? center;
    Geometry? geometry;
    String? address;
    List<Context>? context;

    factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

    factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"] ?? '',
        type: json["type"] ?? '',
        placeType: json["place_type"] == null ? null : List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"] ?? '',
        properties: json["properties"] == null ? null : Properties.fromMap(json["properties"]),
        text: json["text"] ?? '',
        placeName: json["place_name"] ?? '',
        center: json["center"] == null ? null : List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: json["geometry"] == null ? null : Geometry.fromMap(json["geometry"]),
        address: json["address"] ?? '',
        context: json["context"] == null ? null : List<Context>.from(json["context"].map((x) => Context.fromMap(x))),
    );

}

class Context {
    Context({
        this.id,
        this.text,
        this.wikidata,
        this.shortCode,
    });

    String? id;
    String? text;
    String? wikidata;
    String? shortCode;

    factory Context.fromJson(String str) => Context.fromMap(json.decode(str));

    factory Context.fromMap(Map<String, dynamic> json) => Context(
        id: json["id"] ?? '',
        text: json["text"] ?? '',
        wikidata: json["wikidata"] ?? '',
        shortCode: json["short_code"] ?? '',
    );
}

class Geometry {
    Geometry({
        this.type,
        this.coordinates,
    });

    String? type;
    List<double>? coordinates;

    factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

    factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        type: json["type"] ?? null,
        coordinates: json["coordinates"] == null ? null : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );
}

class Properties {
    Properties({
        this.accuracy,
    });

    String? accuracy;

    factory Properties.fromJson(String str) => Properties.fromMap(json.decode(str));

    factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"] ?? '',
    );
}
