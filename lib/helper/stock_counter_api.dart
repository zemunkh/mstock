import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import '../model/stockCounter.dart';

class StockCounterApi {

  static Future<Result<Exception, StockCounter>> create(Map body, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/stock_counter/create'),
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
      print(' Problem 👉 : $err');
      throw Exception('Failed to create new StockIn Counter.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedData = json.decode(response.body);
        receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
        return Success(StockCounter.fromJson(receivedData));
      }
    } else {
      return Error(Exception(response));
    }
  }

  static Future<StockCounter> readCounter(String _id, String _url) async {
    var response = await http.get(
      Uri.parse('$_url/stock_counter/read?id=$_id'),
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
      receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
      return StockCounter.fromJson(receivedData);
    } else {
      throw Exception('Failed to read stock counter.');
    }
  }

  // readCounterInsNotPosted
  static Future<Result<Exception, List<StockCounter>>> readStockCountersNotPosted(String _url) async {
    var response = await http.get(
      Uri.parse('$_url/stock_counter/status?posted=0'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to read Stock Counters.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedList = [];
        var receivedData = json.decode(response.body);
        // print('$receivedData');
        for (int i = 0; i < receivedData.length; i++) {
          receivedData[i]['purchasePrice'] = receivedData[i]['purchasePrice'].toDouble();
          receivedList.add(receivedData[i]);
        }
        return Success(receivedList.map<StockCounter>((json) => StockCounter.fromJson(json)).toList());
      }
    } else {
      return Error(Exception(response));
    }
  }

  // readCounterInsPosted
  static Future<Result<Exception, List<StockCounter>>> readStockCountersPosted(String _url) async {  
    var response = await http.get(
      Uri.parse('$_url/stock_counter/status?posted=1'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to read Stock Counters.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedList = [];
        var receivedData = json.decode(response.body);
        // print('$receivedData');
        for (int i = 0; i < receivedData.length; i++) {
          receivedData[i]['purchasePrice'] = receivedData[i]['purchasePrice'].toDouble();
          receivedList.add(receivedData[i]);
        }
        return Success(receivedList.map<StockCounter>((json) => StockCounter.fromJson(json)).toList());
      }
    } else {
      return Error(Exception(response));
    }
  }

  // readCounterByCodeAndMachine
  static Future<Result<Exception, List<StockCounter>>> readStockCountersByCodeAndMachine(String _stockCode, String _machine, String _url) async {
    var response = await http.get(
      Uri.parse('$_url/stock_counter/machine?stockCode=$_stockCode&machine=$_machine'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('🚨 : $err');
      throw Exception('Failed to read Stock Counters.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedList = [];
        var receivedData = json.decode(response.body);
        if(receivedData.isEmpty) {
          return Error(Exception(http.Response('Empty result', 404)));
        }
        for (int i = 0; i < receivedData.length; i++) {
          receivedData[i]['purchasePrice'] = receivedData[i]['purchasePrice'].toDouble();
          receivedList.add(receivedData[i]);
        }
        return Success(receivedList.map<StockCounter>((stock) => StockCounter.fromJson(stock)).toList());
      }
    } else {
      return Error(Exception(response));
    }
  }

  // readAllCounters
  static Future<Result<Exception, List<StockCounter>>> readAllStockCounters(String _url) async {
    var response = await http.get(
      Uri.parse('$_url/stock_counter/all'),
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      print('👉 : $err');
      throw Exception('Failed to read Stock Counters.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedList = [];
        var receivedData = json.decode(response.body);
        // print('$receivedData');
        for (int i = 0; i < receivedData.length; i++) {
          receivedData[i]['purchasePrice'] = receivedData[i]['purchasePrice'].toDouble();
          receivedList.add(receivedData[i]);
        }
        return Success(receivedList.map<StockCounter>((json) => StockCounter.fromJson(json)).toList());
      }
    } else {
      return Error(Exception(response));
    }
  }

  // update
  static Future<Result<Exception, StockCounter>> update(Map body, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/stock_counter/update'),
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
      throw Exception('Failed to update StockIn Counter.');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedData = json.decode(response.body);
        receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
        return Success(StockCounter.fromJson(receivedData));
      }
    } else {
      return Error(Exception(response));
    }
  }

  // updatePostedStatus
  static Future<Result<Exception, StockCounter>> updatePostedStatus(String _id, bool _isPosted, String _url) async {
    var response = await http.post(
      Uri.parse('$_url/stock_counter/updateStatus'),
      body: {
        'id': _id,
        'isPosted': _isPosted ? '1' : '0',
      }
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).catchError((err) {
      throw Exception('Reason: $err');
    });

    if (response.statusCode == 200) {
      if(response.body.isEmpty) {
        return Error(Exception('404'));
      } else {
        var receivedData = json.decode(response.body);
        receivedData['purchasePrice'] = receivedData['purchasePrice'].toDouble();
        return Success(StockCounter.fromJson(receivedData));
      }
    } else {
      return Error(Exception(response));
    }
  }

  // delete
  static Future<int> delete(String _id, String _url) async {
    var response = await http.delete(
      Uri.parse('$_url/stock_counter/delete'),
      body: {
        'id': _id
      }
    );

    if (response.statusCode == 200) {
      var receivedData = json.decode(response.body);
      return int.parse(receivedData['id']);
    } else {
      throw Exception('Failed to delete stock_counter.');
    }
  }
}


  // result.when((err) async {
  //   if('$err'.contains('404')) {

  //   } else {
  //     Utils.openDialogPanel(context, 'close', 'Oops!', '#2 $err', 'Understand');
  //   }

  // }, (c) async {

  // });