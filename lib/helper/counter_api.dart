import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/counter.dart';


class CounterApi {
  final HttpClient _httpClient = HttpClient();


  static Future<Counter> create(Map body, String _url) async {
    print('Body 👉 : $body');
    var response = await http.post(
      Uri.parse('$_url/counter/create'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      print('Rec: $receivedData');
      receivedData['weight'] = receivedData['weight'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to create counter.');
    }
  }

  static Future<Counter> readCounter(String _id, String _url) async {
    var response = await http.get(
      Uri.parse('$_url/counter?id=$_id'),
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to read counter.');
    }
  }

  static Future<Counter> readCounterByCode(String _stockCode, String _url) async {
    print('URL: $_url/counter?stockCode=$_stockCode');
    var response = await http.get(
      Uri.parse('$_url/counter?stockCode=$_stockCode'),
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to read counter.');
    }
  }

  static Future<Counter> readCounterByCodeAndDate(String _stockCode, String _url) async {
    print('URL Order 👉: $_url/counter/order?stockCode=$_stockCode');
    var response = await http.get(
      Uri.parse('$_url/counter/order?stockCode=$_stockCode'),
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to read counter.');
    }
  }

  static Future<List<Counter>> readCountersWithMachine(String _url, String _machine) async {
    print('URL Machine 👉: $_url/counter/machine?machine=$_machine');
    var response = await http.get(
      Uri.parse('$_url/counter/machine?machine=$_machine')
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      for (int i = 0; i < receivedData.length; i++) {
        receivedData[i]['weight'] = receivedData[i]['weight'].toDouble();
      }

      return receivedData.map<Counter>((json) => Counter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to read counters.');
    }
  }

  static Future<List<Counter>> readAllCounters(String _url) async {
    var response = await http.get(
      Uri.parse('$_url/counter/all')
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      for (int i = 0; i < receivedData.length; i++) {
        receivedData[i]['weight'] = receivedData[i]['weight'].toDouble();
      }

      return receivedData.map<Counter>((json) => Counter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to read counters.');
    }
  }

  static Future<Counter> updateCounter(String _id, String _updatedAt, String _qty, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/counter/updateQty'),
      body: {
        'id': _id,
        'updated_at': _updatedAt,
        'qty': _qty
      }
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to update counter.');
    }
  }

  static Future<int> delete(String _id, String _url) async {
    var response = await http.delete(
      Uri.parse('$_url/counter/delete'),
      body: {
        'id': _id,
      }
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return int.parse(receivedData['id']);
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