// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_analytics_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserAnalyticsGroupModel _$UserAnalyticsGroupModelFromJson(
  Map<String, dynamic> json,
) {
  return _UserAnalyticsGroupModel.fromJson(json);
}

/// @nodoc
mixin _$UserAnalyticsGroupModel {
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_name')
  String get groupName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  String get totalSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_paid')
  String get userPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_owed')
  String get userOwed => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_count')
  int get expenseCount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAnalyticsGroupModelCopyWith<UserAnalyticsGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAnalyticsGroupModelCopyWith<$Res> {
  factory $UserAnalyticsGroupModelCopyWith(
    UserAnalyticsGroupModel value,
    $Res Function(UserAnalyticsGroupModel) then,
  ) = _$UserAnalyticsGroupModelCopyWithImpl<$Res, UserAnalyticsGroupModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'group_name') String groupName,
    @JsonKey(name: 'total_spent') String totalSpent,
    @JsonKey(name: 'user_paid') String userPaid,
    @JsonKey(name: 'user_owed') String userOwed,
    @JsonKey(name: 'expense_count') int expenseCount,
    String currency,
  });
}

/// @nodoc
class _$UserAnalyticsGroupModelCopyWithImpl<
  $Res,
  $Val extends UserAnalyticsGroupModel
>
    implements $UserAnalyticsGroupModelCopyWith<$Res> {
  _$UserAnalyticsGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? totalSpent = null,
    Object? userPaid = null,
    Object? userOwed = null,
    Object? expenseCount = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String,
            groupName: null == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalSpent: null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as String,
            userPaid: null == userPaid
                ? _value.userPaid
                : userPaid // ignore: cast_nullable_to_non_nullable
                      as String,
            userOwed: null == userOwed
                ? _value.userOwed
                : userOwed // ignore: cast_nullable_to_non_nullable
                      as String,
            expenseCount: null == expenseCount
                ? _value.expenseCount
                : expenseCount // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserAnalyticsGroupModelImplCopyWith<$Res>
    implements $UserAnalyticsGroupModelCopyWith<$Res> {
  factory _$$UserAnalyticsGroupModelImplCopyWith(
    _$UserAnalyticsGroupModelImpl value,
    $Res Function(_$UserAnalyticsGroupModelImpl) then,
  ) = __$$UserAnalyticsGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'group_name') String groupName,
    @JsonKey(name: 'total_spent') String totalSpent,
    @JsonKey(name: 'user_paid') String userPaid,
    @JsonKey(name: 'user_owed') String userOwed,
    @JsonKey(name: 'expense_count') int expenseCount,
    String currency,
  });
}

/// @nodoc
class __$$UserAnalyticsGroupModelImplCopyWithImpl<$Res>
    extends
        _$UserAnalyticsGroupModelCopyWithImpl<
          $Res,
          _$UserAnalyticsGroupModelImpl
        >
    implements _$$UserAnalyticsGroupModelImplCopyWith<$Res> {
  __$$UserAnalyticsGroupModelImplCopyWithImpl(
    _$UserAnalyticsGroupModelImpl _value,
    $Res Function(_$UserAnalyticsGroupModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? totalSpent = null,
    Object? userPaid = null,
    Object? userOwed = null,
    Object? expenseCount = null,
    Object? currency = null,
  }) {
    return _then(
      _$UserAnalyticsGroupModelImpl(
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalSpent: null == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as String,
        userPaid: null == userPaid
            ? _value.userPaid
            : userPaid // ignore: cast_nullable_to_non_nullable
                  as String,
        userOwed: null == userOwed
            ? _value.userOwed
            : userOwed // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseCount: null == expenseCount
            ? _value.expenseCount
            : expenseCount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAnalyticsGroupModelImpl extends _UserAnalyticsGroupModel {
  const _$UserAnalyticsGroupModelImpl({
    @JsonKey(name: 'group_id') required this.groupId,
    @JsonKey(name: 'group_name') required this.groupName,
    @JsonKey(name: 'total_spent') required this.totalSpent,
    @JsonKey(name: 'user_paid') required this.userPaid,
    @JsonKey(name: 'user_owed') required this.userOwed,
    @JsonKey(name: 'expense_count') required this.expenseCount,
    required this.currency,
  }) : super._();

  factory _$UserAnalyticsGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAnalyticsGroupModelImplFromJson(json);

  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'group_name')
  final String groupName;
  @override
  @JsonKey(name: 'total_spent')
  final String totalSpent;
  @override
  @JsonKey(name: 'user_paid')
  final String userPaid;
  @override
  @JsonKey(name: 'user_owed')
  final String userOwed;
  @override
  @JsonKey(name: 'expense_count')
  final int expenseCount;
  @override
  final String currency;

  @override
  String toString() {
    return 'UserAnalyticsGroupModel(groupId: $groupId, groupName: $groupName, totalSpent: $totalSpent, userPaid: $userPaid, userOwed: $userOwed, expenseCount: $expenseCount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAnalyticsGroupModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.userPaid, userPaid) ||
                other.userPaid == userPaid) &&
            (identical(other.userOwed, userOwed) ||
                other.userOwed == userOwed) &&
            (identical(other.expenseCount, expenseCount) ||
                other.expenseCount == expenseCount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    groupName,
    totalSpent,
    userPaid,
    userOwed,
    expenseCount,
    currency,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAnalyticsGroupModelImplCopyWith<_$UserAnalyticsGroupModelImpl>
  get copyWith =>
      __$$UserAnalyticsGroupModelImplCopyWithImpl<
        _$UserAnalyticsGroupModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAnalyticsGroupModelImplToJson(this);
  }
}

abstract class _UserAnalyticsGroupModel extends UserAnalyticsGroupModel {
  const factory _UserAnalyticsGroupModel({
    @JsonKey(name: 'group_id') required final String groupId,
    @JsonKey(name: 'group_name') required final String groupName,
    @JsonKey(name: 'total_spent') required final String totalSpent,
    @JsonKey(name: 'user_paid') required final String userPaid,
    @JsonKey(name: 'user_owed') required final String userOwed,
    @JsonKey(name: 'expense_count') required final int expenseCount,
    required final String currency,
  }) = _$UserAnalyticsGroupModelImpl;
  const _UserAnalyticsGroupModel._() : super._();

  factory _UserAnalyticsGroupModel.fromJson(Map<String, dynamic> json) =
      _$UserAnalyticsGroupModelImpl.fromJson;

  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'group_name')
  String get groupName;
  @override
  @JsonKey(name: 'total_spent')
  String get totalSpent;
  @override
  @JsonKey(name: 'user_paid')
  String get userPaid;
  @override
  @JsonKey(name: 'user_owed')
  String get userOwed;
  @override
  @JsonKey(name: 'expense_count')
  int get expenseCount;
  @override
  String get currency;
  @override
  @JsonKey(ignore: true)
  _$$UserAnalyticsGroupModelImplCopyWith<_$UserAnalyticsGroupModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
