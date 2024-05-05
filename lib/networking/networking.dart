import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gaubeVaha/inc/auth.inc.dart';
import 'package:gaubeVaha/inc/funkce.inc.dart';
import 'package:gaubeVaha/store/global_keys.dart';
import 'package:gaubeVaha/views/login_page.dart';

// ignore_for_file: avoid_print
class NetworkHelper extends Auth {
  NetworkHelper({
    required this.module,
    required this.action,
    this.data,
  });

  final String module;
  final String action;
  final dynamic data;

  final bool _isProductionMode = const bool.fromEnvironment('dart.vm.product');
  final bool _forceProduction = true;
  bool get _useProduction => _isProductionMode || _forceProduction;

  final bool _allowDebug = false;

  _getServerUrl({type = 0}) async {
    final serverName = await getServerName2();

    final List test = [
      'http://$serverName', // server 0
    ];

    return test[type] + '/?m=$module&act=$action&token=uhk-pro2-token&format=json';
  }

  _getUrl() async {
    int curType = 0;
    if (_useProduction == false) {
      curType = 1;
      // print("This is development mode using local server API :-)");
    }

    final server = await _getServerUrl(type: curType);

    return Uri.parse(server);
    // return Uri.parse('http://${serverName}.loc/api/?m=$module&act=$action');
  }

  void _processStatusList(statusList) {
//    if (statusList != null && statusList.isEmpty ) {

    if (statusList != null ) {
      for (var item in statusList) {
        if (item['status'] == 'auth_error') {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false);
          break;
        }

        if (item['status'] != 'ok') {
          notificationAlert(message: item['message']);
        }
      }
    }
  }

  _prepareData() async {
    Map<String, dynamic> map = {};

    try {
      map['access-token'] = await getAccessToken();
      // map['access-token'] = '14365c6bb265cce79421fb9455fadfc302cc4de1';

      // map['date'] = date ?? '';
      if (data != null && data.isNotEmpty) {
        for (var key in data.keys) {
          if (data[key] != null) {
            map[key] = data[key].toString();
          } else {
            map[key] = '';
          }
          // print('$key ${data[key]}');
        }
      }
    } catch (e) {
      notificationAlert(message: 'Problém s parametry');
    }

    return map;
  }

  Future getData() async {
    try {
      Uri url = await _getUrl();
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        // no error encounter
        final Map<String, dynamic> resBodyJson = jsonDecode(response.body);
        // _guardAuthError(data['status_list']);

        return (resBodyJson);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      notificationAlert(message: 'Problém s připojením k serveru cece' );
    }
  }

  Future postData() async {
    try {
      Uri url = await _getUrl();
      print("url: " + url.toString());
      stdout.write(url);
      http.Response response = await http.post(
        url,
        body: await _prepareData(),
      );

      if (response.statusCode == 200) {
        // no error encounter

        String resBody = response.body;

        final Map<String, dynamic> resBodyJson = jsonDecode(resBody);

        _processStatusList(resBodyJson['status_list']);

        if (_isProductionMode == false && _allowDebug == true) {
          print(['url: $url', 'response: $resBodyJson']);
        }
        return resBodyJson;
      } else {
        throw (response.statusCode);
      }
    } catch (e) {
      print(e);
      notificationAlert(message: 'Problém s připojením k serveru bb [$e]');
      return {};
    }
  }

  Future index() async {
    try {
      Uri url = await _getUrl();
      http.Response response = await http.post(
        url,
        body: await _prepareData(),
      );

      if (response.statusCode == 200) {
        // no error encounter

        String resBody = response.body;
        return ({'headers': response.headers, 'body': jsonDecode(resBody)});
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      notificationAlert(message: 'Problém s připojením k serveru xx');
    }
  }

  printHeaders(res) {
    var map = <String, dynamic>{};
    for (var key in res.headers.keys) {
      map[key] = res.headers[key];
      print('$key ${map[key]}');
    }
  }
}
