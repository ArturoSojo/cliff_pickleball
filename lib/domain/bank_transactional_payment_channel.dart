class BankTransactionalPaymentChannel {
  String? TDC;
  String? TDD;

  BankTransactionalPaymentChannel({this.TDC, this.TDD});

  BankTransactionalPaymentChannel.fromJson(Map<String, dynamic> json) {
    TDC = _formattedChannel(json['TDC']);
    TDD = _formattedChannel(json['TDD']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TDC'] = this.TDC;
    data['TDD'] = this.TDD;
    return data;
  }
  String? _formattedChannel(String? channel){
    switch(channel){
      case "CHANNEL_7_7":
        return "IST77";
      case "CHANNEL_7_3":
        return "IST73";
    }
  }
}