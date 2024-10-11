import 'package:intl/intl.dart';
import 'package:cliff_pickleball/utils/translate.dart';
import 'package:logger/logger.dart';

import '../../../utils/utils.dart';

final _logger = Logger();

class ProductModel {
  bool? cancelable;
  String? realm;
  String? id;
  String? name;
  String? formattedName;
  String? url;
  String? company;
  String? area;
  String? category;
  bool? isCancelable;
  String? status;
  String? serviceCommissionPerTransaction;
  Schedule? schedule;
  Features? features;
  List<String>? channels;
  List<String>? collectChannelCollectMethods;

  ProductModel(
      {this.cancelable,
      this.realm,
      this.id,
      this.name,
      this.formattedName,
      this.url,
      this.company,
      this.area,
      this.category,
      this.isCancelable,
      this.status,
      this.serviceCommissionPerTransaction,
      this.schedule,
      this.features,
      this.channels,
      this.collectChannelCollectMethods});

  ProductModel.fromJson(Map<String, dynamic> json) {
    cancelable = json['cancelable'];
    realm = json['realm'];
    id = json['id'];
    name = json['name'];
    formattedName = translate(json['name'] ?? "");
    url = json['url'];
    company = json['company'];
    area = json['area'];
    category = json['category'];
    isCancelable = json['is_cancelable'];
    status = json['status'];
    serviceCommissionPerTransaction =
        json['service_commission_per_transaction'].toString();
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
    features = json['features'] != null
        ? new Features.fromJson(json['features'])
        : null;
    channels = json['channels'].cast<String>();
    if (json['collect_channel_collect_methods'] != null) {
      collectChannelCollectMethods = [];
      json['collect_channel_collect_methods'].map((v) {
        collectChannelCollectMethods?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancelable'] = this.cancelable;
    data['realm'] = this.realm;
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['company'] = this.company;
    data['area'] = this.area;
    data['category'] = this.category;
    data['is_cancelable'] = this.isCancelable;
    data['status'] = this.status;
    data['service_commission_per_transaction'] =
        this.serviceCommissionPerTransaction;
    if (this.schedule != null) {
      data['schedule'] = this.schedule?.toJson();
    }
    if (this.features != null) {
      data["features"] = this.features;
    }
    data['channels'] = this.channels;
    if (this.collectChannelCollectMethods != null) {
      data['collect_channel_collect_methods'] =
          this.collectChannelCollectMethods?.map((v) => v).toList();
    }
    return data;
  }
}

class Features {
  double? MIN;
  double? MAX;
  double? MULTIPLE;
  String? MIN_FORMAT;
  String? MAX_FORMAT;
  String? MULTIPLE_FORMAT;

  Features({this.MIN, this.MAX, this.MULTIPLE});

  Features.fromJson(Map<String, dynamic> json) {
    final NumberFormat _formatter = NumberFormat.currency(
        locale: "es_VE",
        name: "",
        symbol: "",
        decimalDigits: 2,
        customPattern: "¤#,##0.00;¤-#,##0.00");
    MIN = MyUtils.parseAmountInt(json['MIN']);
    MIN_FORMAT = MIN != null
        ? _formatter.format(double.parse(MIN.toString()))
        : json['MIN'];

    MAX = MyUtils.parseAmountInt(json['MAX']);
    MAX_FORMAT = MAX != null
        ? _formatter.format(double.parse(MAX.toString()))
        : json['MAX'];

    MULTIPLE = MyUtils.parseAmountInt(json['MULTIPLE']);
    MULTIPLE_FORMAT = MULTIPLE != null
        ? _formatter.format(double.parse(MULTIPLE.toString()))
        : json['MULTIPLE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MIN'] = this.MIN;
    data['MAX'] = this.MAX;
    data['MULTIPLE'] = this.MULTIPLE;
    return data;
  }
}

class Schedule {
  String? timeZone;
  WeekSchedule? weekSchedule;

  Schedule({this.timeZone, this.weekSchedule});

  Schedule.fromJson(Map<String, dynamic> json) {
    timeZone = json['time_zone'];
    weekSchedule = json['week_schedule'] != null
        ? new WeekSchedule.fromJson(json['week_schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_zone'] = this.timeZone;
    if (this.weekSchedule != null) {
      data['week_schedule'] = this.weekSchedule?.toJson();
    }
    return data;
  }
}

class WeekSchedule {
  MONDAY? mONDAY;
  MONDAY? tUESDAY;
  MONDAY? wEDNESDAY;
  MONDAY? tHURSDAY;
  MONDAY? fRIDAY;

  WeekSchedule(
      {this.mONDAY, this.tUESDAY, this.wEDNESDAY, this.tHURSDAY, this.fRIDAY});

  WeekSchedule.fromJson(Map<String, dynamic> json) {
    mONDAY =
        json['MONDAY'] != null ? new MONDAY.fromJson(json['MONDAY']) : null;
    tUESDAY =
        json['TUESDAY'] != null ? new MONDAY.fromJson(json['TUESDAY']) : null;
    wEDNESDAY = json['WEDNESDAY'] != null
        ? new MONDAY.fromJson(json['WEDNESDAY'])
        : null;
    tHURSDAY =
        json['THURSDAY'] != null ? new MONDAY.fromJson(json['THURSDAY']) : null;
    fRIDAY =
        json['FRIDAY'] != null ? new MONDAY.fromJson(json['FRIDAY']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mONDAY != null) {
      data['MONDAY'] = this.mONDAY?.toJson();
    }
    if (this.tUESDAY != null) {
      data['TUESDAY'] = this.tUESDAY?.toJson();
    }
    if (this.wEDNESDAY != null) {
      data['WEDNESDAY'] = this.wEDNESDAY?.toJson();
    }
    if (this.tHURSDAY != null) {
      data['THURSDAY'] = this.tHURSDAY?.toJson();
    }
    if (this.fRIDAY != null) {
      data['FRIDAY'] = this.fRIDAY?.toJson();
    }
    return data;
  }
}

class MONDAY {
  String? beginTime;
  String? endTime;

  MONDAY({this.beginTime, this.endTime});

  MONDAY.fromJson(Map<String, dynamic> json) {
    beginTime = json['begin_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['begin_time'] = this.beginTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
