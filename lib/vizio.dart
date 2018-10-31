import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Device {
  final String friendlyName;
  final String name;
  Device(this.friendlyName, this.name);
}

class Vizio {
  IOClient _client =
      IOClient(HttpClient()..badCertificateCallback = (_, __, ___) => true);

  String _authorization;

  Vizio(this._authorization);

  Map<String, String> get _headers => {
        'AUTH': _authorization,
      };
  Future<dynamic> _currentInput() =>
      _getWithAuth('/menu_native/dynamic/tv_settings/devices/current_input');

  Future<List<Device>> listInputs() async {
    var result = <Device>[];
    var response = await _getWithAuth(
        '/menu_native/dynamic/tv_settings/devices/name_input');
    for (var item in response['ITEMS']) {
      result.add(Device(item['VALUE']['NAME'], item['NAME']));
    }
    return result;
  }

  Future<void> off() => _sendCommand(11, 0);

  Future<void> power() => _sendCommand(11, 1);

  Future<void> toggle() => _sendCommand(11, 2);

  Future<void> setInput(String name) async {
    var current = (await _currentInput())['ITEMS'][0];
    var body = {
      'REQUEST': 'MODIFY',
      'VALUE': name,
      'HASHVAL': current['HASHVAL'],
    };
    return _putWithAuth(
        '/menu_native/dynamic/tv_settings/devices/current_input', body);
  }

  Future<void> volumDown() => _sendCommand(5, 0);

  Future<void> volumUp() => _sendCommand(5, 1);

  Future<dynamic> _getWithAuth(String url) async {
    var response = await _client.get(
      'https://192.168.86.100:7345$url',
      headers: _headers,
    );
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> _putWithAuth(String url, dynamic body) async {
    var encodedByd = json.encode(body);
    var response = await _client.put('https://192.168.86.100:7345$url',
        headers: _headers
          ..addAll({
            'Content-type': 'application/json',
            'Accept': 'application/json',
          }),
        body: encodedByd);
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> _sendCommand(int codeset, int code) =>
      _putWithAuth('/key_command/', {
        'KEYLIST': [
          {'CODESET': codeset, 'CODE': code, 'ACTION': 'KEYPRESS'}
        ]
      });
}
