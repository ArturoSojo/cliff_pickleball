class QposIdModel {
  String? tmk0Status;
  String? macAddress;
  String? tmk2Status;
  String? tmk4Status;
  String? posId;
  String? tmk1Status;
  String? csn;
  String? tmk3Status;
  bool? isKeyboard;
  String? nfcID;
  String? psamId;

  QposIdModel(
      {this.tmk0Status,
        this.macAddress,
        this.tmk2Status,
        this.tmk4Status,
        this.posId,
        this.tmk1Status,
        this.csn,
        this.tmk3Status,
        this.isKeyboard,
        this.nfcID,
        this.psamId});

  QposIdModel.fromJson(Map<String, dynamic> json) {
    tmk0Status = json['tmk0Status'];
    macAddress = json['macAddress'];
    tmk2Status = json['tmk2Status'];
    tmk4Status = json['tmk4Status'];
    posId = json['posId'];
    tmk1Status = json['tmk1Status'];
    csn = json['csn'];
    tmk3Status = json['tmk3Status'];
    isKeyboard = json['isKeyboard'];
    nfcID = json['nfcID'];
    psamId = json['psamId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tmk0Status'] = this.tmk0Status;
    data['macAddress'] = this.macAddress;
    data['tmk2Status'] = this.tmk2Status;
    data['tmk4Status'] = this.tmk4Status;
    data['posId'] = this.posId;
    data['tmk1Status'] = this.tmk1Status;
    data['csn'] = this.csn;
    data['tmk3Status'] = this.tmk3Status;
    data['isKeyboard'] = this.isKeyboard;
    data['nfcID'] = this.nfcID;
    data['psamId'] = this.psamId;
    return data;
  }
}
