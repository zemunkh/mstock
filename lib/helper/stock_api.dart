import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/stock.dart';
import '../model/stock1.dart';


class StockApi {
  final HttpClient _httpClient = HttpClient();

  // Read stock is full version Stock Data
  static Future<Stock1> readFullStock(String dbCode, String _id, String _url) async {
    http.Response response = await http.get(
      Uri.parse('$_url/$_id'),
      headers: {
        "DbCode": dbCode,
        "Content-Type": "application/json"
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });
    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      print('✅ GOT Answer: ${receivedData['remark1']} ${receivedData['baseUOM']} ');
      if(receivedData['remark1'] == null) {
        receivedData['remark1'] = '1';
      }
      return Stock1.fromJson(receivedData);
    } else {
      throw Exception('${response.statusCode} Failed to read full stock');
    }
  }

  // final _url = 'http://$ip:$port/api/Stocks';
  Future<String> getStocks(String dbCode, String _url) async {
    print("Accessing URL: $_url : $dbCode");
    http.Response response = await http.get(
      Uri.parse(_url),
      headers: {
        "DbCode": dbCode,
        "Content-Type": "application/json"
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to fetch data.');
    });
    if (response.statusCode == 200) {
      return response.body;
    } else if(response.statusCode == 408) {
      return 'Timed out! Wrong service address';
    } else {
      throw Exception('Failed to fetch data.');
    }
  }

  // Get Stock with BaseUOM and its UOM rate

  Future<Stock> getStock(String _id, String _url) async {
    var response = await http.get(
      Uri.parse('$_url?id=$_id'),
    );
    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return Stock.fromJson(receivedData);
    } else {
      throw Exception('Failed to get stock.');
    }
  }

  static Future<int> postStockIns(String dbCode, Map body, String _url) async {
    // print('JSON 👉: ${json.encode(body)}');
    // Prepare for the Post request (http)
    var response = await http.post(
      Uri.parse('$_url/api/StockIns'),
      headers: {
        "Content-Type": "application/json;odata.metadata=minimal;odata.streaming=true",
        "Accept": "application/json",
        "DbCode": dbCode
      },
      body: json.encode(body)
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response('Timed out', 408);
      },
    ).catchError((err) {
      print('Post 👉 : $err');
      return http.Response('Failed to post data', 500);
    });
    print('✅ Response: ${response.body}');
    print('✅ Response status: ${response.statusCode}');
    return response.statusCode;
  }
}
    // "id": "b7c15a9f-1397-4d83-9873-244b7cdfb203",
    // "stockInCode": "SIN1801/001",
    // "stockInDate": "2018-01-30",
    // "description": "Meng",
    // "referenceNo": null,
    // "title": null,
    // "totalAmount": 943.4,
    // "costCentre": null,
    // "project": "Serdang",
    // "stockLocation": "HQ",