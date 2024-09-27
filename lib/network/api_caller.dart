import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_api_integration/network/apis.dart';

class ApiCaller {
  static Future<dynamic> get(String endPoint) async {
    try {
      final response = await http.get(Uri.parse('${Apis.BaseURL}$endPoint'));
      if (response.statusCode != 200) {
        throw 'Failed with status code: ${response.statusCode}';
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error ==> $e');
      rethrow;
    }
  }

  // HTTP POST request method (to be implemented)
  Future<void> post() async {
    // Implementation for POST request
  }
}
