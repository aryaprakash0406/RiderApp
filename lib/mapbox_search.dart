import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'location_model.dart';
import 'main.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken =
    "sk.eyJ1IjoiYXJ5YXByYWthc2gyMiIsImEiOiJjbGJrZGRqdXgxaTdoM3BwNGprczJ1dmgzIn0.3BZbit4Xk5EoRNuM0XYV7w";
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
String proximity =
    '${sharedPreferences.getDouble('longitude')}%2C${sharedPreferences.getDouble('latitude')}';
String country = 'us';

Dio _dio = Dio();

Future<LocationModel> getSearchResultsFromQueryUsingMapbox(String query) async {
  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    print(responseData);
    LocationModel model = LocationModel.fromMap(responseData.data);
    return model;
  } catch (e) {
    print(e);
  }
  throw Exception('Error');
}
