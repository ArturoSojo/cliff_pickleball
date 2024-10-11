String decode(String tlv) {
  int position = tlv.indexOf("4F");
  int count = position + 1;
  List t = tlv.split("");
  if (t[position + 1] == "0") {
    count = int.parse(t[position + 3]) * 3 - 3;
  } else {
    count = int.parse(t[position + 2] + t[position + 3]) * 3 - 3;
  }
  String result = tlv.substring(position + 4, position + count);
  return result;
}
