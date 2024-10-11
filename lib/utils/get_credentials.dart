import 'dart:convert';

import 'package:cliff_pickleball/services/cacheService.dart';

final Cache cache = Cache();

getToken() async {
  var res = await cache.getCacheData("access");
  if (res != null) {
    var result = json.decode(res);
    var res2 = json.decode(result) as Map<String, dynamic>;
    if (res2.containsKey("access_token")) {
      return res2["access_token"];
    } else {
      return null;
    }
  }
}

getSessionTime() async {
  var res = await cache.getCacheData("access");
  if (res != null) {
    var result = json.decode(res);
    var res2 = json.decode(result) as Map<String, dynamic>;
    if (res2.containsKey("expires_in")) {
      return res2["expires_in"];
    } else {
      return null;
    }
  }
}

getProfile() async {
  var res = await cache.getCacheData("profile");
  if (res != null) {
    var result = json.decode(res);
    var res2 = json.decode(result) as Map<String, dynamic>;
    if (res2.containsKey("email")) {
      return <String, String>{
        "user_id": res2["user_id"],
        "user_email": res2["email"],
        "business_id": res2["id"],
        "realm": res2["realm"]
      };
    } else {
      return null;
    }
  }
}
