import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/counter.dart';


class CounterApi {
  final HttpClient _httpClient = HttpClient();


  static Future<List<Counter>> create(String body, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/counter/create'),
      body: body);

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return receivedData.map<Counter>((json) => Counter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to create counter.');
    }
  }

  static Future<Counter> readCounter(String _id, String _url) async {
    var response = await http.get(
      Uri.parse('$_url/counter?id=$_id'),
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return receivedData.map<Counter>((json) => Counter.fromJson(json));
    } else {
      throw Exception('Failed to read counter.');
    }
  }

  static Future<Counter> readCounterByCode(String _stockCode, String _url) async {
    print('URL: $_url/counter?stockCode=$_stockCode');
    var response = await http.get(
      Uri.parse('$_url/counter?stockCode=$_stockCode'),
    );

    if (response.statusCode == 200) {
      print('RES ✅: ${response.body}');
      var receivedData = json.decode(response.body);
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to read counter.');
    }
  }

  static Future<List<Counter>> readAllCounters(String _url) async {
    var response = await http.get(
      Uri.parse('$_url/counter/all')
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body)['counters'];
      print('Decoded ✅: $receivedData');
      // var validList = [];
      for (int i = 0; i < receivedData.length; i++) {
        // if(receivedData['counters'][i]['weight'].runtimeType == double) {
          receivedData[i]['weight'] = receivedData[i]['weight'].toDouble();
        // }
      }

      return receivedData.map<Counter>((json) => Counter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to read counters.');
    }
  }

  static Future<Counter> updateCounter(String _id, String _qty, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/counter/updateQty'),
      body: {
        'id': _id,
        'qty': _qty
      }
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return receivedData.map<Counter>((json) => Counter.fromJson(json));
    } else {
      throw Exception('Failed to update counter.');
    }
  }

  static Future<List<Counter>> delete(String _id, String _url) async {
    var response = await http.delete(
      Uri.parse('$_url/counter/delete'),
      body: {
        'id': _id,
      }
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return receivedData.map<Counter>((json) => Counter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to update counter.');
    }
  }

  Future<Map<String, dynamic>> getJson (Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if(httpResponse.statusCode != HttpStatus.ok) {
        throw Exception('Failed to load stock data');
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();

      return json.decode(responseBody);
    } on Exception catch(e) {
      print('$e');
      return {};
    }
  }
}