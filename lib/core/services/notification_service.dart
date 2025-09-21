import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.deleteNotificationChannel('transaction_success_channel');
      await androidPlugin.deleteNotificationChannel('success_channel');
      await androidPlugin.deleteNotificationChannel('error_channel');
      await androidPlugin.deleteNotificationChannel('info_channel');
      
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'clean_transaction_channel',
          'Notifikasi Transaksi Bersih',
          description: 'Saluran untuk notifikasi transaksi bersih tanpa pengaruh warna',
          importance: Importance.high,
        ),
      );
      
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'clean_success_channel',
          'Notifikasi Sukses Bersih',
          description: 'Saluran untuk notifikasi sukses bersih tanpa pengaruh warna',
          importance: Importance.high,
        ),
      );
      
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'clean_error_channel',
          'Notifikasi Error Bersih',
          description: 'Saluran untuk notifikasi error bersih tanpa pengaruh warna',
          importance: Importance.high,
        ),
      );
      
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'clean_info_channel',
          'Notifikasi Info Bersih',
          description: 'Saluran untuk notifikasi info bersih tanpa pengaruh warna',
          importance: Importance.none,
        ),
      );
      
      final granted = await androidPlugin.requestNotificationsPermission();
      debugPrint('[NotificationService] Android notification permission granted: $granted');
    }
    
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[NotificationService] iOS notification permission granted: $granted');
    }
        
    debugPrint('[NotificationService] Initialized successfully with clean channels');
  }

  Future<void> showSuccessNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('[NotificationService] Showing success notification: $title - $body');
    
    await Future.delayed(const Duration(seconds: 3));
    
    final androidDetails = AndroidNotificationDetails(
      'clean_success_channel',
      'Notifikasi Sukses Bersih',
      channelDescription: 'Saluran untuk notifikasi sukses bersih tanpa pengaruh warna',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        '✨ $body\n\n'
        '📱 Buka aplikasi untuk melihat detail\n\n'
        '✅ Aksi berhasil diselesaikan',
        htmlFormatBigText: true,
        contentTitle: '🎯 $title',
        htmlFormatContentTitle: true,
        summaryText: 'Monekito',
        htmlFormatSummaryText: true,
      ),
      category: AndroidNotificationCategory.status,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      color: const Color(0xFF4CAF50),
      ledColor: const Color(0xFF4CAF50),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'success',
      threadIdentifier: 'monekito-success',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '🎯 $title',
        '✨ $body',
        details,
        payload: payload,
      );
      debugPrint('[NotificationService] Success notification shown successfully after 3 seconds delay');
    } catch (e) {
      debugPrint('[NotificationService] Error showing success notification: $e');
    }
  }

  Future<void> showErrorNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('[NotificationService] Showing error notification: $title - $body');
    
    await Future.delayed(const Duration(seconds: 3));
    
    final androidDetails = AndroidNotificationDetails(
      'clean_error_channel',
      'Notifikasi Error Bersih',
      channelDescription: 'Saluran untuk notifikasi error bersih tanpa pengaruh warna',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        '⚠️ $body\n\n'
        '📱 Periksa aplikasi untuk detail lebih lanjut\n\n'
        '❌ Aksi gagal',
        htmlFormatBigText: true,
        contentTitle: '🚨 $title',
        htmlFormatContentTitle: true,
        summaryText: 'Monekito',
        htmlFormatSummaryText: true,
      ),
      category: AndroidNotificationCategory.error,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      color: const Color(0xFFF44336),
      ledColor: const Color(0xFFF44336),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'error',
      threadIdentifier: 'monekito-error',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '🚨 $title',
        '⚠️ $body',
        details,
        payload: payload,
      );
      debugPrint('[NotificationService] Error notification shown successfully after 3 seconds delay');
    } catch (e) {
      debugPrint('[NotificationService] Error showing error notification: $e');
    }
  }

  Future<void> testNotification() async {
    debugPrint('[NotificationService] Testing notification...');
    
    try {
      await showInfoNotification(
        title: 'Test Notifikasi',
        body: 'Ini adalah test notifikasi untuk memastikan sistem berfungsi',
      );
      debugPrint('[NotificationService] Test notification sent successfully');
    } catch (e) {
      debugPrint('[NotificationService] Error sending test notification: $e');
    }
  }

  Future<void> showInfoNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('[NotificationService] Showing info notification: $title - $body');
    
    await Future.delayed(const Duration(seconds: 3));
    
    final androidDetails = AndroidNotificationDetails(
      'clean_info_channel',
      'Notifikasi Info Bersih',
      channelDescription: 'Saluran untuk notifikasi info bersih tanpa pengaruh warna',
      importance: Importance.none,
      priority: Priority.low,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        'ℹ️ $body',
        htmlFormatBigText: true,
        contentTitle: '💡 $title',
        htmlFormatContentTitle: true,
        summaryText: 'Monekito',
        htmlFormatSummaryText: true,
      ),
      category: AndroidNotificationCategory.message,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      color: const Color(0xFF2196F3),
      ledColor: const Color(0xFF2196F3),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
      categoryIdentifier: 'info',
      threadIdentifier: 'monekito-info',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '📢 $title',
        '💬 $body',
        details,
        payload: payload,
      );
      debugPrint('[NotificationService] Info notification shown successfully after 3 seconds delay');
    } catch (e) {
      debugPrint('[NotificationService] Error showing info notification: $e');
    }
  }

  Future<void> showTransactionSuccessNotification({
    required String transactionType,
    required double amount,
    String? category,
    String? account,
  }) async {
    debugPrint('[NotificationService] Showing transaction success notification: $transactionType - $amount');
    
    await Future.delayed(const Duration(seconds: 3));
    
    String amountText = '\$${amount.toStringAsFixed(2)}';
    
    final androidDetails = AndroidNotificationDetails(
      'clean_transaction_channel',
      'Notifikasi Transaksi Bersih',
      channelDescription: 'Saluran untuk notifikasi transaksi bersih tanpa pengaruh warna',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        '💰 $amountText\n\n'
        '✅ Transaksi berhasil disimpan',
        htmlFormatBigText: true,
        contentTitle: '🎯 $transactionType',
        htmlFormatContentTitle: true,
        summaryText: 'Monekito',
        htmlFormatSummaryText: true,
      ),
      category: AndroidNotificationCategory.status,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      color: const Color(0xFFFF9800),
      ledColor: const Color(0xFFFF9800),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'transaction_success',
      threadIdentifier: 'monekito-transaction-success',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        '🎯 $transactionType',
        '💰 $amountText • ${category ?? 'Tanpa Kategori'}',
        details,
        payload: 'transaction_success',
      );
      debugPrint('[NotificationService] Transaction success notification shown successfully after 3 seconds delay');
    } catch (e) {
      debugPrint('[NotificationService] Error showing transaction success notification: $e');
    }
  }
} 