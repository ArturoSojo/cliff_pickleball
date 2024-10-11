import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/utils/translate.dart';

class ReceiptData {
  static getReceipt(Map data) {
    final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 2,
    );
    final CurrencyTextInputFormatter _formatter2 = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 3,
    );

    print("data de respuesta " + data.toString());
    String banco = "";
    String bancorif = "";
    String afiliacion = "";

    if (data.containsKey("collect_method")) {
      if (data["collect_method"].containsKey("bank_collector")) {
        if (data["collect_method"]["bank_collector"].containsKey("bank_name")) {
          banco = data["collect_method"]["bank_collector"]["bank_name"];
        }
        if (data["collect_method"]["bank_collector"].containsKey("bank_rif")) {
          bancorif = data["collect_method"]["bank_collector"]["bank_rif"];
        }
      }
      if (data["collect_method"].containsKey("masked_affiliation_number")) {
        afiliacion = data["collect_method"]["masked_affiliation_number"];
      }
    }
    String emisor = "";
    String tarjeta = "";
    String cardHolder = "";

    if (data.containsKey("payment_method")) {
      if (data["payment_method"].containsKey("payment_card")) {
        if (data["payment_method"]["payment_card"]
            .containsKey("card_emitter")) {
          if (data["payment_method"]["payment_card"]["card_emitter"]
              .containsKey("name")) {
            emisor = data["payment_method"]?["payment_card"]?["card_emitter"]
                ?["name"];
          }
        }
        if (data["payment_method"]["payment_card"]
            .containsKey("masked_account_number")) {
          tarjeta =
              data["payment_method"]?["payment_card"]?["masked_account_number"];
        }
        if (data["payment_method"]["payment_card"].containsKey("holder_name")) {
          cardHolder = data["payment_method"]?["payment_card"]?["holder_name"];
        }
      }
    }
    String comercio = "";
    String rif = "";

    if (data.containsKey("collector")) {
      if (data["collector"].containsKey("name")) {
        comercio = data["collector"]["name"];
      }
      if (data["collector"].containsKey("id_doc")) {
        rif = data["collector"]["id_doc"];
      }
    }
    String address = "";

    if (data.containsKey("wallet_store_address")) {
      address = data["wallet_store_address"];
    }
    String approval = "";
    String reference = "";
    String secuencia = "";
    String lote = "";
    String monto = "";
    String monto2 = "";
    String fecha = "";
    String hora = "";

    if (data.containsKey("credicard")) {
      // if (data["credicard"].containsKey("affiliate")) {
      //   afiliacion = data["credicard"]["affiliate"];
      // }
      if (data["credicard"].containsKey("approval")) {
        approval = data["credicard"]["approval"];
      }
      if (data["credicard"].containsKey("amount")) {
        data["amount"] = data["amount"].toStringAsFixed(2);
        monto = _formatter.format(data["amount"]);
      }
      if (data["credicard"].containsKey("amount_formatted")) {
        monto2 = data["amount_formatted"].toString();
      }
      if (data["credicard"].containsKey("reference")) {
        reference = data["credicard"]["reference"];
      }
      if (data["credicard"].containsKey("sequence")) {
        secuencia = data["credicard"]["sequence"];
      }
      if (data["credicard"].containsKey("lot")) {
        lote = data["credicard"]["lot"];
      }
      if (data["credicard"].containsKey("ist_date")) {
        var now = DateTime.now();
        var formatter = DateFormat('yyyy');
        var format1 = DateFormat('dd/MM/yy');
        final format2 = DateFormat('hh:mm:ss a');

        String year = formatter.format(now);
        final ist = data["credicard"]["ist_date"];
        final ist2 = data["credicard"]["ist_time"];
        var result =
            "${year}-${ist.substring(0, 2)}-${ist.substring(2, ist.length)} ${ist2.substring(0, 2)}:${ist2.substring(2, 4)}:${ist2.substring(4, ist2.length)}";
        var datetime = DateTime.parse(result);
        var tiempo = 4;
        var subs = (datetime.hour) > 9
            ? (datetime.hour).toString()
            : "0${(datetime.hour).toString()}";
        var result2 =
            "${year}-${ist.substring(0, 2)}-${ist.substring(2, ist.length)} ${subs.toString()}:${ist2.substring(2, 4)}:${ist2.substring(4, ist2.length)}";
        var datetime2 = DateTime.parse(result2);
        datetime2 = datetime2.subtract(Duration(hours: tiempo));
        if (data["payment_card_type"] == "TDD" &&
            data["state"] == "ANULATED" &&
            data["transactional_channel"] == "CHANNEL_7_3") {
          fecha = format1.format(datetime2);
          hora = format2.format(datetime2);
        } else {
          fecha = format1.format(datetime);
          hora = format2.format(datetime);
        }
      } else {
        if (data.containsKey("info")) {
          if (data["info"].containsKey("created_at")) {
            final dateTime = DateTime.parse(data["info"]["created_at"]);

            final format = DateFormat('DD-MM-yy');
            final format2 = DateFormat('hh:mm:ss a');

            final date = format.format(dateTime);
            final clockString = format2.format(dateTime);

            fecha = date;
            hora = clockString;
          }
        }
      }
    }
    String device = "";

    if (data.containsKey("device")) {
      device = data["device"];
    }

    String type_payment = "";
    if (data.containsKey("payment_card_type")) {
      type_payment = data["payment_card_type"];
    }

    return <String, dynamic>{
      "banco": banco,
      "banco_rif": bancorif,
      "emisor": emisor,
      "comercio": comercio,
      "address": address,
      "rif": rif,
      "afiliacion": afiliacion,
      "device": device,
      "lote": lote,
      "tarjeta": tarjeta,
      "fecha": fecha,
      "hora": hora,
      "approval": approval,
      "reference": reference,
      "secuencia": secuencia,
      "monto": monto,
      "monto2": monto2,
      "card_holder": cardHolder,
      "type_payment": type_payment
    };
  }

  static formattedLoginDataProfile(Map data) {
    String realm = "";
    String business_name = "";
    String id_doc = "";
    String country = "";
    String email = "";
    String id = "";

    if (data.containsKey("realm")) {
      realm = data["realm"];
    }
    if (data.containsKey("business_name")) {
      business_name = data["business_name"];
    }
    if (data.containsKey("id_doc")) {
      id_doc = data["id_doc"];
    }
    if (data.containsKey("country")) {
      country = data["country"];
    }
    if (data.containsKey("email_deflt")) {
      email = data["email_deflt"];
    }
    if (data.containsKey("id")) {
      id = data["id"];
    }
    return <String, String>{
      "realm": realm,
      "business_name": business_name,
      "id_doc": id_doc,
      "country": country,
      "email": email,
      "id": id
    };
  }

  static formattedLoginData(Map data) {
    String client_secret = "";
    String client_id = "";
    if (data.containsKey("secret")) {
      if (data["secret"].containsKey("id")) {
        client_secret = data["secret"]["id"];
      }
      if (data["secret"].containsKey("client_id")) {
        client_id = data["secret"]["client_id"];
      }
    }
    return <String, String>{
      "client_id": client_id,
      "client_secret": client_secret,
      "grant_type": "client_credentials",
    };
  }

  static lastFormatted(Map data) {
    final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 2,
    );

    String id = "";
    if (data.containsKey("order_number")) {
      id = data["order_number"];
    }
    String name = "";
    if (data.containsKey("collector_name")) {
      name = data["collector_name"];
    }
    String bank_name = "";
    if (data.containsKey("collector_bank_name")) {
      bank_name = data["collector_bank_name"];
    }
    String bank_rif = "";
    if (data.containsKey("collector_bank_rif")) {
      bank_rif = data["collector_bank_rif"];
    }
    String terminal = "";
    if (data.containsKey("device_id")) {
      terminal = data["device_id"];
    }
    String lote = "";
    if (data.containsKey("lot_number")) {
      lote = data["lot_number"];
    }
    String address = "";
    if (data.containsKey("store")) {
      if (data["store"].containsKey("address")) {
        address = data["store"]["address"];
      }
    }
    String card_holder_id = "";
    if (data.containsKey("card_holder_id")) {
      card_holder_id = data["card_holder_id"];
    }
    String rif = "";
    if (data.containsKey("collector_id_doc")) {
      rif = data["collector_id_doc"];
    }
    String timestamp = "";
    String fecha = "";
    String hora = "";
    if (data.containsKey("ist_date") && data.containsKey("ist_time")) {
      if (data["ist_date"].isEmpty || data["ist_time"].isEmpty) {
        print("esasdas dasdasd asdsadsadsadsa");
        if (data.containsKey("timestamp")) {
          if (data["timestamp"] != null) {
            var date = DateTime.parse(data["timestamp"]).toLocal();
            final format = DateFormat(
              'y-MM-dd hh:mm:ss a',
            );
            final format2 = DateFormat(
              'dd/MM/yy',
            );
            final format3 = DateFormat(
              'hh:mm:ss a',
            );
            timestamp = format.format(date);
            fecha = format2.format(date);
            hora = format3.format(date);
          }
        }
      } else {
        //print("este es el ist date ${data["ist_date"].isNotEmpty}");
        //print("este es el ist time ${data["ist_time"].isNotEmpty}");
        var now = DateTime.now();
        var formatter = DateFormat('yyyy');
        var format1 = DateFormat('dd/MM/yy');
        final format2 = DateFormat('hh:mm:ss a');

        String year = formatter.format(now);
        final ist = data["ist_date"];
        final ist2 = data["ist_time"];
        var result =
            "${year}-${ist.substring(0, 2)}-${ist.substring(2, ist.length)} ${ist2.substring(0, 2)}:${ist2.substring(2, 4)}:${ist2.substring(4, ist2.length)}";
        var datetime = DateTime.parse(result);
        var tiempo = 4;
        var subs = (datetime.hour) > 9
            ? (datetime.hour).toString()
            : "0${(datetime.hour).toString()}";
        var result2 =
            "${year}-${ist.substring(0, 2)}-${ist.substring(2, ist.length)} ${subs.toString()}:${ist2.substring(2, 4)}:${ist2.substring(4, ist2.length)}";
        var datetime2 = DateTime.parse(result2);
        datetime2 = datetime2.subtract(Duration(hours: tiempo));

        if ((data["payment_card_type"] == "TDD" ||
                data["payment_method_id"] == "DEBITO") &&
            data["status"] == "ANULATED" &&
            data["channel_type"] == "MC73") {
          fecha = format1.format(datetime2);
          hora = format2.format(datetime2);
        } else {
          fecha = format1.format(datetime);
          hora = format2.format(datetime);
        }
      }
    } else {
      if (data.containsKey("timestamp")) {
        if (data["timestamp"] != null) {
          var date = DateTime.parse(data["timestamp"]).toLocal();
          final format = DateFormat(
            'y-MM-dd hh:mm:ss a',
          );
          final format2 = DateFormat(
            'dd/MM/yy',
          );
          final format3 = DateFormat(
            'hh:mm:ss a',
          );
          timestamp = format.format(date);
          fecha = format2.format(date);
          hora = format3.format(date);
        }
      }
    }

    String status_id = "";
    if (data.containsKey("status_id")) {
      if (data["status_id"] != null && data["status_id"] != "null") {
        status_id = (data["status_id"].toString());
        status_id = translate(status_id);
      }
    }

    String card_holder = "";
    String card_name = "";
    String card_mask = "";
    if (data.containsKey("card_holder")) {
      card_holder = data["card_holder"];
    }
    if (data.containsKey("card_name")) {
      card_name = data["card_name"];
    }
    if (data.containsKey("card_holder_number_mask")) {
      card_mask = data["card_holder_number_mask"];
    }
    String affiliation_number = "";
    if (data.containsKey("affiliation_number")) {
      affiliation_number = data["affiliation_number"];
    }
    String lot_number = "";
    if (data.containsKey("lot_number")) {
      lot_number = data["lot_number"];
    }
    String monto = "";
    String amount = "";
    if (data.containsKey("amount")) {
      monto = _formatter.format(data["amount"].toString());
      amount = data["amount"].toString();
    }
    String status = "";
    String type = "";
    if (data.containsKey("status")) {
      status = (data["status"].toString());
      type = status == "ANULATED" ? "ANULACIÓN" : "COMPRA";
      status = translate(status);
    }
    String message = "";
    if (data.containsKey("message")) {
      if (data["message"] != null && data["message"] != "null") {
        message = (data["message"].toString());
      }
    }
    String approval = "";
    if (data.containsKey("approval")) {
      if (data["approval"] != null) {
        approval = (data["approval"]);
      }
    }
    String reference = "";
    if (data.containsKey("reference")) {
      if (data["reference"] != null) {
        reference = data["reference"].toString();
      }
    }
    String sequence = "";
    if (data.containsKey("sequence")) {
      sequence = (data["sequence"]);
    }
    String account_type = "";
    if (data.containsKey("account_type")) {
      account_type = (data["account_type"]);
    }
    String payment_method = "";
    if (data.containsKey("payment_method_id")) {
      if (data["payment_method_id"] != null) {
        payment_method = data["payment_method_id"];
      }
    }
    String code = "";
    if (data.containsKey("code") || data.containsKey("response_code")) {
      if (data["code"] != null || data["response_code"] != null) {
        code = data["code"] ?? data["response_code"];
      }
    }
    return <String, String>{
      "id": id,
      "name": name,
      "code": code,
      "rif": rif,
      "address": address,
      "bank_name": bank_name,
      "bank_rif": bank_rif,
      "terminal": terminal,
      "account_type": account_type,
      "lote": lote,
      "address": address,
      "timestamp": timestamp,
      "fecha": fecha,
      "hora": hora,
      "status_id": status_id,
      "card_holder": card_holder,
      "card_holder_id": card_holder_id,
      "card_name": card_name,
      "card_mask": card_mask,
      "affiliation_number": affiliation_number,
      "lot_number": lot_number,
      "sequence": sequence,
      "monto": monto,
      "amount": amount,
      "approval": approval,
      "reference": reference,
      "status": status,
      "type": type,
      "message": message,
      "payment_method": payment_method
    };
  }

  static transactionFormatted(Map data) {
    Logger().i(data);
    final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 2,
    );

    String id = "";
    if (data.containsKey("order_number")) {
      id = data["order_number"];
    }
    String name = "";
    if (data.containsKey("collector_name")) {
      name = data["collector_name"];
    }
    String bank_name = "";
    if (data.containsKey("collector_bank_name")) {
      bank_name = data["collector_bank_name"];
    }
    String bank_rif = "";
    if (data.containsKey("collector_bank_rif")) {
      bank_rif = data["collector_bank_rif"];
    }
    String terminal = "";
    if (data.containsKey("device_id")) {
      terminal = data["device_id"];
    }
    String lote = "";
    if (data.containsKey("lot_number")) {
      lote = data["lot_number"];
    }
    String address = "";
    if (data.containsKey("store")) {
      if (data["store"].containsKey("address")) {
        address = data["store"]["address"];
      }
    }
    String card_holder_id = "";
    if (data.containsKey("card_holder_id")) {
      card_holder_id = data["card_holder_id"];
    }
    String rif = "";
    if (data.containsKey("collector_id_doc")) {
      rif = data["collector_id_doc"];
    }
    String timestamp = "";
    String fecha = "";
    String hora = "";

    if (data.containsKey("ist_date") && data.containsKey("ist_time")) {
      if (data["ist_date"].isEmpty || data["ist_time"].isEmpty) {
        if (data.containsKey("timestamp")) {
          if (data["timestamp"] != null) {
            var date = DateTime.parse(data["timestamp"]).toLocal();
            final format = DateFormat(
              'y-MM-dd hh:mm:ss a',
            );
            final format2 = DateFormat(
              'dd/MM/yy',
            );
            final format3 = DateFormat(
              'hh:mm:ss a',
            );
            timestamp = format.format(date);
            fecha = format2.format(date);
            hora = format3.format(date);
          }
        }
      } else {
        //print("este es el ist date ${data["ist_date"].isNotEmpty}");
        //print("este es el ist time ${data["ist_time"].isNotEmpty}");
        var now = DateTime.now();
        var formatter = DateFormat('yyyy');
        var format1 = DateFormat('dd/MM/yy');
        final format2 = DateFormat('hh:mm:ss a');

        String year = formatter.format(now);
        final ist = data["ist_date"];
        final ist2 = data["ist_time"];
        var result =
            "${year}-${ist.substring(0, 2)}-${ist.substring(2, ist.length)} ${ist2.substring(0, 2)}:${ist2.substring(2, 4)}:${ist2.substring(4, ist2.length)}";
        var datetime = DateTime.parse(result);
        var tiempo = 4;
        var subs = (datetime.hour) > 9
            ? (datetime.hour).toString()
            : "0${(datetime.hour).toString()}";
        var result2 =
            "${year}-${ist.substring(0, 2)}-${ist.substring(2, ist.length)} ${subs.toString()}:${ist2.substring(2, 4)}:${ist2.substring(4, ist2.length)}";
        var datetime2 = DateTime.parse(result2);
        datetime2 = datetime2.subtract(Duration(hours: tiempo));
        if (data["payment_card_type"] == "TDD" ||
            data["payment_method_id"] == "DEBITO" &&
                data["status"] == "ANULATED") {
          fecha = format1.format(datetime2);
          hora = format2.format(datetime2);
        } else {
          fecha = format1.format(datetime);
          hora = format2.format(datetime);
        }
      }
    } else {
      if (data.containsKey("timestamp")) {
        if (data["timestamp"] != null) {
          var date = DateTime.parse(data["timestamp"]).toLocal();
          final format = DateFormat(
            'y-MM-dd hh:mm:ss a',
          );
          final format2 = DateFormat(
            'dd/MM/yy',
          );
          final format3 = DateFormat(
            'hh:mm:ss a',
          );
          timestamp = format.format(date);
          fecha = format2.format(date);
          hora = format3.format(date);
        }
      }
    }

    String status_id = "";
    if (data.containsKey("status_id")) {
      if (data["status_id"] != null && data["status_id"] != "null") {
        status_id = (data["status_id"].toString());
        status_id = translate(status_id);
      }
    }

    String card_holder = "";
    String card_name = "";
    String card_mask = "";
    if (data.containsKey("card_holder")) {
      card_holder = data["card_holder"];
    }
    if (data.containsKey("card_name")) {
      card_name = data["card_name"];
    }
    if (data.containsKey("card_holder_number_mask")) {
      card_mask = data["card_holder_number_mask"];
    }
    String affiliation_number = "";
    if (data.containsKey("affiliation_number")) {
      affiliation_number = data["affiliation_number"];
    }
    String lot_number = "";
    if (data.containsKey("lot_number")) {
      lot_number = data["lot_number"];
    }
    String monto = "";
    String amount = "";
    if (data.containsKey("amount")) {
      monto = _formatter.format(data["amount"].toString());
      amount = data["amount"].toString();
    }
    String status = "";
    String type = "";
    if (data.containsKey("status")) {
      status = (data["status"].toString());
      type = status == "ANULATED" || status == "ANULATED_REJECTED"
          ? "ANULACIÓN"
          : "COMPRA";
      status = translate(status);
    }
    String message = "";
    if (data.containsKey("message")) {
      if (data["message"] != null && data["message"] != "null") {
        message = (data["message"].toString());
      }
    }
    String approval = "";
    if (data.containsKey("approval")) {
      if (data["approval"] != null) {
        approval = (data["approval"]);
      }
    }
    String reference = "";
    if (data.containsKey("reference")) {
      if (data["reference"] != null) {
        reference = data["reference"].toString();
      }
    }
    String sequence = "";
    if (data.containsKey("sequence")) {
      sequence = (data["sequence"]);
    }
    String account_type = "";
    if (data.containsKey("account_type")) {
      if (data["account_type"] != null) {
        account_type = (data["account_type"]);
      }
    }
    String payment_method = "";
    if (data.containsKey("payment_method_id")) {
      if (data["payment_method_id"] != null) {
        payment_method = data["payment_method_id"];
      }
    }
    String response_code = "";
    if (data.containsKey("response_code")) {
      response_code = data["response_code"];
    }
    return <String, String>{
      "id": id,
      "name": name,
      "rif": rif,
      "address": address,
      "bank_name": bank_name,
      "bank_rif": bank_rif,
      "terminal": terminal,
      "account_type": account_type,
      "lote": lote,
      "address": address,
      "timestamp": timestamp,
      "fecha": fecha,
      "hora": hora,
      "status_id": status_id,
      "card_holder": card_holder,
      "card_holder_id": card_holder_id,
      "card_name": card_name,
      "card_mask": card_mask,
      "affiliation_number": affiliation_number,
      "lot_number": lot_number,
      "sequence": sequence,
      "monto": monto,
      "amount": amount,
      "approval": approval,
      "reference": reference,
      "status": status,
      "type": type,
      "message": message,
      "payment_method": payment_method,
      "response_code": response_code,
    };
  }

  static simpleReceipt(Map data) {
    print("esta es la data del servicio ${data}");
    final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 2,
    );
    String name = "";
    if (data.containsKey("name")) {
      name = data["name"];
    }
    String address = "";
    if (data.containsKey("address")) {
      address = data["address"];
    }
    String bank_name = "";
    if (data.containsKey("collector_bank_name")) {
      bank_name = data["collector_bank_name"];
    }
    String bank_rif = "";
    if (data.containsKey("collector_bank_rif")) {
      bank_rif = data["collector_bank_rif"];
    }
    String card_name = "";
    if (data.containsKey("card_name")) {
      card_name = data["card_name"];
    }
    String affiliation_number = "";
    String terminal = "";
    String lot_number = "";
    if (data.containsKey("cycles")) {
      if (data["cycles"].length != 0) {
        if (data["cycles"][0].containsKey("affiliation")) {
          affiliation_number = data["cycles"][0]["affiliation"];
        }
        if (data["cycles"][0].containsKey("device_id")) {
          terminal = data["cycles"][0]["device_id"];
          print(
              "este es el terminal cuando se parseaa ${data["cycles"][0]["device_id"]}");
        }
        if (data["cycles"][0].containsKey("lot_number")) {
          lot_number = data["cycles"][0]["lot_number"];
        }
      }
    }
    String time1 = "";
    String time2 = "";
    String time3 = "";
    DateTime mydate = DateTime.now().toLocal();
    print("timeeeeee ${mydate}");
    final format = DateFormat(
      'dd/MM/yy hh:mm:ss a',
    );
    print(format.format(mydate));
    final format2 = DateFormat('dd/MM/yy');
    final format3 = DateFormat('hh:mm:ss a');
    time1 = format.format(mydate);
    time2 = format2.format(mydate);
    time3 = format3.format(mydate);

    String monto = "";
    if (data.containsKey("sum")) {
      if (data["sum"].runtimeType == double || data["sum"].runtimeType == int) {
        data["sum"] = (data["sum"] / 100).toStringAsFixed(2);
      } else {}
      if (data["sum"].runtimeType == String) {
        monto = _formatter.format(data["sum"]);
      } else {
        monto = _formatter.format(data["sum"].toStringAsFixed(2));
      }
    }
    String count = "";
    if (data.containsKey("count")) {
      count = data["count"].toString();
    }
    String monto_success = "";
    String monto_anulate = "";
    double monto_success_int = 0;
    double monto_anulate_int = 0;
    int count_success = 0;
    int count_anulate = 0;

    if (data.containsKey("status_aggregations")) {
      if (data["status_aggregations"].length != 0) {
        for (int i = 0; i < data["status_aggregations"].length; i++) {
          print(data["status_aggregations"][i]);
          if (data["status_aggregations"][i].containsKey("status")) {
            if (data["status_aggregations"][i]["status"] == "APPROVED") {
              if (data["status_aggregations"][i]["sum"].runtimeType == double ||
                  data["status_aggregations"][i]["sum"].runtimeType == int) {
                data["status_aggregations"][i]["sum"] =
                    data["status_aggregations"][i]["sum"] / 100;
              }
              monto_success_int =
                  data["status_aggregations"][i]["sum"].runtimeType is String
                      ? int.parse(data["status_aggregations"][i]["sum"])
                      : data["status_aggregations"][i]["sum"];
              data["status_aggregations"][i]["sum"] =
                  data["status_aggregations"][i]["sum"].toStringAsFixed(2);
              monto_success =
                  _formatter.format(data["status_aggregations"][i]["sum"]);
              count_success = data["status_aggregations"][i]["count"];
            }
            if (data["status_aggregations"][i]["status"] == "ANULATED") {
              if (data["status_aggregations"][i]["sum"].runtimeType == double ||
                  data["status_aggregations"][i]["sum"].runtimeType == int) {
                data["status_aggregations"][i]["sum"] =
                    data["status_aggregations"][i]["sum"] / 100;
              }
              monto_anulate_int =
                  data["status_aggregations"][i]["sum"].runtimeType is String
                      ? int.parse(data["status_aggregations"][i]["sum"])
                      : data["status_aggregations"][i]["sum"];
              data["status_aggregations"][i]["sum"] =
                  data["status_aggregations"][i]["sum"].toStringAsFixed(2);
              monto_anulate =
                  _formatter.format(data["status_aggregations"][i]["sum"]);
              count_anulate = data["status_aggregations"][i]["count"];
            }
          }
        }
      }
    }
    String unformatTotal =
        (monto_success_int - monto_anulate_int).toStringAsFixed(2);
    String total = _formatter.format(unformatTotal);
    var count_total = (count_success - count_anulate);

    return <String, dynamic>{
      "name": name,
      "card_name": card_name,
      "address": address,
      "bank_name": bank_name,
      "bank_rif": bank_rif,
      "affiliation_number": affiliation_number,
      "terminal": terminal,
      "lote": lot_number,
      "timestamp": time1,
      "fecha": time2,
      "hora": time3,
      "monto": monto,
      "total": total,
      "aprobados": monto_success,
      "anulado": monto_anulate,
      "count": count_total,
      "count2": count_success,
      "count3": count_anulate
    };
  }

  static getInformationDevice(data) {
    return data;
  }

  static getInformationDevice2(data) {
    String id = "";
    if (data.containsKey("id")) {
      id = data["id"];
    }
    String name = "";
    if (data.containsKey("bank_name")) {
      name = data["bank_name"];
    }
    String bank_name = "";
    if (data.containsKey("bank_name")) {
      bank_name = data["bank_name"];
    }
    String address = "";
    print(data["store"]);
    if (data.containsKey("store")) {
      if (data["store"].containsKey("address")) {
        address = data["store"]["address"].toString();
      }
    }
    print(address);
    String bank_rif = "";
    if (data.containsKey("bank_rif")) {
      bank_rif = data["bank_rif"];
    }
    String commerce_id_doc = "";
    if (data.containsKey("commerce_id_doc")) {
      commerce_id_doc = data["commerce_id_doc"];
    }
    String commerce_name = "";
    if (data.containsKey("commerce_name")) {
      commerce_name = data["commerce_name"];
    }
    String commerce_email = "";
    if (data.containsKey("commerce_email")) {
      commerce_email = data["commerce_email"];
    }
    Map<String, dynamic> channels = {};
    if (data.containsKey("bank_transactional_payment_channel")) {
      channels = data["bank_transactional_payment_channel"];
    }
    String fecha = "";
    String hora = "";
    if (data.containsKey("info")) {
      if (data["info"].containsKey("created_at")) {
        final dateTime = DateTime.parse(data["info"]["created_at"]);

        final format = DateFormat('DD-MM-yy');
        final format2 = DateFormat('hh:mm:ss a');

        final date = format.format(dateTime);
        final clockString = format2.format(dateTime);

        fecha = date;
        hora = clockString;
      }
    }
    return <String, dynamic>{
      "id": id,
      "name": name,
      "bank_name": bank_name,
      "bank_rif": bank_rif,
      "commerce_id_doc": commerce_id_doc,
      "commerce_name": commerce_name,
      "commerce_email": commerce_email,
      "fecha": fecha,
      "hora": hora,
      "channels": channels,
      "address": address
    };
  }

  static typeChannel(String channel) {
    if (channel != null) {
      switch (channel) {
        case "CHANNEL_7_7":
          return "MC77";
        case "CHANNEL_7_3":
          return "MC73";
        default:
          channel.toString();
      }
    } else {
      return null;
    }
  }

  static formattedClose(data) {
    final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 2,
    );
    // _formatter.format(data["amount"].toString());
    if (data.length != 0) {
      var list = data.map((d) {
        if (d["message"] == null) {
          String affiliation = "";
          String type = translate(d["card_type"]);
          String terminal = "";
          String amount_anulate = "";
          String amount_buy = "";
          String total = "";
          int count_buy = 0;
          int count_anulate = 0;
          int count_total = 0;

          if (d.containsKey("affiliation")) {
            affiliation = d["affiliation"];
          }
          if (d.containsKey("terminal")) {
            terminal = d["terminal"];
          }
          if (d.containsKey("amount_anulate")) {
            var amount = int.parse(d["amount_buy"]);
            var anulated = int.parse(d["amount_anulate"]);
            count_anulate = int.parse(d["count_anulate"]);
            count_buy = int.parse(d["count_buy"]);

            var result = amount + anulated;
            amount_buy = _formatter.format(result.toString());
            amount_anulate = _formatter.format(anulated.toString());
            total = _formatter.format(amount.toString());
            count_total = count_buy + count_anulate;
          } else {
            var amount = int.parse(d["amount_buy"]);
            count_buy = int.parse(d["count_buy"]);
            amount_buy = _formatter.format(amount.toString());
            total = _formatter.format(amount.toString());
            count_total = count_buy;
          }
          return {
            "affiliation": affiliation,
            "type": type,
            "terminal": terminal,
            "amount_anulate": amount_anulate,
            "amount_buy": amount_buy,
            "count_buy": count_total,
            "count_anulate": count_anulate,
            "count_total": count_buy,
            "total": total
          };
        } else {
          String affiliation = "";
          String type = d["card_type"];
          String terminal = "";

          if (d.containsKey("affiliation")) {
            affiliation = d["affiliation"];
          }
          if (d.containsKey("terminal")) {
            terminal = d["terminal"];
          }
          return {
            "affiliation": affiliation,
            "type": type,
            "terminal": terminal,
            "message": "No se pudo realizar el cierre, intente de nuevo"
          };
        }
      }).toList();
      return list;
    }
    return [];
  }

  static formattedOpenLote(List lotes) {
    var list = lotes.map((d) {
      if (d.containsKey("transaction_type")) {
        if (d["transaction_type"] == "CREDITO") {
          String transaction_type = d["transaction_type"];
          String channel_type = "";
          String affiliation = "";
          String cycle_id = "";
          if (d.containsKey("channel_type")) {
            channel_type = d["channel_type"];
          }
          if (d.containsKey("affiliation")) {
            affiliation = d["affiliation"];
          }
          if (d.containsKey("cycle_id")) {
            cycle_id = d["cycle_id"];
          }
          return {
            "transaction_type": transaction_type,
            "channel_type": channel_type,
            "affiliation": affiliation,
            "cycle_id": cycle_id
          };
        }
        if (d["transaction_type"] == "DEBITO") {
          String transaction_type = d["transaction_type"];
          String channel_type = "";
          String affiliation = "";
          String cycle_id = "";
          if (d.containsKey("channel_type")) {
            channel_type = d["channel_type"];
          }
          if (d.containsKey("affiliation")) {
            affiliation = d["affiliation"];
          }
          if (d.containsKey("cycle_id")) {
            cycle_id = d["cycle_id"];
          }
          return {
            "transaction_type": transaction_type,
            "channel_type": channel_type,
            "affiliation": affiliation,
            "cycle_id": cycle_id
          };
        }
      }
      return {};
    }).toList();

    return {"affiliation": list};
  }
}
