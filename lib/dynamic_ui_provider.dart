
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicUIProvider with ChangeNotifier {
  Map<String, dynamic> _uiData = {};

  Map<String, dynamic> get uiData => _uiData;

  Future<void> loadConfig(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      _uiData = json.decode(jsonString);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading config: $e");
    }
  }

}