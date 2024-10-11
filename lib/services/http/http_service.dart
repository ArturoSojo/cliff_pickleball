import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart';

class HttpService {
  final Supplier<Client> clientSupplier;

  HttpService(this.clientSupplier);

  Future<Response> response(Future<Response> Function(Client) f) {
    var client = clientSupplier();
    return f(client).whenComplete(() => client.close());
  }

  Future<StreamedResponse> streamedResponse(
      Future<StreamedResponse> Function(Client client) f) {
    var client = clientSupplier();
    return f(client).whenComplete(() => client.close());
  }
}
