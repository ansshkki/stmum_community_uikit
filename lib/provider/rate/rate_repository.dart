import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class RateRepository {
  final SharedPreferences sharedPreferences;

  RateRepository({
    required this.sharedPreferences,
  });

  Future<bool> reviewRequest(String route) async {
    final InAppReview inAppReview = InAppReview.instance;
    try {
      if (checkRateDate(route) && await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        setRateCallNum();
        setLastRateDate(DateTime.now());
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool checkRateDate(String route) {
    /// result : if it appear last time in this route
    final result = getRouteRequestRate()[route];
    if (result!) {
      return false;
    }
    final repeat = getRateCallNum();
    final date = getLastRateDate();
    final dayDiff = DateTime.now().difference(date).inDays;
    final monthDiff = DateTime.now().month - date.month;
    if (repeat == 2 && monthDiff >= 1) {
      setRateCallNum(reset: true);
      return true;
    }
    if ((repeat == 1 && dayDiff < 7) || (repeat == 2 && monthDiff == 0)) {
      return false;
    }
    return true;
  }

  /// DATA SOURCE
  DateTime getLastRateDate() {
    /// get last date as String
    final output = sharedPreferences.getString("rate_date");

    /// convert string to date time
    if (output == null) {
      return DateTime.now();
    }
    return DateTime.parse(output);
  }

  void setLastRateDate(rateDate) async {
    await sharedPreferences.setString(
      "rate_date",
      rateDate.toIso8601String(),
    );
  }

  int getRateCallNum() {
    final output = sharedPreferences.getInt("rate_call_number");
    if (output == null) {
      return 0;
    }
    return output;
  }

  Future<void> setRateCallNum({bool? reset}) async {
    final value = reset ?? false ? 0 : getRateCallNum() + 1;
    await sharedPreferences.setInt("rate_call_number", value);
  }

  Map<String, bool> getRouteRequestRate() {
    try {
      /// get map <String route,bool Value>
      var map = sharedPreferences.getString("rate_request_rout");
      if (map == null) {
        throw Exception();
      }

      /// when all map has visited
      if (map.contains("false")) {
        throw Exception();
      }

      /// return all map
      return json.decode(map);
    } catch (e) {
      /// when there are no value OR when there checked.. so we init it
      return {
        "growth": false,
        "Pregnancy": false,
        "articles": false,
        "community": false,
        "ai": false,
      };
    }
  }

  Future<void> setRouteRequestRate(route) async {
    /// get last value
    Map<String, bool> map = getRouteRequestRate();

    /// set this route as visited
    map[route] = true;

    /// set last value
    await sharedPreferences.setString(
      "rate_request_rout",
      json.encode(map),
    );
  }
}
