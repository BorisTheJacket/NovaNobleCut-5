import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static const String _appId = '6a3dc39d-3185-4267-b985-6990e32a83bf';

  bool _isInitialized = false;

  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Simple logger helper
  void _log(String message) => debugPrint('[NotificationService] $message');

  // Generic error-safe wrapper
  Future<T?> _safeCall<T>(String action, Future<T?> Function() fn) async {
    try {
      return await fn();
    } catch (e, st) {
      _log('Error during $action: $e');
      if (kDebugMode) {
        _log('$st');
      }
      return null;
    }
  }

  Future<void> initialize([String userId = '']) async {
    if (_isInitialized) return;

    try {
      if (kDebugMode) {
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }

      OneSignal.initialize(_appId);

      await _safeCall('setExternalUserId', () async {
        await _setExternalUserId(userId);
        return null;
      });

      await _safeCall('requestPermissions', () async {
        await _requestPermissions();
        return null;
      });

      _setupHandlers();
      _isInitialized = true;

      _log('Initialized successfully');
    } catch (e) {
      _log('Error initializing: $e');
    }
  }

  Future<void> _setExternalUserId(String userId) async {
    if (userId.isEmpty) return;
    try {
      await OneSignal.login(userId);
      _log('External user ID set: $userId');
    } catch (e) {
      _log('Error setting external user ID: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      await OneSignal.Notifications.requestPermission(true);
      _log('Requested notification permission');
    } catch (e) {
      _log('Error requesting permissions: $e');
    }
  }

  void _setupHandlers() {
    _setForegroundHandler();
    _setNotificationClickHandler();
    _setInAppMessageHandler();
  }

  void _setForegroundHandler() {
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = event.notification;
      _log('Notification received in foreground: ${notification.title}');
    });
  }

  void _setNotificationClickHandler() {
    OneSignal.Notifications.addClickListener((event) {
      _log('Notification clicked');
    });
  }

  void _setInAppMessageHandler() {
    OneSignal.InAppMessages.addClickListener((event) {
      _log('In-app message clicked');
    });
  }

  bool _checkInitialization(String action) {
    if (!_isInitialized) {
      _log('Warning: not initialized when calling $action');
      return false;
    }
    return true;
  }

  Future<void> setTag(String key, String value) async {
    if (!_checkInitialization('setTag')) return;
    await _safeCall('setTag', () async {
      await OneSignal.User.addTags({key: value});
      _log('Tag set: $key = $value');
      return null;
    });
  }

  Future<void> removeTag(String key) async {
    if (!_checkInitialization('removeTag')) return;
    await _safeCall('removeTag', () async {
      await OneSignal.User.removeTag(key);
      _log('Tag removed: $key');
      return null;
    });
  }

  Future<void> setTags(Map<String, String> tags) async {
    if (!_checkInitialization('setTags')) return;
    await _safeCall('setTags', () async {
      await OneSignal.User.addTags(tags);
      _log('Multiple tags set: ${tags.keys.join(', ')}');
      return null;
    });
  }

  Future<String?> getPushToken() async {
    if (!_checkInitialization('getPushToken')) return null;
    return await _safeCall<String?>('getPushToken', () async {
      final pushSubscription = OneSignal.User.pushSubscription;
      final deviceId = pushSubscription.id;
      _log('Push Token (Device ID): $deviceId');
      return deviceId;
    });
  }

  Future<bool> hasPermission() async {
    final result = await _safeCall<bool>('hasPermission', () async {
      final permission = OneSignal.Notifications.permission;
      return permission;
    });
    return result ?? false;
  }

  Future<void> logout() async {
    if (!_isInitialized) return;
    await _safeCall('logout', () async {
      await OneSignal.logout();
      _isInitialized = false;
      _log('Logged out from notifications');
      return null;
    });
  }

  void dispose() {
    _isInitialized = false;
  }
}
