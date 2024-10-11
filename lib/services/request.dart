import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:cliff_pickleball/utils/get_credentials.dart';
import 'package:cliff_pickleball/utils/utils.dart';

class Request {
  static Future sendPos(data) async {
    var url = Uri.https(MyUtils.base, MyUtils.uri, MyUtils.params);
    var body = jsonEncode(data);
    var headers = MyUtils.headers;
    var token = await getToken();
    if (token != null) {
      headers["Authorization"] = "bearer ${token}";
    }
    print(body);
    print(headers);
    try {
      http.Response response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (response.statusCode == 404) {
          return <String, dynamic>{
            "message": "THIS_ROUTE_DOES_NOT_EXIST",
            "status": 404
          };
        }
        if (response.statusCode == 401) {
          if (response.body.isEmpty) {
            return <String, dynamic>{"message": "unauthorized", "status": 401};
          }
        }
        if (response.statusCode == 504) {
          if (response.body.isEmpty) {
            return <String, dynamic>{
              "message": "504_GATEWAY_TIMEOUT",
              "status": 504
            };
          }
        }
        var request = jsonDecode(response.body) as Map<String, dynamic>;
        if (request.containsKey("message")) {
          request["message"] = request["message"].toString();
        }
        if (request.containsKey("cause")) {
          if (request["cause"].length != 0) {
            request["cause"] =
                request["cause"].map((val) => val.toString()).toList();
            print(request["cause"].join(","));
          }
        }
        print(request);
        return request;
      }
    } on TimeoutException catch (_) {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    } on Error {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    }
  }

  static Future sendService(uri, Map<String, dynamic> params, data) async {
    print(MyUtils.base.toString());
    print(uri.toString());
    print(params.toString());
    print(data.toString());
    var url = Uri.https(MyUtils.base, uri, params);
    var body = jsonEncode(data);
    var headers = MyUtils.headers;
    var token = await getToken();
    if (token != null) {
      headers["Authorization"] = "bearer ${token}";
    }
    try {
      http.Response response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        var jsonResponse;
        if (jsonDecode(response.body) is List<dynamic>) {
          jsonResponse = jsonDecode(response.body);
        } else {
          jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        }
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (response.statusCode == 404) {
          return <String, dynamic>{
            "message": "THIS_ROUTE_DOES_NOT_EXIST",
            "status": 404
          };
        }
        if (response.statusCode == 401) {
          if (response.body.isEmpty) {
            return <String, dynamic>{"message": "unauthorized", "status": 401};
          }
        }
        if (response.statusCode == 504) {
          if (response.body.isEmpty) {
            return <String, dynamic>{
              "message": "504_GATEWAY_TIMEOUT",
              "status": 504
            };
          }
        }
        var request = jsonDecode(response.body) as Map<String, dynamic>;
        print(request);
        if (request.containsKey("message")) {
          request["message"] = request["message"].toString();
        }
        return request;
      }
    } on TimeoutException catch (_) {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    } on SocketException catch (err) {
      print('Request failed with SocketException');
      return {"message": err, "code": ""};
    } on ClientException catch (err) {
      print('Request failed with ClientException');
      return {"message": err, "code": ""};
    } on HttpException catch (err) {
      print('Request failed with HttpException');
      return {"message": err, "code": ""};
    }
  }

  static Future sendService2(
      uri, Map<String, dynamic> params, data, headers) async {
    print(MyUtils.base.toString());
    print(uri.toString());
    print(params.toString());
    var url = Uri.https(MyUtils.base, uri, params);
    var body = jsonEncode(data);

    try {
      http.Response response = await http
          .post(url,
              headers: headers.isNotEmpty ? headers : MyUtils.headers,
              body: body)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        var jsonResponse;
        if (jsonDecode(response.body) is List<dynamic>) {
          jsonResponse = jsonDecode(response.body);
        } else {
          jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        }
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (response.statusCode == 404) {
          return <String, dynamic>{
            "message": "THIS_ROUTE_DOES_NOT_EXIST",
            "status": 404
          };
        }
        if (response.statusCode == 401) {
          if (response.body.isEmpty) {
            return <String, dynamic>{"message": "unauthorized", "status": 401};
          }
        }
        if (response.statusCode == 504) {
          if (response.body.isEmpty) {
            return <String, dynamic>{
              "message": "504_GATEWAY_TIMEOUT",
              "status": 504
            };
          }
        }
        var request = jsonDecode(response.body) as Map<String, dynamic>;
        print(request);
        if (request.containsKey("message")) {
          request["message"] = request["message"].toString();
        }
        return request;
      }
    } on TimeoutException catch (_) {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    } on SocketException catch (err) {
      print('Request failed with SocketException');
      return {"message": err, "code": ""};
    } on ClientException catch (err) {
      print('Request failed with ClientException');
      return {"message": err, "code": ""};
    } on HttpException catch (err) {
      print('Request failed with HttpException');
      return {"message": err, "code": ""};
    }
  }

  static Future sendServiceUrlEncode(
      uri, Map<String, dynamic> params, data) async {
    print(MyUtils.base.toString());
    print(uri.toString());
    final url = Uri.https(MyUtils.base, uri);
    var headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    };
    var request = http.Request('POST', url);
    request.bodyFields = data;
    request.headers.addAll(headers);

    try {
      var response = await request.send();
      var body = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var jsonResponse;
        if (jsonDecode(body) is List<dynamic>) {
          jsonResponse = jsonDecode(body);
        } else {
          jsonResponse = jsonDecode(body) as Map<String, dynamic>;
        }
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (response.statusCode == 404) {
          return <String, dynamic>{
            "message": "THIS_ROUTE_DOES_NOT_EXIST",
            "status": 404
          };
        }
        if (response.statusCode == 401) {
          if (body.isEmpty) {
            return <String, dynamic>{"message": "unauthorized", "status": 401};
          }
        }
        if (response.statusCode == 504) {
          return <String, dynamic>{
            "message": "504_GATEWAY_TIMEOUT",
            "status": 504
          };
        }
        var request = jsonDecode(body) as Map<String, dynamic>;
        if (request.containsKey("message")) {
          request["message"] = request["message"].toString();
        }
        return request;
      }
    } on TimeoutException catch (_) {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    } on SocketException catch (err) {
      print('Request failed with SocketException');
      return {"message": err, "code": ""};
    } on ClientException catch (err) {
      print('Request failed with ClientException');
      return {"message": err, "code": ""};
    } on HttpException catch (err) {
      print('Request failed with HttpException');
      return {"message": err, "code": ""};
    }
  }

  static Future getData(uri, Map<String, dynamic> params) async {
    print(MyUtils.base.toString());
    print(uri.toString());
    print(params.toString());
    var url = Uri.https(MyUtils.base, uri, params);
    var headers = MyUtils.headers;
    var token = await getToken();
    if (token != null) {
      headers["Authorization"] = "bearer ${token}";
    }
    try {
      http.Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        if (response.statusCode == 404) {
          return <String, dynamic>{
            "message": "THIS_ROUTE_DOES_NOT_EXIST",
            "status": 404
          };
        }
        if (response.statusCode == 401) {
          if (response.body.isEmpty) {
            return <String, dynamic>{"message": "unauthorized", "status": 401};
          }
        }
        if (response.statusCode == 504) {
          return <String, dynamic>{
            "message": "504_GATEWAY_TIMEOUT",
            "status": 504
          };
        }
        print('Request failed with status: ${response.statusCode}.');
        var request = jsonDecode(response.body) as Map<String, dynamic>;
        if (request.containsKey("message")) {
          request["message"] = request["message"].toString();
        }
        print(request);
        return request;
      }
    } on TimeoutException catch (_) {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    } on SocketException catch (err) {
      print('Request failed with SocketException');
      return {"message": err, "code": ""};
    } on ClientException catch (err) {
      print('Request failed with ClientException');
      return {"message": err, "code": ""};
    } on HttpException catch (err) {
      print('Request failed with HttpException');
      return {"message": err, "code": ""};
    }
  }

  static Future sendPutService(uri, Map<String, dynamic> params, data) async {
    print(MyUtils.base.toString());
    print(uri.toString());
    print(params.toString());
    var url = Uri.https(MyUtils.base, uri, params);
    var body = jsonEncode(data);
    var headers = MyUtils.headers;
    var token = await getToken();
    print("este es el token ${token}");
    if (token != null) {
      headers["Authorization"] = "bearer ${token}";
      print(headers);
    }
    try {
      http.Response response = await http
          .put(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        if (response.statusCode == 405) {
          return <String, dynamic>{"status": 405, "message": "error"};
        }
        if (response.statusCode == 404) {
          return <String, dynamic>{
            "message": "THIS_ROUTE_DOES_NOT_EXIST",
            "status": 404
          };
        }
        if (response.statusCode == 401) {
          if (response.body.isEmpty) {
            return <String, dynamic>{"message": "unauthorized", "status": 401};
          }
        }
        if (response.statusCode == 504) {
          if (response.body.isEmpty) {
            return <String, dynamic>{
              "message": "504_GATEWAY_TIMEOUT",
              "status": 504
            };
          }
        }
        var request = jsonDecode(response.body) as Map<String, dynamic>;
        print(request);
        if (request.containsKey("message")) {
          request["message"] = request["message"].toString();
        }
        return request;
      }
    } on TimeoutException catch (_) {
      print('Request failed with timeOut 60s.');
      return {"message": "ERROR_TIMEOUT", "code": ""};
    } on SocketException catch (err) {
      print('Request failed with SocketException');
      return {"message": err, "code": ""};
    } on ClientException catch (err) {
      print('Request failed with ClientException');
      return {"message": err, "code": ""};
    } on HttpException catch (err) {
      print('Request failed with HttpException');
      return {"message": err, "code": ""};
    }
  }
}
