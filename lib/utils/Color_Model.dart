class ColorModel {
  String? idDoc;
  String? name;
  Colors? colors;
  AssetsImg? assetsImg;

  ColorModel({this.idDoc, this.colors, this.assetsImg, this.name});

  ColorModel.fromJson(Map<String, dynamic> json) {
    idDoc = json['idDoc'];
    name = json['name'];
    colors =
    json['colors'] != null ? new Colors.fromJson(json['colors']) : null;
    assetsImg = json['assets_img'] != null
        ? new AssetsImg.fromJson(json['assets_img'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDoc'] = this.idDoc;
    data['name'] = this.name;
    if (this.colors != null) {
      data['colors'] = this.colors!.toJson();
    }
    if (this.assetsImg != null) {
      data['assets_img'] = this.assetsImg!.toJson();
    }
    return data;
  }
}

class Colors {
  String? primary;
  String? primaryLight;

  Colors({this.primary, this.primaryLight});

  Colors.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    primaryLight = json['primary_light'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary'] = this.primary;
    data['primary_light'] = this.primaryLight;
    return data;
  }
}

class AssetsImg {
  String? uri;
  String? logo;
  String? logo2;
  String? logo3;
  String? closed;
  String? details;
  String? last;
  String? pos;
  String? report;
  String? sales;
  String? simple;
  String? test;
  String? transactions;

  AssetsImg(
      {this.uri,
        this.logo,
        this.logo2,
        this.logo3,
        this.closed,
        this.details,
        this.last,
        this.pos,
        this.report,
        this.sales,
        this.simple,
        this.test,
        this.transactions});

  AssetsImg.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    logo = json['logo'];
    logo2 = json['logo2'];
    logo3 = json['logo3'];
    closed = json['closed'];
    details = json['details'];
    last = json['last'];
    pos = json['pos'];
    report = json['report'];
    sales = json['sales'];
    simple = json['simple'];
    test = json['test'];
    transactions = json['transactions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['logo'] = this.logo;
    data['logo2'] = this.logo2;
    data['logo3'] = this.logo3;
    data['closed'] = this.closed;
    data['details'] = this.details;
    data['last'] = this.last;
    data['pos'] = this.pos;
    data['report'] = this.report;
    data['sales'] = this.sales;
    data['simple'] = this.simple;
    data['test'] = this.test;
    data['transactions'] = this.transactions;
    return data;
  }
}
