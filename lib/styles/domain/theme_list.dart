import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_theme.dart';

part 'theme_list.freezed.dart';
part 'theme_list.g.dart';

@freezed
class ThemeList with _$ThemeList {
  const factory ThemeList({
    required List<AppTheme> list,
  }) = _ThemeList;

  factory ThemeList.fromJson(Map<String, dynamic> json) =>
      _$ThemeListFromJson(json);

  static List<AppTheme> listFromJson(String json) {
    return jsonList(jsonDecode(json));
  }

  static List<AppTheme> jsonList(List<dynamic> json) {
    return ThemeList.fromJson({'list': json}).list;
  }
}
