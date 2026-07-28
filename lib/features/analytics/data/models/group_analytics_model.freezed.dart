// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GroupAnalyticsModel _$GroupAnalyticsModelFromJson(Map<String, dynamic> json) {
  return _GroupAnalyticsModel.fromJson(json);
}

/// @nodoc
mixin _$GroupAnalyticsModel {
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_name')
  String get groupName => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses_amount')
  String get totalExpensesAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expense_count')
  int get totalExpenseCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_settlements_amount')
  String get totalSettlementsAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'settlement_rate')
  String get settlementRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_expense_amount')
  String get averageExpenseAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'largest_expense_amount')
  String get largestExpenseAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'largest_expense_title')
  String? get largestExpenseTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_spender_name')
  String? get topSpenderName => throw _privateConstructorUsedError;
  List<MemberContributionModel> get members =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_spending')
  List<MonthlySpendingModel> get monthlySpending =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupAnalyticsModelCopyWith<GroupAnalyticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupAnalyticsModelCopyWith<$Res> {
  factory $GroupAnalyticsModelCopyWith(
    GroupAnalyticsModel value,
    $Res Function(GroupAnalyticsModel) then,
  ) = _$GroupAnalyticsModelCopyWithImpl<$Res, GroupAnalyticsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'group_name') String groupName,
    String currency,
    @JsonKey(name: 'total_expenses_amount') String totalExpensesAmount,
    @JsonKey(name: 'total_expense_count') int totalExpenseCount,
    @JsonKey(name: 'total_settlements_amount') String totalSettlementsAmount,
    @JsonKey(name: 'settlement_rate') String settlementRate,
    @JsonKey(name: 'average_expense_amount') String averageExpenseAmount,
    @JsonKey(name: 'largest_expense_amount') String largestExpenseAmount,
    @JsonKey(name: 'largest_expense_title') String? largestExpenseTitle,
    @JsonKey(name: 'top_spender_name') String? topSpenderName,
    List<MemberContributionModel> members,
    @JsonKey(name: 'monthly_spending')
    List<MonthlySpendingModel> monthlySpending,
  });
}

/// @nodoc
class _$GroupAnalyticsModelCopyWithImpl<$Res, $Val extends GroupAnalyticsModel>
    implements $GroupAnalyticsModelCopyWith<$Res> {
  _$GroupAnalyticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? currency = null,
    Object? totalExpensesAmount = null,
    Object? totalExpenseCount = null,
    Object? totalSettlementsAmount = null,
    Object? settlementRate = null,
    Object? averageExpenseAmount = null,
    Object? largestExpenseAmount = null,
    Object? largestExpenseTitle = freezed,
    Object? topSpenderName = freezed,
    Object? members = null,
    Object? monthlySpending = null,
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
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            totalExpensesAmount: null == totalExpensesAmount
                ? _value.totalExpensesAmount
                : totalExpensesAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            totalExpenseCount: null == totalExpenseCount
                ? _value.totalExpenseCount
                : totalExpenseCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSettlementsAmount: null == totalSettlementsAmount
                ? _value.totalSettlementsAmount
                : totalSettlementsAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            settlementRate: null == settlementRate
                ? _value.settlementRate
                : settlementRate // ignore: cast_nullable_to_non_nullable
                      as String,
            averageExpenseAmount: null == averageExpenseAmount
                ? _value.averageExpenseAmount
                : averageExpenseAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            largestExpenseAmount: null == largestExpenseAmount
                ? _value.largestExpenseAmount
                : largestExpenseAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            largestExpenseTitle: freezed == largestExpenseTitle
                ? _value.largestExpenseTitle
                : largestExpenseTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            topSpenderName: freezed == topSpenderName
                ? _value.topSpenderName
                : topSpenderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<MemberContributionModel>,
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
abstract class _$$GroupAnalyticsModelImplCopyWith<$Res>
    implements $GroupAnalyticsModelCopyWith<$Res> {
  factory _$$GroupAnalyticsModelImplCopyWith(
    _$GroupAnalyticsModelImpl value,
    $Res Function(_$GroupAnalyticsModelImpl) then,
  ) = __$$GroupAnalyticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'group_name') String groupName,
    String currency,
    @JsonKey(name: 'total_expenses_amount') String totalExpensesAmount,
    @JsonKey(name: 'total_expense_count') int totalExpenseCount,
    @JsonKey(name: 'total_settlements_amount') String totalSettlementsAmount,
    @JsonKey(name: 'settlement_rate') String settlementRate,
    @JsonKey(name: 'average_expense_amount') String averageExpenseAmount,
    @JsonKey(name: 'largest_expense_amount') String largestExpenseAmount,
    @JsonKey(name: 'largest_expense_title') String? largestExpenseTitle,
    @JsonKey(name: 'top_spender_name') String? topSpenderName,
    List<MemberContributionModel> members,
    @JsonKey(name: 'monthly_spending')
    List<MonthlySpendingModel> monthlySpending,
  });
}

/// @nodoc
class __$$GroupAnalyticsModelImplCopyWithImpl<$Res>
    extends _$GroupAnalyticsModelCopyWithImpl<$Res, _$GroupAnalyticsModelImpl>
    implements _$$GroupAnalyticsModelImplCopyWith<$Res> {
  __$$GroupAnalyticsModelImplCopyWithImpl(
    _$GroupAnalyticsModelImpl _value,
    $Res Function(_$GroupAnalyticsModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? currency = null,
    Object? totalExpensesAmount = null,
    Object? totalExpenseCount = null,
    Object? totalSettlementsAmount = null,
    Object? settlementRate = null,
    Object? averageExpenseAmount = null,
    Object? largestExpenseAmount = null,
    Object? largestExpenseTitle = freezed,
    Object? topSpenderName = freezed,
    Object? members = null,
    Object? monthlySpending = null,
  }) {
    return _then(
      _$GroupAnalyticsModelImpl(
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        totalExpensesAmount: null == totalExpensesAmount
            ? _value.totalExpensesAmount
            : totalExpensesAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        totalExpenseCount: null == totalExpenseCount
            ? _value.totalExpenseCount
            : totalExpenseCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSettlementsAmount: null == totalSettlementsAmount
            ? _value.totalSettlementsAmount
            : totalSettlementsAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        settlementRate: null == settlementRate
            ? _value.settlementRate
            : settlementRate // ignore: cast_nullable_to_non_nullable
                  as String,
        averageExpenseAmount: null == averageExpenseAmount
            ? _value.averageExpenseAmount
            : averageExpenseAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        largestExpenseAmount: null == largestExpenseAmount
            ? _value.largestExpenseAmount
            : largestExpenseAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        largestExpenseTitle: freezed == largestExpenseTitle
            ? _value.largestExpenseTitle
            : largestExpenseTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        topSpenderName: freezed == topSpenderName
            ? _value.topSpenderName
            : topSpenderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberContributionModel>,
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
class _$GroupAnalyticsModelImpl extends _GroupAnalyticsModel {
  const _$GroupAnalyticsModelImpl({
    @JsonKey(name: 'group_id') required this.groupId,
    @JsonKey(name: 'group_name') required this.groupName,
    required this.currency,
    @JsonKey(name: 'total_expenses_amount') required this.totalExpensesAmount,
    @JsonKey(name: 'total_expense_count') required this.totalExpenseCount,
    @JsonKey(name: 'total_settlements_amount')
    required this.totalSettlementsAmount,
    @JsonKey(name: 'settlement_rate') required this.settlementRate,
    @JsonKey(name: 'average_expense_amount') required this.averageExpenseAmount,
    @JsonKey(name: 'largest_expense_amount') required this.largestExpenseAmount,
    @JsonKey(name: 'largest_expense_title') this.largestExpenseTitle,
    @JsonKey(name: 'top_spender_name') this.topSpenderName,
    required final List<MemberContributionModel> members,
    @JsonKey(name: 'monthly_spending')
    required final List<MonthlySpendingModel> monthlySpending,
  }) : _members = members,
       _monthlySpending = monthlySpending,
       super._();

  factory _$GroupAnalyticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupAnalyticsModelImplFromJson(json);

  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'group_name')
  final String groupName;
  @override
  final String currency;
  @override
  @JsonKey(name: 'total_expenses_amount')
  final String totalExpensesAmount;
  @override
  @JsonKey(name: 'total_expense_count')
  final int totalExpenseCount;
  @override
  @JsonKey(name: 'total_settlements_amount')
  final String totalSettlementsAmount;
  @override
  @JsonKey(name: 'settlement_rate')
  final String settlementRate;
  @override
  @JsonKey(name: 'average_expense_amount')
  final String averageExpenseAmount;
  @override
  @JsonKey(name: 'largest_expense_amount')
  final String largestExpenseAmount;
  @override
  @JsonKey(name: 'largest_expense_title')
  final String? largestExpenseTitle;
  @override
  @JsonKey(name: 'top_spender_name')
  final String? topSpenderName;
  final List<MemberContributionModel> _members;
  @override
  List<MemberContributionModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
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
    return 'GroupAnalyticsModel(groupId: $groupId, groupName: $groupName, currency: $currency, totalExpensesAmount: $totalExpensesAmount, totalExpenseCount: $totalExpenseCount, totalSettlementsAmount: $totalSettlementsAmount, settlementRate: $settlementRate, averageExpenseAmount: $averageExpenseAmount, largestExpenseAmount: $largestExpenseAmount, largestExpenseTitle: $largestExpenseTitle, topSpenderName: $topSpenderName, members: $members, monthlySpending: $monthlySpending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupAnalyticsModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.totalExpensesAmount, totalExpensesAmount) ||
                other.totalExpensesAmount == totalExpensesAmount) &&
            (identical(other.totalExpenseCount, totalExpenseCount) ||
                other.totalExpenseCount == totalExpenseCount) &&
            (identical(other.totalSettlementsAmount, totalSettlementsAmount) ||
                other.totalSettlementsAmount == totalSettlementsAmount) &&
            (identical(other.settlementRate, settlementRate) ||
                other.settlementRate == settlementRate) &&
            (identical(other.averageExpenseAmount, averageExpenseAmount) ||
                other.averageExpenseAmount == averageExpenseAmount) &&
            (identical(other.largestExpenseAmount, largestExpenseAmount) ||
                other.largestExpenseAmount == largestExpenseAmount) &&
            (identical(other.largestExpenseTitle, largestExpenseTitle) ||
                other.largestExpenseTitle == largestExpenseTitle) &&
            (identical(other.topSpenderName, topSpenderName) ||
                other.topSpenderName == topSpenderName) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(
              other._monthlySpending,
              _monthlySpending,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    groupName,
    currency,
    totalExpensesAmount,
    totalExpenseCount,
    totalSettlementsAmount,
    settlementRate,
    averageExpenseAmount,
    largestExpenseAmount,
    largestExpenseTitle,
    topSpenderName,
    const DeepCollectionEquality().hash(_members),
    const DeepCollectionEquality().hash(_monthlySpending),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupAnalyticsModelImplCopyWith<_$GroupAnalyticsModelImpl> get copyWith =>
      __$$GroupAnalyticsModelImplCopyWithImpl<_$GroupAnalyticsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupAnalyticsModelImplToJson(this);
  }
}

abstract class _GroupAnalyticsModel extends GroupAnalyticsModel {
  const factory _GroupAnalyticsModel({
    @JsonKey(name: 'group_id') required final String groupId,
    @JsonKey(name: 'group_name') required final String groupName,
    required final String currency,
    @JsonKey(name: 'total_expenses_amount')
    required final String totalExpensesAmount,
    @JsonKey(name: 'total_expense_count') required final int totalExpenseCount,
    @JsonKey(name: 'total_settlements_amount')
    required final String totalSettlementsAmount,
    @JsonKey(name: 'settlement_rate') required final String settlementRate,
    @JsonKey(name: 'average_expense_amount')
    required final String averageExpenseAmount,
    @JsonKey(name: 'largest_expense_amount')
    required final String largestExpenseAmount,
    @JsonKey(name: 'largest_expense_title') final String? largestExpenseTitle,
    @JsonKey(name: 'top_spender_name') final String? topSpenderName,
    required final List<MemberContributionModel> members,
    @JsonKey(name: 'monthly_spending')
    required final List<MonthlySpendingModel> monthlySpending,
  }) = _$GroupAnalyticsModelImpl;
  const _GroupAnalyticsModel._() : super._();

  factory _GroupAnalyticsModel.fromJson(Map<String, dynamic> json) =
      _$GroupAnalyticsModelImpl.fromJson;

  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'group_name')
  String get groupName;
  @override
  String get currency;
  @override
  @JsonKey(name: 'total_expenses_amount')
  String get totalExpensesAmount;
  @override
  @JsonKey(name: 'total_expense_count')
  int get totalExpenseCount;
  @override
  @JsonKey(name: 'total_settlements_amount')
  String get totalSettlementsAmount;
  @override
  @JsonKey(name: 'settlement_rate')
  String get settlementRate;
  @override
  @JsonKey(name: 'average_expense_amount')
  String get averageExpenseAmount;
  @override
  @JsonKey(name: 'largest_expense_amount')
  String get largestExpenseAmount;
  @override
  @JsonKey(name: 'largest_expense_title')
  String? get largestExpenseTitle;
  @override
  @JsonKey(name: 'top_spender_name')
  String? get topSpenderName;
  @override
  List<MemberContributionModel> get members;
  @override
  @JsonKey(name: 'monthly_spending')
  List<MonthlySpendingModel> get monthlySpending;
  @override
  @JsonKey(ignore: true)
  _$$GroupAnalyticsModelImplCopyWith<_$GroupAnalyticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
