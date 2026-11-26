import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/action_plan_model.dart';

class ActionPlanService {
  static Future<List<ActionPlanModel>> getActionPlans({
    bool? completed,
    bool? overdue,
    String? mentoringId,
  }) async {
    final params = <String, dynamic>{
      if (completed != null) 'completed': completed,
      if (overdue != null) 'overdue': overdue,
      if (mentoringId != null) 'mentoringId': mentoringId,
    };

    final response = await ApiClient.get(
      ApiEndpoints.actionPlans,
      queryParameters: params,
    );

    if (response is List) {
      return response
          .map((item) => ActionPlanModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<ActionPlanModel?> toggleActionPlan(String id) async {
    final response = await ApiClient.patch(ApiEndpoints.actionPlanToggle(id));
    if (response is Map<String, dynamic>) {
      return ActionPlanModel.fromJson(response);
    }
    return null;
  }

  static Future<ActionPlanModel?> createActionPlan({
    required String title,
    String? deadline,
    String? dueDate,
    String? mentoringId,
    String? conselheiroNome,
  }) async {
    final body = {
      'title': title,
      if (deadline != null) 'deadline': deadline,
      if (dueDate != null) 'dueDate': dueDate,
      if (mentoringId != null) 'mentoringId': mentoringId,
      if (conselheiroNome != null) 'conselheiroNome': conselheiroNome,
    };

    final response = await ApiClient.post(ApiEndpoints.actionPlans, body: body);
    if (response is Map<String, dynamic>) {
      return ActionPlanModel.fromJson(response);
    }
    return null;
  }

  static Future<bool> deleteActionPlan(String id) async {
    try {
      await ApiClient.delete(ApiEndpoints.actionPlanById(id));
      return true;
    } catch (_) {
      return false;
    }
  }
}
