import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ApiClient {
  final Dio _dio = Dio();

  Future<List<dynamic>> loadJsonData(String path) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      
      final jsonData = json.decode(jsonString);
      
      if (jsonData is List) {
        return jsonData;
      } else if (jsonData is Map) {
        return [jsonData];
      } else {
        throw Exception("Invalid JSON format");
      }
    } catch (e) {
      throw Exception("Failed to load JSON data: $e");
    }
  }
}