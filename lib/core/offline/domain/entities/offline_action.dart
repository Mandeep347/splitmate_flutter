import 'package:uuid/uuid.dart';

/// Sealed base class representing an offline action queued for synchronization.
sealed class OfflineAction {
  /// Unique identifier for this queued action (UUID v4).
  final String id;

  /// Timestamp when this action was enqueued.
  final DateTime createdAt;

  /// Number of times execution of this action has been attempted.
  final int retryCount;

  /// Maximum allowed retry attempts before marking action as exhausted.
  final int maxRetries;

  /// Base constructor for [OfflineAction].
  OfflineAction({
    String? id,
    DateTime? createdAt,
    this.retryCount = 0,
    this.maxRetries = 3,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  /// Whether this action can be retried.
  bool get canRetry => retryCount < maxRetries;

  /// Whether retry attempts for this action have been exhausted.
  bool get isExhausted => retryCount >= maxRetries;

  /// Serializes action into JSON Map.
  Map<String, dynamic> toJson();

  /// Creates an [OfflineAction] copy with updated fields.
  OfflineAction copyWith({int? retryCount});

  /// Factory constructor restoring an [OfflineAction] from JSON Map.
  static OfflineAction fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'CREATE_EXPENSE':
        return CreateExpenseAction.fromJson(json);
      case 'CREATE_SETTLEMENT':
        return CreateSettlementAction.fromJson(json);
      case 'ADD_MEMBER':
        return AddMemberAction.fromJson(json);
      default:
        throw FormatException('Unknown OfflineAction type: $type');
    }
  }
}

/// Offline action for creating a new group expense.
final class CreateExpenseAction extends OfflineAction {
  final String groupId;
  final String title;
  final String? description;
  final double totalAmount;
  final String currency;
  final String paidByUserId;
  final String splitType;
  final String participantsJson;
  final String idempotencyKey;

  CreateExpenseAction({
    super.id,
    super.createdAt,
    super.retryCount,
    super.maxRetries,
    required this.groupId,
    required this.title,
    this.description,
    required this.totalAmount,
    required this.currency,
    required this.paidByUserId,
    required this.splitType,
    required this.participantsJson,
    required this.idempotencyKey,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'CREATE_EXPENSE',
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'maxRetries': maxRetries,
      'groupId': groupId,
      'title': title,
      'description': description,
      'totalAmount': totalAmount,
      'currency': currency,
      'paidByUserId': paidByUserId,
      'splitType': splitType,
      'participantsJson': participantsJson,
      'idempotencyKey': idempotencyKey,
    };
  }

  factory CreateExpenseAction.fromJson(Map<String, dynamic> json) {
    return CreateExpenseAction(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
      groupId: json['groupId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      paidByUserId: json['paidByUserId'] as String,
      splitType: json['splitType'] as String,
      participantsJson: json['participantsJson'] as String,
      idempotencyKey: json['idempotencyKey'] as String,
    );
  }

  @override
  CreateExpenseAction copyWith({int? retryCount}) {
    return CreateExpenseAction(
      id: id,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries,
      groupId: groupId,
      title: title,
      description: description,
      totalAmount: totalAmount,
      currency: currency,
      paidByUserId: paidByUserId,
      splitType: splitType,
      participantsJson: participantsJson,
      idempotencyKey: idempotencyKey,
    );
  }
}

/// Offline action for recording a debt settlement.
final class CreateSettlementAction extends OfflineAction {
  final String groupId;
  final String fromUserId;
  final String toUserId;
  final double amount;
  final String currency;
  final String? note;
  final String idempotencyKey;

  CreateSettlementAction({
    super.id,
    super.createdAt,
    super.retryCount,
    super.maxRetries,
    required this.groupId,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.currency,
    this.note,
    required this.idempotencyKey,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'CREATE_SETTLEMENT',
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'maxRetries': maxRetries,
      'groupId': groupId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amount': amount,
      'currency': currency,
      'note': note,
      'idempotencyKey': idempotencyKey,
    };
  }

  factory CreateSettlementAction.fromJson(Map<String, dynamic> json) {
    return CreateSettlementAction(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
      groupId: json['groupId'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      note: json['note'] as String?,
      idempotencyKey: json['idempotencyKey'] as String,
    );
  }

  @override
  CreateSettlementAction copyWith({int? retryCount}) {
    return CreateSettlementAction(
      id: id,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries,
      groupId: groupId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      amount: amount,
      currency: currency,
      note: note,
      idempotencyKey: idempotencyKey,
    );
  }
}

/// Offline action for inviting / adding a group member.
final class AddMemberAction extends OfflineAction {
  final String groupId;
  final String email;
  final String idempotencyKey;

  AddMemberAction({
    super.id,
    super.createdAt,
    super.retryCount,
    super.maxRetries,
    required this.groupId,
    required this.email,
    required this.idempotencyKey,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ADD_MEMBER',
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'maxRetries': maxRetries,
      'groupId': groupId,
      'email': email,
      'idempotencyKey': idempotencyKey,
    };
  }

  factory AddMemberAction.fromJson(Map<String, dynamic> json) {
    return AddMemberAction(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
      groupId: json['groupId'] as String,
      email: json['email'] as String,
      idempotencyKey: json['idempotencyKey'] as String,
    );
  }

  @override
  AddMemberAction copyWith({int? retryCount}) {
    return AddMemberAction(
      id: id,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries,
      groupId: groupId,
      email: email,
      idempotencyKey: idempotencyKey,
    );
  }
}
