import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mycarmanager/model/car.dart';

class RequestResult {
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

final headers = {'Content-Type': 'application/json'};
final encoding = Encoding.getByName('utf-8');

getData(String route, {id = ''}) async {
  var url = Uri.http('192.168.1.87:8000', '/$route/$id');

  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return RequestResult(true, jsonDecode(response.body));
    } else {
      return RequestResult(false, jsonDecode(response.body));
    }
  } catch (ex) {
    print(ex);
  }
}

deleteData(String route, int id) async {
  var url = Uri.http('192.168.1.87:8000', '/$route/$id');

  try {
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      return RequestResult(true, jsonDecode(response.body));
    } else {
      return RequestResult(false, jsonDecode(response.body));
    }
  } catch (ex) {
    print(ex);
  }
}

addData(String route, data) async {
  String body = data is Car ? json.encode(data.toJson()) : json.encode(data);
  var url = Uri.http('192.168.1.87:8000', '/$route/');
  print(body);

  try {
    var response =
        await http.post(url, body: body, headers: headers, encoding: encoding);
    if (response.statusCode == 200) {
      return RequestResult(true, jsonDecode(response.body));
    } else {
      return RequestResult(false, jsonDecode(response.body));
    }
  } catch (ex) {
    print(ex);
  }
}

updateData(String route, int id, data) async {
  String body = json.encode(data.toJson());
  var url = Uri.http('192.168.1.87:8000', '/$route/$id');
  print(body);
  print(id);

  try {
    var response =
        await http.put(url, body: body, headers: headers, encoding: encoding);
    if (response.statusCode == 200) {
      return RequestResult(true, jsonDecode(response.body));
    } else {
      return RequestResult(false, jsonDecode(response.body));
    }
  } catch (ex) {
    print(ex);
  }
}
