// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SettlementModel _$SettlementModelFromJson(Map<String, dynamic> json) {
  return _SettlementModel.fromJson(json);
}

/// @nodoc
mixin _$SettlementModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_user_id')
  String get fromUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_user_name')
  String get fromUserName => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_user_id')
  String get toUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_user_name')
  String get toUserName => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettlementModelCopyWith<SettlementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementModelCopyWith<$Res> {
  factory $SettlementModelCopyWith(
    SettlementModel value,
    $Res Function(SettlementModel) then,
  ) = _$SettlementModelCopyWithImpl<$Res, SettlementModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'from_user_id') String fromUserId,
    @JsonKey(name: 'from_user_name') String fromUserName,
    @JsonKey(name: 'to_user_id') String toUserId,
    @JsonKey(name: 'to_user_name') String toUserName,
    String amount,
    String currency,
    String? note,
    String status,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$SettlementModelCopyWithImpl<$Res, $Val extends SettlementModel>
    implements $SettlementModelCopyWith<$Res> {
  _$SettlementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? fromUserId = null,
    Object? fromUserName = null,
    Object? toUserId = null,
    Object? toUserName = null,
    Object? amount = null,
    Object? currency = null,
    Object? note = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUserId: null == fromUserId
                ? _value.fromUserId
                : fromUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUserName: null == fromUserName
                ? _value.fromUserName
                : fromUserName // ignore: cast_nullable_to_non_nullable
                      as String,
            toUserId: null == toUserId
                ? _value.toUserId
                : toUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            toUserName: null == toUserName
                ? _value.toUserName
                : toUserName // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettlementModelImplCopyWith<$Res>
    implements $SettlementModelCopyWith<$Res> {
  factory _$$SettlementModelImplCopyWith(
    _$SettlementModelImpl value,
    $Res Function(_$SettlementModelImpl) then,
  ) = __$$SettlementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'from_user_id') String fromUserId,
    @JsonKey(name: 'from_user_name') String fromUserName,
    @JsonKey(name: 'to_user_id') String toUserId,
    @JsonKey(name: 'to_user_name') String toUserName,
    String amount,
    String currency,
    String? note,
    String status,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$SettlementModelImplCopyWithImpl<$Res>
    extends _$SettlementModelCopyWithImpl<$Res, _$SettlementModelImpl>
    implements _$$SettlementModelImplCopyWith<$Res> {
  __$$SettlementModelImplCopyWithImpl(
    _$SettlementModelImpl _value,
    $Res Function(_$SettlementModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? fromUserId = null,
    Object? fromUserName = null,
    Object? toUserId = null,
    Object? toUserName = null,
    Object? amount = null,
    Object? currency = null,
    Object? note = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SettlementModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUserId: null == fromUserId
            ? _value.fromUserId
            : fromUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUserName: null == fromUserName
            ? _value.fromUserName
            : fromUserName // ignore: cast_nullable_to_non_nullable
                  as String,
        toUserId: null == toUserId
            ? _value.toUserId
            : toUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        toUserName: null == toUserName
            ? _value.toUserName
            : toUserName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementModelImpl extends _SettlementModel {
  const _$SettlementModelImpl({
    required this.id,
    @JsonKey(name: 'group_id') required this.groupId,
    @JsonKey(name: 'from_user_id') required this.fromUserId,
    @JsonKey(name: 'from_user_name') required this.fromUserName,
    @JsonKey(name: 'to_user_id') required this.toUserId,
    @JsonKey(name: 'to_user_name') required this.toUserName,
    required this.amount,
    required this.currency,
    this.note,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : super._();

  factory _$SettlementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'from_user_id')
  final String fromUserId;
  @override
  @JsonKey(name: 'from_user_name')
  final String fromUserName;
  @override
  @JsonKey(name: 'to_user_id')
  final String toUserId;
  @override
  @JsonKey(name: 'to_user_name')
  final String toUserName;
  @override
  final String amount;
  @override
  final String currency;
  @override
  final String? note;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'SettlementModel(id: $id, groupId: $groupId, fromUserId: $fromUserId, fromUserName: $fromUserName, toUserId: $toUserId, toUserName: $toUserName, amount: $amount, currency: $currency, note: $note, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.fromUserName, fromUserName) ||
                other.fromUserName == fromUserName) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.toUserName, toUserName) ||
                other.toUserName == toUserName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    groupId,
    fromUserId,
    fromUserName,
    toUserId,
    toUserName,
    amount,
    currency,
    note,
    status,
    createdAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementModelImplCopyWith<_$SettlementModelImpl> get copyWith =>
      __$$SettlementModelImplCopyWithImpl<_$SettlementModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementModelImplToJson(this);
  }
}

abstract class _SettlementModel extends SettlementModel {
  const factory _SettlementModel({
    required final String id,
    @JsonKey(name: 'group_id') required final String groupId,
    @JsonKey(name: 'from_user_id') required final String fromUserId,
    @JsonKey(name: 'from_user_name') required final String fromUserName,
    @JsonKey(name: 'to_user_id') required final String toUserId,
    @JsonKey(name: 'to_user_name') required final String toUserName,
    required final String amount,
    required final String currency,
    final String? note,
    required final String status,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$SettlementModelImpl;
  const _SettlementModel._() : super._();

  factory _SettlementModel.fromJson(Map<String, dynamic> json) =
      _$SettlementModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'from_user_id')
  String get fromUserId;
  @override
  @JsonKey(name: 'from_user_name')
  String get fromUserName;
  @override
  @JsonKey(name: 'to_user_id')
  String get toUserId;
  @override
  @JsonKey(name: 'to_user_name')
  String get toUserName;
  @override
  String get amount;
  @override
  String get currency;
  @override
  String? get note;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SettlementModelImplCopyWith<_$SettlementModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
