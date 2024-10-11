class Terminals {
  String? DEBIT;
  String? CREDIT;

  Terminals({this.DEBIT, this.CREDIT});

  Terminals.fromJson(Map<String, dynamic> json) {
    DEBIT = json['DEBIT'];
    CREDIT = json['CREDIT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DEBIT'] = this.DEBIT;
    data['CREDIT'] = this.CREDIT;
    return data;
  }
}
