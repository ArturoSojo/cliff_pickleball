import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class Roles{
  List<Role>? roles;

  Roles({this.roles});

  Roles.fromJson(Map<String, dynamic> json) {
    if(json["roles"]!=null){
      roles = [];
      json['roles'].forEach((v) {
        roles?.add(new Role.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = {};
    if (this.roles != null) {
      json['roles'] = this.roles?.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Role {
  String? realm;
  String? businessId;
  String? userId;
  String? appName;
  String? appStatus;
  String? appUrl;
  String? appIcon;
  String? scopeName;
  String? scopeId;
  String? name;
  String? ownerName;
  String? ownerEmail;
  String? userName;
  String? userEmail;
  bool? thirdPartyAuthorization;
  List<Views>? views;
  List<String>? scopes;


  Role(
    {this.realm,
      this.businessId,
      this.userId,
      this.appName,
      this.appStatus,
      this.appUrl,
      this.appIcon,
      this.scopeName,
      this.scopeId,
      this.name,
      this.ownerName,
      this.ownerEmail,
      this.userName,
      this.userEmail,
      this.thirdPartyAuthorization,
      this.views,
      this.scopes});

Role.fromJson(Map<String, dynamic> json) {
realm = json['realm'];
businessId = json['business_id'];
userId = json['user_id'];
appName = json['app_name'];
appStatus = json['app_status'];
appUrl = json['app_url'];
appIcon = json['app_icon'];
scopeName = json['scope_name'];
scopeId = json['scope_id'];
name = json['name'];
ownerName = json['owner_name'];
ownerEmail = json['owner_email'];
userName = json['user_name'];
userEmail = json['user_email'];
thirdPartyAuthorization = json['third_party_authorization'];
if (json['views'] != null) {
  views = [];
  json['views'].map((v) {
    views?.add(Views.fromJson(v));
  });
}
if (json['scopes'] != null) {
  scopes = [];
  json['scopes'].map((v) {
    scopes?.add(v);
  });
}
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['realm'] = this.realm;
  data['business_id'] = this.businessId;
  data['user_id'] = this.userId;
  data['app_name'] = this.appName;
  data['app_status'] = this.appStatus;
  data['app_url'] = this.appUrl;
  data['app_icon'] = this.appIcon;
  data['scope_name'] = this.scopeName;
  data['scope_id'] = this.scopeId;
  data['name'] = this.name;
  data['owner_name'] = this.ownerName;
  data['owner_email'] = this.ownerEmail;
  data['user_name'] = this.userName;
  data['user_email'] = this.userEmail;
  data['third_party_authorization'] = this.thirdPartyAuthorization;
  if (this.views != null) {
    data['views'] = this.views?.map((v) => v.toJson()).toList();
  }
  if (this.scopes != null) {
    data['scopes'] = this.scopes?.map((v) => v).toList();
  }
  return data;
}
}
class Actions {
  String? name;
  int? sort;
  String? functionalityDetail;
  String? type;
  String? status;
  String? functionName;
  List<String>? scopes;

  Actions(
      {this.name,
        this.sort,
        this.functionalityDetail,
        this.type,
        this.status,
        this.functionName,
        this.scopes});

  Actions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sort = json['sort'];
    functionalityDetail = json['functionality_detail'];
    type = json['type'];
    status = json['status'];
    functionName = json['function_name'];
    if (json['scopes'] != null) {
      scopes = [];
      json['scopes'].map((v) {
        scopes?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['functionality_detail'] = this.functionalityDetail;
    data['type'] = this.type;
    data['status'] = this.status;
    data['function_name'] = this.functionName;
    if (this.scopes != null) {
      data['scopes'] = this.scopes?.map((v) => v).toList();
    }
    return data;
  }
}
class Views {
  String? name;
  String? functionality;
  String? url;
  String? type;
  String? tag;
  int? sort;
  List<Actions>? actions;

  Views(
      {this.name,
        this.functionality,
        this.url,
        this.type,
        this.tag,
        this.sort,
        this.actions});

  Views.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    functionality = json['functionality'];
    url = json['url'];
    type = json['type'];
    tag = json['tag'];
    sort = json['sort'];
    if (json['actions'] != null) {
      actions = [];
      json['actions'].map((v) {
        actions?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['functionality'] = this.functionality;
    data['url'] = this.url;
    data['type'] = this.type;
    data['tag'] = this.tag;
    data['sort'] = this.sort;
    if (this.actions != null) {
      data['actions'] = this.actions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}