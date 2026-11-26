class ActionPlanModel {
  final String id;
  final String title;
  final String? deadline;
  final String? dueDate;
  final bool completed;
  final String? conselheiroNome;
  final String? mentoringId;
  final String? specialistId;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final bool overdue;
  final bool assignedByCounselor;

  const ActionPlanModel({
    required this.id,
    required this.title,
    this.deadline,
    this.dueDate,
    this.completed = false,
    this.conselheiroNome,
    this.mentoringId,
    this.specialistId,
    this.completedAt,
    this.createdAt,
    this.overdue = false,
    this.assignedByCounselor = false,
  });

  ActionPlanModel copyWith({bool? completed, DateTime? completedAt}) {
    return ActionPlanModel(
      id: id,
      title: title,
      deadline: deadline,
      dueDate: dueDate,
      completed: completed ?? this.completed,
      conselheiroNome: conselheiroNome,
      mentoringId: mentoringId,
      specialistId: specialistId,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt,
      overdue: overdue,
      assignedByCounselor: assignedByCounselor,
    );
  }

  factory ActionPlanModel.fromJson(Map<String, dynamic> json) {
    return ActionPlanModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      deadline: json['deadline']?.toString(),
      dueDate: json['dueDate']?.toString(),
      completed: json['completed'] == true,
      conselheiroNome: json['conselheiroNome']?.toString(),
      mentoringId: json['mentoringId']?.toString(),
      specialistId: json['specialistId']?.toString(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      overdue: json['overdue'] == true,
      assignedByCounselor: json['assignedByCounselor'] == true,
    );
  }
}
