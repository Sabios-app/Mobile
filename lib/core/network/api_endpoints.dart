class ApiEndpoints {
  static const String baseUrl = 'https://api-sabios.lmagalhaes.com';
  static const String apiV1 = '$baseUrl/api/v1';

  // Auth
  static const String login = '$apiV1/auth/login';
  static const String register = '$apiV1/auth/register';
  static const String forgotPassword = '$apiV1/auth/forgot-password';
  static const String resetPassword = '$apiV1/auth/reset-password';

  // Users
  static const String userMe = '$apiV1/users/me';

  // Specialists
  static const String specialists = '$apiV1/specialists';
  static const String specialistMe = '$apiV1/specialists/me';
  static String specialistById(String id) => '$apiV1/specialists/$id';

  // Agenda
  static const String agenda = '$apiV1/agenda';
  static const String agendaMe = '$apiV1/agenda/me';
  static String agendaDelete(String id) => '$apiV1/agenda/$id';
  static String specialistAgenda(String specialistId) =>
      '$apiV1/agenda/specialists/$specialistId';
  static String specialistSlots(String specialistId) =>
      '$apiV1/agenda/specialists/$specialistId/slots';

  // Mentorings
  static const String mentorings = '$apiV1/mentorings';
  static const String mentoringsMe = '$apiV1/mentorings';
  static const String mentoringsNext = '$apiV1/mentorings/next';
  static String mentoringAccept(String id) => '$apiV1/mentorings/$id/accept';
  static String mentoringReject(String id) => '$apiV1/mentorings/$id/reject';
  static String mentoringLink(String id) => '$apiV1/mentorings/$id/meeting-link';

  // Action Plans
  static const String actionPlans = '$apiV1/action-plans';
  static String actionPlanToggle(String id) => '$apiV1/action-plans/$id/toggle';
  static String actionPlanById(String id) => '$apiV1/action-plans/$id';
  static String mentoringActionPlans(String mentoringId) =>
      '$apiV1/action-plans/mentorings/$mentoringId';

  // Notifications
  static const String notifications = '$apiV1/notifications';
  static const String notificationsUnreadCount = '$apiV1/notifications/unread-count';
  static String notificationRead(String id) => '$apiV1/notifications/$id/read';
  static const String notificationsReadAll = '$apiV1/notifications/read-all';

  // Devices & Push
  static const String deviceToken = '$apiV1/devices/token';
  static const String deviceTokensAll = '$apiV1/devices/tokens/all';
  static const String devicesMe = '$apiV1/devices/me';

  // Messages
  static const String conversations = '$apiV1/messages/conversations';
  static String conversationById(String id) => '$apiV1/messages/conversations/$id';
  static const String sendMessage = '$apiV1/messages';

  // Reviews
  static const String reviews = '$apiV1/reviews';
  static const String reviewsPending = '$apiV1/reviews/pending';
  static const String reviewsMe = '$apiV1/reviews/me';
  static String reviewsSpecialist(String specialistId) =>
      '$apiV1/reviews/specialists/$specialistId';
  static String reviewsSummary(String specialistId) =>
      '$apiV1/reviews/specialists/$specialistId/summary';
  static String reviewById(String id) => '$apiV1/reviews/$id';
}
