import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sabios_app/services/push_event_bus.dart';

import '../main.dart';
import '../pages/agenda/views/agenda_page.dart';
import '../pages/explore/views/explore_page.dart';
import '../pages/messages/views/messages_page.dart';
import '../pages/profile/views/profile_page.dart';
import 'device_token_sync_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[NotificationService] Mensagem FCM recebida em background: ${message.messageId}');
  await Firebase.initializeApp();
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notificações Importantes',
    importance: Importance.max,
  );

  static Future<void> initialize({String? jwtToken}) async {
    debugPrint('[NotificationService] Solicitando permissão de notificações...');
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('[NotificationService] Status da permissão: ${settings.authorizationStatus}');

    final isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!isAuthorized) {
      debugPrint('[NotificationService] Permissão de notificação negada ou não concedida.');
      return;
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('[NotificationService] Criando canal de notificação para Android...');
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(response.payload!) as Map<String, dynamic>;
            _handleNotificationNavigation(data);
          } catch (e) {
            debugPrint('[NotificationService] Erro ao decodificar payload da notificação: $e');
          }
        }
      },
    );
    debugPrint('[NotificationService] FlutterLocalNotificationsPlugin inicializado.');

    if (jwtToken != null) {
      debugPrint('[NotificationService] Inicializando DeviceTokenSyncService com JWT fornecido...');
      await DeviceTokenSyncService.inicializar(jwtToken);
    } else {
      debugPrint('[NotificationService] Nenhum JWT fornecido no initialize; sincronização de token adiada.');
    }

    // 1. Mensagens com o app em primeiro plano (Foreground)
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[NotificationService] Mensagem FCM recebida em foreground: ${message.messageId}');
      PushEventBus.emit(message);
      _mostrarNotificacaoLocal(message);
    });
    debugPrint('[NotificationService] Listener de mensagens em foreground configurado.');

    // 2. Notificação tocada com o app em segundo plano (Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[NotificationService] onMessageOpenedApp disparado: ${message.data}');
      _handleNotificationNavigation(message.data);
    });

    // 3. Notificação que abriu o app a partir de estado fechado (Terminated)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[NotificationService] getInitialMessage detectado: ${initialMessage.data}');
      // Aguardar renderização inicial da árvore antes de navegar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationNavigation(initialMessage.data);
      });
    }
  }

  static void _mostrarNotificacaoLocal(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    debugPrint('[NotificationService] Exibindo notificação local: Título="$title", Corpo="$body"');

    if (title == null && body == null) {
      debugPrint('[NotificationService] Notificação vazia descartada.');
      return;
    }

    _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Trata o direcionamento de rotas e telas ao tocar no push notification
  /// Exemplo de payload data: {'route': '/sessao', 'id': '123'} ou {'route': '/agenda'}
  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    final route = data['route']?.toString().toLowerCase();
    final id = data['id']?.toString();
    debugPrint('[NotificationService] Navegando via push para rota: $route (id: $id)');

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      debugPrint('[NotificationService] NavigatorState ainda não está disponível.');
      return;
    }

    Widget? targetPage;
    switch (route) {
      case '/sessao':
      case '/agenda':
        targetPage = AgendaPage(onScheduleNew: () {});
        break;
      case '/mensagens':
      case '/chat':
        targetPage = const MessagesPage();
        break;
      case '/explorar':
        targetPage = const ExplorePage();
        break;
      case '/perfil':
        targetPage = const ProfilePage();
        break;
      default:
        debugPrint('[NotificationService] Rota "$route" não mapeada explicitamente.');
        break;
    }

    if (targetPage != null) {
      navigator.push(
        MaterialPageRoute(builder: (_) => targetPage!),
      );
    }
  }
}