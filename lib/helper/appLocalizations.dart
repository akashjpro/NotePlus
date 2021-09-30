import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations({required this.locale});

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  // Load file json vào bộ nhớ
  Future<bool> load() async {
    // Đọc file json dưới dạng chuỗi
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    // Giải mã file json sang Map
    print('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    // Sau đó dùng hàm map() để đưa Map<String, dynamic> về Map<String, String>
    // và gán cho biến _localizedStrings
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    // Đoạn này cũng không cần thiết phải trả về giá trị nào
    // Bạn có thể để Future không cũng được và không cần return
    return true;
  }

  // Đoạn này đơn giản chỉ là lấy giá trị đang
  // được lưu tại cái key được truyền vào
  String? translate(String key) {
    return _localizedStrings![key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Gọi hàm load json được định nghĩa trong class bên trên
    AppLocalizations localizations = new AppLocalizations(locale: locale);
    // Đợi load xong mới return về giá trị
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
