import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

import '../../../utils/translate.dart';

class LastReportModel{
  String? id;
  String? name;
  String? code;
  String? rif;
  String? address;
  String? bank_name;
  String? bank_rif;
  String? terminal;
  String? account_type;
  String? lote;
  String? timestamp;
  String? fecha;
  String? hora;
  String? status_id;
  String? card_holder;
  String? card_holder_id;
  String? card_name;
  String? card_mask;
  String? affiliation_number;
  String? lot_number;
  String? sequence;
  String? monto;
  String? amount;
  String? approval;
  String? reference;
  String? status;
  String? type;
  String? message;
  String? payment_method;

  LastReportModel({
    this.id,
    this.name,
    this.code,
    this.rif,
    this.address,
    this.bank_name,
    this.bank_rif,
    this.terminal,
    this.account_type,
    this.lote,
    this.timestamp,
    this.fecha,
    this.hora,
    this.status_id,
    this.card_holder,
    this.card_holder_id,
    this.card_name,
    this.card_mask,
    this.affiliation_number,
    this.lot_number,
    this.sequence,
    this.monto,
    this.amount,
    this.approval,
    this.reference,
    this.status,
    this.type,
    this.message,
    this.payment_method,
  });
  LastReportModel.fromJson(Map<String, dynamic> json){
    final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
      symbol: "Bs. ",
      decimalDigits: 2,
    );

    if (json.containsKey("order_number")) {
      id = json["order_number"];
    }
    if (json.containsKey("collector_name")) {
      name = json["collector_name"];
    }
    if (json.containsKey("collector_bank_name")) {
      bank_name = json["collector_bank_name"];
    }
    if (json.containsKey("collector_bank_rif")) {
      bank_rif = json["collector_bank_rif"];
    }
    if (json.containsKey("device_id")) {
      terminal = json["device_id"];
    }
    if (json.containsKey("lot_number")) {
      lote = json["lot_number"];
    }
    if (json.containsKey("store")) {
      if (json["store"].containsKey("address")) {
        address = json["store"]["address"];
      }
    }
    if (json.containsKey("card_holder_id")) {
      card_holder_id = json["card_holder_id"];
    }
    if (json.containsKey("collector_id_doc")) {
      rif = json["collector_id_doc"];
    }
    if (json.containsKey("ist_date") && json.containsKey("ist_time")) {
      if (json["ist_date"].isEmpty || json["ist_time"].isEmpty) {
        print("esasdas dasdasd asdsadsadsadsa");
        if (json.containsKey("timestamp")) {
          if (json["timestamp"] != null) {
            var date = DateTime.parse(json["timestamp"]).toLocal();
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
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy');
        var format1 = new DateFormat('dd/MM/yy');
        final format2 = DateFormat('hh:mm:ss a');

        String year = formatter.format(now);
        final ist = json["ist_date"];
        final ist2 = json["ist_time"];
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

        if ((json["payment_card_type"] == "TDD" ||
            json["payment_method_id"] == "DEBITO") &&
            json["status"] == "ANULATED" && json["channel_type"] == "MC73") {
          fecha = format1.format(datetime2);
          hora = format2.format(datetime2);
        } else {
          fecha = format1.format(datetime);
          hora = format2.format(datetime);
        }
      }
    } else {
      if (json.containsKey("timestamp")) {
        if (json["timestamp"] != null) {
          var date = DateTime.parse(json["timestamp"]).toLocal();
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

    if (json.containsKey("status_id")) {
      if (json["status_id"] != null && json["status_id"] != "null") {
        status_id = translate(json["status_id"]);
      }
    }

    if (json.containsKey("card_holder")) {
      card_holder = json["card_holder"];
    }
    if (json.containsKey("card_name")) {
      card_name = json["card_name"];
    }
    if (json.containsKey("card_holder_number_mask")) {
      card_mask = json["card_holder_number_mask"];
    }
    if (json.containsKey("affiliation_number")) {
      affiliation_number = json["affiliation_number"];
    }
    if (json.containsKey("lot_number")) {
      lot_number = json["lot_number"];
    }
    if (json.containsKey("amount")) {
      monto = _formatter.format(json["amount"].toString());
      amount = json["amount"].toString();
    }
    if (json.containsKey("status")) {
      if(json["status"]!=null){
        type = status == "ANULATED" ? "ANULACIÓN" : "COMPRA";
        status = translate(json["status"]);
      }
    }
    if (json.containsKey("message")) {
      if (json["message"] != null && json["message"] != "null") {
        message = (json["message"].toString());
      }
    }
    if (json.containsKey("approval")) {
      if (json["approval"] != null) {
        approval = (json["approval"]);
      }
    }
    if (json.containsKey("reference")) {
      if (json["reference"] != null) {
        reference = json["reference"].toString();
      }
    }
    if (json.containsKey("sequence")) {
      sequence = (json["sequence"]);
    }
    if (json.containsKey("account_type")) {
      account_type = (json["account_type"]);
    }
    if (json.containsKey("payment_method_id")) {
      if (json["payment_method_id"] != null) {
        payment_method = json["payment_method_id"];
      }
    }
    if (json.containsKey("code") || json.containsKey("response_code")) {
      if (json["code"] != null || json["response_code"] != null) {
        code = json["code"] ?? json["response_code"];
      }
    }
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = Map<String, dynamic>();
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["rif"] = rif;
    json["address"] = address;
    json["bank_name"] = bank_name;
    json["bank_rif"] = bank_rif;
    json["terminal"] = terminal;
    json["account_type"] = account_type;
    json["lote"] = lote;
    json["address"] = address;
    json["timestamp"] = timestamp;
    json["fecha"] = fecha;
    json["hora"] = hora;
    json["status_id"] = status_id;
    json["card_holder"] = card_holder;
    json["card_holder_id"] = card_holder_id;
    json["card_name"] = card_name;
    json["card_mask"] = card_mask;
    json["affiliation_number"] = affiliation_number;
    json["lot_number"] = lot_number;
    json["sequence"] = sequence;
    json["monto"] = monto;
    json["amount"] = amount;
    json["approval"] = approval;
    json["reference"] = reference;
    json["status"] = status;
    json["type"] = type;
    json["message"] = message;
    json["payment_method"] = payment_method;
    return json;
  }
}