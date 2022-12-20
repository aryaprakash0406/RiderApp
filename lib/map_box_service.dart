import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:riderapp/location_model.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken =
    "sk.eyJ1IjoiYXJ5YXByYWthc2gyMiIsImEiOiJjbGJrZGRqdXgxaTdoM3BwNGprczJ1dmgzIn0.3BZbit4Xk5EoRNuM0XYV7w";

Dio _dio = Dio();

Future<LocationModel> getReverseGeocodingGivenLatLngUsingMapbox(
    LatLng latLng) async {
  String query = '${latLng.longitude},${latLng.latitude}';
  String url = '$baseUrl/$query.json?access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    Response responseData = await _dio.get(url);
    print(responseData);
    // Map<String, dynamic> data = responseData.data;
    LocationModel model = LocationModel.fromMap(responseData.data);
    return model;
    // return responseData.data;

  } catch (e) {
    print(e);
  }
  throw Exception('Error');
}
