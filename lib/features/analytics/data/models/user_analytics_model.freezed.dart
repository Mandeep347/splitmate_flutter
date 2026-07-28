// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserAnalyticsModel _$UserAnalyticsModelFromJson(Map<String, dynamic> json) {
  return _UserAnalyticsModel.fromJson(json);
}

/// @nodoc
mixin _$UserAnalyticsModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_paid_all_groups')
  String get totalPaidAllGroups => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_owed_to_others')
  String get totalOwedToOthers => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_others_owe_user')
  String get totalOthersOweUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_balance')
  String get netBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_groups_count')
  int get totalGroupsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expense_count')
  int get totalExpenseCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'most_expensive_group_name')
  String? get mostExpensiveGroupName => throw _privateConstructorUsedError;
  List<UserAnalyticsGroupModel> get groups =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_spending')
  List<MonthlySpendingModel> get monthlySpending =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAnalyticsModelCopyWith<UserAnalyticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAnalyticsModelCopyWith<$Res> {
  factory $UserAnalyticsModelCopyWith(
    UserAnalyticsModel value,
    $Res Function(UserAnalyticsModel) then,
  ) = _$UserAnalyticsModelCopyWithImpl<$Res, UserAnalyticsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'user_name') String userName,
    @JsonKey(name: 'total_paid_all_groups') String totalPaidAllGroups,
    @JsonKey(name: 'total_owed_to_others') String totalOwedToOthers,
    @JsonKey(name: 'total_others_owe_user') String totalOthersOweUser,
    @JsonKey(name: 'net_balance') String netBalance,
    @JsonKey(name: 'total_groups_count') int totalGroupsCount,
    @JsonKey(name: 'total_expense_count') int totalExpenseCount,
    @JsonKey(name: 'most_expensive_group_name') String? mostExpensiveGroupName,
    List<UserAnalyticsGroupModel> groups,
    @JsonKey(name: 'monthly_spending')
    List<MonthlySpendingModel> monthlySpending,
  });
}

/// @nodoc
class _$UserAnalyticsModelCopyWithImpl<$Res, $Val extends UserAnalyticsModel>
    implements $UserAnalyticsModelCopyWith<$Res> {
  _$UserAnalyticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? totalPaidAllGroups = null,
    Object? totalOwedToOthers = null,
    Object? totalOthersOweUser = null,
    Object? netBalance = null,
    Object? totalGroupsCount = null,
    Object? totalExpenseCount = null,
    Object? mostExpensiveGroupName = freezed,
    Object? groups = null,
    Object? monthlySpending = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPaidAllGroups: null == totalPaidAllGroups
                ? _value.totalPaidAllGroups
                : totalPaidAllGroups // ignore: cast_nullable_to_non_nullable
                      as String,
            totalOwedToOthers: null == totalOwedToOthers
                ? _value.totalOwedToOthers
                : totalOwedToOthers // ignore: cast_nullable_to_non_nullable
                      as String,
            totalOthersOweUser: null == totalOthersOweUser
                ? _value.totalOthersOweUser
                : totalOthersOweUser // ignore: cast_nullable_to_non_nullable
                      as String,
            netBalance: null == netBalance
                ? _value.netBalance
                : netBalance // ignore: cast_nullable_to_non_nullable
                      as String,
            totalGroupsCount: null == totalGroupsCount
                ? _value.totalGroupsCount
                : totalGroupsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalExpenseCount: null == totalExpenseCount
                ? _value.totalExpenseCount
                : totalExpenseCount // ignore: cast_nullable_to_non_nullable
                      as int,
            mostExpensiveGroupName: freezed == mostExpensiveGroupName
                ? _value.mostExpensiveGroupName
                : mostExpensiveGroupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            groups: null == groups
                ? _value.groups
                : groups // ignore: cast_nullable_to_non_nullable
                      as List<UserAnalyticsGroupModel>,
            monthlySpending: null == monthlySpending
                ? _value.monthlySpending
                : monthlySpending // ignore: cast_nullable_to_non_nullable
                      as List<MonthlySpendingModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserAnalyticsModelImplCopyWith<$Res>
    implements $UserAnalyticsModelCopyWith<$Res> {
  factory _$$UserAnalyticsModelImplCopyWith(
    _$UserAnalyticsModelImpl value,
    $Res Function(_$UserAnalyticsModelImpl) then,
  ) = __$$UserAnalyticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'user_name') String userName,
    @JsonKey(name: 'total_paid_all_groups') String totalPaidAllGroups,
    @JsonKey(name: 'total_owed_to_others') String totalOwedToOthers,
    @JsonKey(name: 'total_others_owe_user') String totalOthersOweUser,
    @JsonKey(name: 'net_balance') String netBalance,
    @JsonKey(name: 'total_groups_count') int totalGroupsCount,
    @JsonKey(name: 'total_expense_count') int totalExpenseCount,
    @JsonKey(name: 'most_expensive_group_name') String? mostExpensiveGroupName,
    List<UserAnalyticsGroupModel> groups,
    @JsonKey(name: 'monthly_spending')
    List<MonthlySpendingModel> monthlySpending,
  });
}

/// @nodoc
class __$$UserAnalyticsModelImplCopyWithImpl<$Res>
    extends _$UserAnalyticsModelCopyWithImpl<$Res, _$UserAnalyticsModelImpl>
    implements _$$UserAnalyticsModelImplCopyWith<$Res> {
  __$$UserAnalyticsModelImplCopyWithImpl(
    _$UserAnalyticsModelImpl _value,
    $Res Function(_$UserAnalyticsModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? totalPaidAllGroups = null,
    Object? totalOwedToOthers = null,
    Object? totalOthersOweUser = null,
    Object? netBalance = null,
    Object? totalGroupsCount = null,
    Object? totalExpenseCount = null,
    Object? mostExpensiveGroupName = freezed,
    Object? groups = null,
    Object? monthlySpending = null,
  }) {
    return _then(
      _$UserAnalyticsModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPaidAllGroups: null == totalPaidAllGroups
            ? _value.totalPaidAllGroups
            : totalPaidAllGroups // ignore: cast_nullable_to_non_nullable
                  as String,
        totalOwedToOthers: null == totalOwedToOthers
            ? _value.totalOwedToOthers
            : totalOwedToOthers // ignore: cast_nullable_to_non_nullable
                  as String,
        totalOthersOweUser: null == totalOthersOweUser
            ? _value.totalOthersOweUser
            : totalOthersOweUser // ignore: cast_nullable_to_non_nullable
                  as String,
        netBalance: null == netBalance
            ? _value.netBalance
            : netBalance // ignore: cast_nullable_to_non_nullable
                  as String,
        totalGroupsCount: null == totalGroupsCount
            ? _value.totalGroupsCount
            : totalGroupsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalExpenseCount: null == totalExpenseCount
            ? _value.totalExpenseCount
            : totalExpenseCount // ignore: cast_nullable_to_non_nullable
                  as int,
        mostExpensiveGroupName: freezed == mostExpensiveGroupName
            ? _value.mostExpensiveGroupName
            : mostExpensiveGroupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        groups: null == groups
            ? _value._groups
            : groups // ignore: cast_nullable_to_non_nullable
                  as List<UserAnalyticsGroupModel>,
        monthlySpending: null == monthlySpending
            ? _value._monthlySpending
            : monthlySpending // ignore: cast_nullable_to_non_nullable
                  as List<MonthlySpendingModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAnalyticsModelImpl extends _UserAnalyticsModel {
  const _$UserAnalyticsModelImpl({
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'user_name') required this.userName,
    @JsonKey(name: 'total_paid_all_groups') required this.totalPaidAllGroups,
    @JsonKey(name: 'total_owed_to_others') required this.totalOwedToOthers,
    @JsonKey(name: 'total_others_owe_user') required this.totalOthersOweUser,
    @JsonKey(name: 'net_balance') required this.netBalance,
    @JsonKey(name: 'total_groups_count') required this.totalGroupsCount,
    @JsonKey(name: 'total_expense_count') required this.totalExpenseCount,
    @JsonKey(name: 'most_expensive_group_name') this.mostExpensiveGroupName,
    required final List<UserAnalyticsGroupModel> groups,
    @JsonKey(name: 'monthly_spending')
    required final List<MonthlySpendingModel> monthlySpending,
  }) : _groups = groups,
       _monthlySpending = monthlySpending,
       super._();

  factory _$UserAnalyticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAnalyticsModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'total_paid_all_groups')
  final String totalPaidAllGroups;
  @override
  @JsonKey(name: 'total_owed_to_others')
  final String totalOwedToOthers;
  @override
  @JsonKey(name: 'total_others_owe_user')
  final String totalOthersOweUser;
  @override
  @JsonKey(name: 'net_balance')
  final String netBalance;
  @override
  @JsonKey(name: 'total_groups_count')
  final int totalGroupsCount;
  @override
  @JsonKey(name: 'total_expense_count')
  final int totalExpenseCount;
  @override
  @JsonKey(name: 'most_expensive_group_name')
  final String? mostExpensiveGroupName;
  final List<UserAnalyticsGroupModel> _groups;
  @override
  List<UserAnalyticsGroupModel> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  final List<MonthlySpendingModel> _monthlySpending;
  @override
  @JsonKey(name: 'monthly_spending')
  List<MonthlySpendingModel> get monthlySpending {
    if (_monthlySpending is EqualUnmodifiableListView) return _monthlySpending;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlySpending);
  }

  @override
  String toString() {
    return 'UserAnalyticsModel(userId: $userId, userName: $userName, totalPaidAllGroups: $totalPaidAllGroups, totalOwedToOthers: $totalOwedToOthers, totalOthersOweUser: $totalOthersOweUser, netBalance: $netBalance, totalGroupsCount: $totalGroupsCount, totalExpenseCount: $totalExpenseCount, mostExpensiveGroupName: $mostExpensiveGroupName, groups: $groups, monthlySpending: $monthlySpending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAnalyticsModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.totalPaidAllGroups, totalPaidAllGroups) ||
                other.totalPaidAllGroups == totalPaidAllGroups) &&
            (identical(other.totalOwedToOthers, totalOwedToOthers) ||
                other.totalOwedToOthers == totalOwedToOthers) &&
            (identical(other.totalOthersOweUser, totalOthersOweUser) ||
                other.totalOthersOweUser == totalOthersOweUser) &&
            (identical(other.netBalance, netBalance) ||
                other.netBalance == netBalance) &&
            (identical(other.totalGroupsCount, totalGroupsCount) ||
                other.totalGroupsCount == totalGroupsCount) &&
            (identical(other.totalExpenseCount, totalExpenseCount) ||
                other.totalExpenseCount == totalExpenseCount) &&
            (identical(other.mostExpensiveGroupName, mostExpensiveGroupName) ||
                other.mostExpensiveGroupName == mostExpensiveGroupName) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            const DeepCollectionEquality().equals(
              other._monthlySpending,
              _monthlySpending,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    userName,
    totalPaidAllGroups,
    totalOwedToOthers,
    totalOthersOweUser,
    netBalance,
    totalGroupsCount,
    totalExpenseCount,
    mostExpensiveGroupName,
    const DeepCollectionEquality().hash(_groups),
    const DeepCollectionEquality().hash(_monthlySpending),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAnalyticsModelImplCopyWith<_$UserAnalyticsModelImpl> get copyWith =>
      __$$UserAnalyticsModelImplCopyWithImpl<_$UserAnalyticsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAnalyticsModelImplToJson(this);
  }
}

abstract class _UserAnalyticsModel extends UserAnalyticsModel {
  const factory _UserAnalyticsModel({
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'user_name') required final String userName,
    @JsonKey(name: 'total_paid_all_groups')
    required final String totalPaidAllGroups,
    @JsonKey(name: 'total_owed_to_others')
    required final String totalOwedToOthers,
    @JsonKey(name: 'total_others_owe_user')
    required final String totalOthersOweUser,
    @JsonKey(name: 'net_balance') required final String netBalance,
    @JsonKey(name: 'total_groups_count') required final int totalGroupsCount,
    @JsonKey(name: 'total_expense_count') required final int totalExpenseCount,
    @JsonKey(name: 'most_expensive_group_name')
    final String? mostExpensiveGroupName,
    required final List<UserAnalyticsGroupModel> groups,
    @JsonKey(name: 'monthly_spending')
    required final List<MonthlySpendingModel> monthlySpending,
  }) = _$UserAnalyticsModelImpl;
  const _UserAnalyticsModel._() : super._();

  factory _UserAnalyticsModel.fromJson(Map<String, dynamic> json) =
      _$UserAnalyticsModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'total_paid_all_groups')
  String get totalPaidAllGroups;
  @override
  @JsonKey(name: 'total_owed_to_others')
  String get totalOwedToOthers;
  @override
  @JsonKey(name: 'total_others_owe_user')
  String get totalOthersOweUser;
  @override
  @JsonKey(name: 'net_balance')
  String get netBalance;
  @override
  @JsonKey(name: 'total_groups_count')
  int get totalGroupsCount;
  @override
  @JsonKey(name: 'total_expense_count')
  int get totalExpenseCount;
  @override
  @JsonKey(name: 'most_expensive_group_name')
  String? get mostExpensiveGroupName;
  @override
  List<UserAnalyticsGroupModel> get groups;
  @override
  @JsonKey(name: 'monthly_spending')
  List<MonthlySpendingModel> get monthlySpending;
  @override
  @JsonKey(ignore: true)
  _$$UserAnalyticsModelImplCopyWith<_$UserAnalyticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
