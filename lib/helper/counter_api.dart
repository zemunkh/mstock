import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import '../model/counter.dart';


class CounterApi {
  final HttpClient _httpClient = HttpClient();

  static Future<Counter> createLog(Map body, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/logging/create'),
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
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      print('Rec: $receivedData');
      receivedData['weight'] = receivedData['weight'].toDouble();
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to create counter.');
    }
  }

  static Future<Result<Exception, Counter>> create(Map body, String _url) async {
    //print('Body 👉 : $body');
    var response = await http.post(
      Uri.parse('$_url/counter/create'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to create new Counter.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedData = json.decode(response.body);
        receivedData['weight'] = receivedData['weight'].toDouble();
        receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
        return Success(Counter.fromJson(receivedData));
      }
    } else {
      return Error(Exception(response));
    }
  }

  static Future<Counter> readCounter(String _id, String _url) async {
    var response = await http.get(
      Uri.parse('$_url/counter/one?id=$_id'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      print('Main body: ${response.body}');
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
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
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to read counter.');
    }
  }

  static Future<Result<Exception, Counter>> readCounterByCodeAndMachine(String _stockCode, String _machine, String _url) async {
    // print('URL: $_url/counter/stock/machine?stockCode=$_stockCode&machine=$_machine');
    var response = await http.get(
      Uri.parse('$_url/counter/stock/machine?stockCode=$_stockCode&machine=$_machine'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      // print('👉 Res: ${response.body}');
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedData = json.decode(response.body);
        receivedData['weight'] = receivedData['weight'].toDouble();
        receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
        return Success(Counter.fromJson(receivedData));
      }
    } else {
      return Error(Exception(response));
    }
  }

  static Future<Counter> readCounterByCodeAndDate(String _stockCode, String _url) async {
    print('URL Order 👉: $_url/counter/order?stockCode=$_stockCode');
    var response = await http.get(
      Uri.parse('$_url/counter/order?stockCode=$_stockCode'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
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
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedList = [];
      if(response.body.isEmpty) {
        return [];
      } else {
        var receivedData = json.decode(response.body);
        for (int i = 0; i < receivedData.length; i++) {
          receivedData[i]['weight'] = receivedData[i]['weight'].toDouble();
          receivedData[i]['purchasePrice'] = receivedData[i]['purchasePrice'].toDouble();
          receivedList.add(receivedData[i]);
        }

        return receivedList.map<Counter>((counter) => Counter.fromJson(counter)).toList();
      }
    } else {
      throw Exception('Failed to read counters.');
    }
  }

  static Future<List<Counter>> readAllCounters(String _url) async {
    var response = await http.get(
      Uri.parse('$_url/counter/all')
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      for (int i = 0; i < receivedData.length; i++) {
        receivedData[i]['weight'] = receivedData[i]['weight'].toDouble();
        receivedData[i]['purchasePrice'] = receivedData[i]['purchasePrice'].toDouble();
      }

      return receivedData.map<Counter>((counter) => Counter.fromJson(counter)).toList();
    } else {
      throw Exception('Failed to read counters.');
    }
  }

  static Future<Counter> addCounter(String _id, String _updatedAt, String _qty, String _totalQty, String _url, String _from, String _deviceName) async {
    var response = await http.post(
      Uri.parse('$_url/counter/add'),
      body: {
        'id': _id,
        'updated_at': _updatedAt,
        'totalQty': _totalQty,
        'qty': _qty,
        'from': _from,
        'device': _deviceName
      }
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to update counter.');
    }
  }


  static Future<Counter> dropCounter(String _id, String _updatedAt, String _qty, String _totalQty, String _url, String _from, String _deviceName) async {
    var response = await http.post(
      Uri.parse('$_url/counter/drop'),
      body: {
        'id': _id,
        'updated_at': _updatedAt,
        'totalQty': _totalQty,
        'qty': _qty,
        'from': _from,
        'device': _deviceName
      }
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Failed to fetch data.');
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      receivedData['weight'] = receivedData['weight'].toDouble();
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
      return Counter.fromJson(receivedData);
    } else {
      throw Exception('Failed to update counter.');
    }
  }

  static Future<int> delete(String _id, String _from, String _url) async {
    var response = await http.delete(
      Uri.parse('$_url/counter/delete'),
      body: {
        'id': _id,
        'from': _from
      }
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return int.parse(receivedData['id']);
    } else {
      throw Exception('Failed to update counter.');
    }
  }

  static Future<String> connectionChecker(String _code, _url) async {
    var response = await http.get(
      Uri.parse('$_url/check?code=$_code'),
    ).timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('Connection check 👉 : $err');
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      print('Code: ${receivedData['code']} $receivedData');
      print('Type: ${receivedData['code'].runtimeType}');
      return receivedData['code'];
    } else {
      return '0';
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