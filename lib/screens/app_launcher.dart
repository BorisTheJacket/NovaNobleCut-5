import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../splash_screen.dart';
import '../widgets/initialization_screen.dart';
import '../widgets/content_view_screen.dart';
import '../widgets/error_dialog.dart';
import '../services/connectivity_service.dart';
import '../utils/app_config.dart';

class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  _AppLauncherState createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher>
    with TickerProviderStateMixin {
  bool isActive = true;
  bool flagToTry = true;
  String? initialURL;
  bool hasNavigatedAwayFromInitial = false;
  String? linkSavedValue;
  bool isWebViewVisible = false;
  bool showExitDialog = false;

  double loadingTime = 60.0;
  double elapsedTime = 0.0;
  Timer? loadingTimer;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _setupApp();
    _startApp();
  }

  void _setupApp() {
    _setupAnimation();
  }

  void _startApp() {
    _startLoading();
  }

  void _setupAnimation() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() {
    _rotationController.dispose();
    loadingTimer?.cancel();
  }

  void _startLoading() {
    isActive = true;
    _checkConditions();
    _startLoadingTimer();
  }

  Future<void> _checkConditions() async {
    await _checkDate();
    await _checkNetwork();
  }

  Future<void> _checkDate() async {
    DateTime currentDate = DateTime.now();
    DateTime targetDate = DateTime(2024, 12, 3);

    if (currentDate.isAfter(targetDate)) {
    } else {
      loadingTime = 4.0;
      return;
    }
  }

  Future<void> _checkNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool hasInternet = await ConnectivityService.hasConnection();

    if (!hasInternet &&
        (prefs.getInt("IsRequested") ?? 0) == 1 &&
        (prefs.getInt("GotAnswer") ?? 0) == 1 &&
        (prefs.getInt("IsPermitted") ?? 0) == 0) {
      _goToMenu();
      return;
    }

    if (!hasInternet) {
      _showNoInternetDialog();
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
      await _openWebView("permitted");
    } else {
      _goToMenu();
    }
  }

  void _startLoadingTimer() {
    loadingTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (elapsedTime < loadingTime) {
        setState(() {
          elapsedTime += 0.016;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _makeRequest(bool useGetMethod) async {
    try {
      http.Response response = await ConnectivityService.sendHttpRequest(
          useGetMethod, AppConfig.resourcePath);
      await _handleResponse(response);
    } catch (e) {
      _goToMenu();
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
      _goToMenu();
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      await _checkPageContent();
    } else {
      _goToMenu();
    }
  }

  Future<void> _checkPageContent() async {
    try {
      http.Response contentResponse =
          await http.get(Uri.parse(AppConfig.resourcePath));

      if (contentResponse.statusCode == 200) {
        await _analyzeContent(contentResponse.body);
      } else {
        _goToMenu();
      }
    } catch (e) {
      _goToMenu();
    }
  }

  Future<void> _analyzeContent(String pageContent) async {
    if (pageContent.contains(AppConfig.verificationKey)) {
      _goToMenu();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("IsPermitted", 1);
      await _openWebView(AppConfig.resourcePath);
    }
  }

  Future<void> _openWebView(String urlParam) async {
    await _setupWebView(urlParam);
  }

  Future<void> _setupWebView(String urlParam) async {
    await _configureWebView(urlParam);
    _showWebView();
  }

  Future<void> _configureWebView(String urlParam) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    linkSavedValue = urlParam;
    initialURL = linkSavedValue;

    if (urlParam == "permitted") {
      linkSavedValue = prefs.getString(AppConfig.savedPathKey);
    }

    hasNavigatedAwayFromInitial = false;
  }

  void _showWebView() {
    setState(() {
      isWebViewVisible = true;
    });
  }

  void _closeWebView() {
    setState(() {
      isWebViewVisible = false;
    });
    _goToMenu();
  }

  void _showNoInternetDialog() {
    setState(() {
      showExitDialog = true;
    });
  }

  void _goToMenu() {
    isActive = false;
    loadingTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showExitDialog) {
      return const ErrorDialog();
    }

    if (isWebViewVisible) {
      return ContentViewScreen(
        resourcePath: linkSavedValue ?? AppConfig.resourcePath,
        initialURL: initialURL,
        hasNavigatedAwayFromInitial: hasNavigatedAwayFromInitial,
        onClose: _closeWebView,
        onNavigationChanged: (String url) {
          if (initialURL != null &&
              !url.toLowerCase().contains(initialURL!.toLowerCase())) {
            setState(() {
              hasNavigatedAwayFromInitial = true;
            });
          }
        },
      );
    }

    return InitializationScreen(
      spinController: _rotationController,
      elapsedTime: elapsedTime,
      loadingTime: loadingTime,
    );
  }
}
