import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:optional/optional.dart';

part 'tlv_comparator.g.dart';

final List<AidInfo> values = [
  AidInfo("A0000000041010", "MasterCard Credit", "TDC"),
  AidInfo("A0000000042010", "MasterCard Spec 1", "TDC"),
  AidInfo("A0000000043010", "MasterCard Spec 2", "TDC"),
  AidInfo("A0000000044010", "MasterCard Spec 3", "TDC"),
  AidInfo("A0000000045010", "MasterCard Spec 4", "TDC"),
  AidInfo("D86200010820B0", "Nacional Credit", "TDC"),
  AidInfo("A0000000031010", "Visa Credit", "TDC"),
  AidInfo("A0000000033010", "Visa Interlink", "TDC"),
  AidInfo("A0000000034010", "Visa Especific 1", "TDC"),
  AidInfo("A0000000035010", "Visa Especific 2", "TDC"),
  AidInfo("A0000000043060", "Maestro", "TDD"),
  AidInfo("D86200010810B0", "Nacional débito", "TDD"),
  AidInfo("A0000000032010", "Electron Visa", "TDC"),
  AidInfo("A00000002501", "AMEX", "TDC"),
  AidInfo("A000000003", "Visa", "TDC"),
  AidInfo("A0000000038010", "Visa Plus", "TDC"),
  AidInfo("A0000006581010", "MIR", "TDD")
];

@injectable
class TlvComparator {
  final _logger = Logger();

  AidInfo? aidInfo(String tlv) {
    var decoder = TlvDecoder();
    decoder.parseTLV(tlv);
    var map = decoder.toMap();

    print("TLV_TAGS ${jsonEncode(map)}");

    var aid = map["4F"]?.val;

    if (aid != null) {
      return getAidInfo(aid);
    }

    return null;
  }

  AidInfo? getAidInfo(String aid) {
    if (aid.isNotEmpty) {
      return values.where((c) => c.aid == aid).firstOptional.orElseNull;
    }

    return null;
  }
}

class AidInfo {
  String aid;
  String name;
  String type;

  AidInfo(this.aid, this.name, this.type);
}

class TlvDecoder {
  static int CONST_IDTAG = 31;
  static int CONST_PC = 32;
  static int CONST_LEN = 128;
  List<TLVObject> tlv = [];

  Map<String, TLVObject> toMap() {
    Map<String, TLVObject> map = {};
    for (var element in tlv) {
      map.putIfAbsent(element.tag, () => element);
    }

    return Map.fromEntries(
        map.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }

  String removeWhiteSpaces(String str) {
    return str.replaceAll(" ", "");
  }

  void parseTLV(String sequence) {
    tlv = [];
    sequence = removeWhiteSpaces(sequence);
    while (sequence != "") {
      var obj = getTLV(sequence);
      sequence = sequence.substring(obj.getTotalSequence());
      tlv.add(obj);
    }
    for (var i = 0; i < tlv.length; i++) {
      tlv[i].computeChildren(this);
    }
  }

  TLVObject getTLV(String sequence) {
    var tmp = TLVObject();
    var tag = getTag(sequence);
    sequence = sequence.substring(tag.length);
    var len = getLen(sequence);
    sequence = sequence.substring(len.length);
    tmp.len = len;
    tmp.tag = tag;
    var totalLen = getTotalLen(len);
    if (sequence.length < totalLen) {
      tmp.val = sequence;
    } else {
      tmp.val = sequence.substring(0, totalLen);
    }

    return tmp;
  }

  String getTag(String sequence) {
    var tag = sequence[0] + sequence[1];
// int.parse
    if ((int.parse(tag, radix: 16) & CONST_IDTAG) == CONST_IDTAG) {
      tag += sequence[2] + sequence[3];
    }
    return tag;
  }

  String getLen(String sequence) {
    String len = sequence[0] + sequence[1];
    var lenBytes = 1;
    if ((int.parse(len, radix: 16) & CONST_LEN) == CONST_LEN) {
      lenBytes = int.parse(len[1], radix: 16) * 2;
    }
    if (lenBytes > 1) {
      for (var i = 2; i <= lenBytes; i += 2) {
        len += sequence[i] + sequence[i + 1];
      }
    }

    return len;
  }

  int getTotalLen(String len) {
    if (len.length > 2) {
      len = len.substring(2);
      return int.parse(len, radix: 16) * 2;
    } else {
      return int.parse(len, radix: 16) * 2;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TLVObject {
  late String tag;
  late String len;
  late String val;

  TLVObject();

  factory TLVObject.fromJson(Map<String, dynamic> json) =>
      _$TLVObjectFromJson(json);

  Map<String, dynamic> toJson() => _$TLVObjectToJson(this);

  int getTotalSequence() {
    return (tag + len + val).length;
  }

  isConstructed() {
    return (int.parse(tag.substring(0, 2), radix: 16) & TlvDecoder.CONST_PC) ==
        TlvDecoder.CONST_PC;
  }

  computeChildren(TlvDecoder decoder) {
    if (isConstructed()) {
      var list = parse(decoder, val);
      for (var i = 0; i < list.length; i++) {
        list[i].computeChildren(decoder);
      }
    }
  }

  List<TLVObject> parse(TlvDecoder decoder, String sequence) {
    List<TLVObject> tmpArray = [];
    while (sequence != "") {
      var tlv = decoder.getTLV(sequence);
      sequence = sequence.substring(tlv.getTotalSequence());
      tmpArray.add(tlv);
    }
    return tmpArray;
  }

  @override
  String toString() {
    return 'TLVObject{tag: $tag, len: $len, val: $val}';
  }
}
