// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_contribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemberContributionModel _$MemberContributionModelFromJson(
  Map<String, dynamic> json,
) {
  return _MemberContributionModel.fromJson(json);
}

/// @nodoc
mixin _$MemberContributionModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_paid')
  String get totalPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_owed')
  String get totalOwed => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_balance')
  String get netBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_count')
  int get expenseCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'percentage_of_total')
  String get percentageOfTotal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemberContributionModelCopyWith<MemberContributionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberContributionModelCopyWith<$Res> {
  factory $MemberContributionModelCopyWith(
    MemberContributionModel value,
    $Res Function(MemberContributionModel) then,
  ) = _$MemberContributionModelCopyWithImpl<$Res, MemberContributionModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String name,
    @JsonKey(name: 'total_paid') String totalPaid,
    @JsonKey(name: 'total_owed') String totalOwed,
    @JsonKey(name: 'net_balance') String netBalance,
    @JsonKey(name: 'expense_count') int expenseCount,
    @JsonKey(name: 'percentage_of_total') String percentageOfTotal,
  });
}

/// @nodoc
class _$MemberContributionModelCopyWithImpl<
  $Res,
  $Val extends MemberContributionModel
>
    implements $MemberContributionModelCopyWith<$Res> {
  _$MemberContributionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? totalPaid = null,
    Object? totalOwed = null,
    Object? netBalance = null,
    Object? expenseCount = null,
    Object? percentageOfTotal = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPaid: null == totalPaid
                ? _value.totalPaid
                : totalPaid // ignore: cast_nullable_to_non_nullable
                      as String,
            totalOwed: null == totalOwed
                ? _value.totalOwed
                : totalOwed // ignore: cast_nullable_to_non_nullable
                      as String,
            netBalance: null == netBalance
                ? _value.netBalance
                : netBalance // ignore: cast_nullable_to_non_nullable
                      as String,
            expenseCount: null == expenseCount
                ? _value.expenseCount
                : expenseCount // ignore: cast_nullable_to_non_nullable
                      as int,
            percentageOfTotal: null == percentageOfTotal
                ? _value.percentageOfTotal
                : percentageOfTotal // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberContributionModelImplCopyWith<$Res>
    implements $MemberContributionModelCopyWith<$Res> {
  factory _$$MemberContributionModelImplCopyWith(
    _$MemberContributionModelImpl value,
    $Res Function(_$MemberContributionModelImpl) then,
  ) = __$$MemberContributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String name,
    @JsonKey(name: 'total_paid') String totalPaid,
    @JsonKey(name: 'total_owed') String totalOwed,
    @JsonKey(name: 'net_balance') String netBalance,
    @JsonKey(name: 'expense_count') int expenseCount,
    @JsonKey(name: 'percentage_of_total') String percentageOfTotal,
  });
}

/// @nodoc
class __$$MemberContributionModelImplCopyWithImpl<$Res>
    extends
        _$MemberContributionModelCopyWithImpl<
          $Res,
          _$MemberContributionModelImpl
        >
    implements _$$MemberContributionModelImplCopyWith<$Res> {
  __$$MemberContributionModelImplCopyWithImpl(
    _$MemberContributionModelImpl _value,
    $Res Function(_$MemberContributionModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? totalPaid = null,
    Object? totalOwed = null,
    Object? netBalance = null,
    Object? expenseCount = null,
    Object? percentageOfTotal = null,
  }) {
    return _then(
      _$MemberContributionModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPaid: null == totalPaid
            ? _value.totalPaid
            : totalPaid // ignore: cast_nullable_to_non_nullable
                  as String,
        totalOwed: null == totalOwed
            ? _value.totalOwed
            : totalOwed // ignore: cast_nullable_to_non_nullable
                  as String,
        netBalance: null == netBalance
            ? _value.netBalance
            : netBalance // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseCount: null == expenseCount
            ? _value.expenseCount
            : expenseCount // ignore: cast_nullable_to_non_nullable
                  as int,
        percentageOfTotal: null == percentageOfTotal
            ? _value.percentageOfTotal
            : percentageOfTotal // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberContributionModelImpl extends _MemberContributionModel {
  const _$MemberContributionModelImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.name,
    @JsonKey(name: 'total_paid') required this.totalPaid,
    @JsonKey(name: 'total_owed') required this.totalOwed,
    @JsonKey(name: 'net_balance') required this.netBalance,
    @JsonKey(name: 'expense_count') required this.expenseCount,
    @JsonKey(name: 'percentage_of_total') required this.percentageOfTotal,
  }) : super._();

  factory _$MemberContributionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberContributionModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'total_paid')
  final String totalPaid;
  @override
  @JsonKey(name: 'total_owed')
  final String totalOwed;
  @override
  @JsonKey(name: 'net_balance')
  final String netBalance;
  @override
  @JsonKey(name: 'expense_count')
  final int expenseCount;
  @override
  @JsonKey(name: 'percentage_of_total')
  final String percentageOfTotal;

  @override
  String toString() {
    return 'MemberContributionModel(userId: $userId, name: $name, totalPaid: $totalPaid, totalOwed: $totalOwed, netBalance: $netBalance, expenseCount: $expenseCount, percentageOfTotal: $percentageOfTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberContributionModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.totalOwed, totalOwed) ||
                other.totalOwed == totalOwed) &&
            (identical(other.netBalance, netBalance) ||
                other.netBalance == netBalance) &&
            (identical(other.expenseCount, expenseCount) ||
                other.expenseCount == expenseCount) &&
            (identical(other.percentageOfTotal, percentageOfTotal) ||
                other.percentageOfTotal == percentageOfTotal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    name,
    totalPaid,
    totalOwed,
    netBalance,
    expenseCount,
    percentageOfTotal,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberContributionModelImplCopyWith<_$MemberContributionModelImpl>
  get copyWith =>
      __$$MemberContributionModelImplCopyWithImpl<
        _$MemberContributionModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberContributionModelImplToJson(this);
  }
}

abstract class _MemberContributionModel extends MemberContributionModel {
  const factory _MemberContributionModel({
    @JsonKey(name: 'user_id') required final String userId,
    required final String name,
    @JsonKey(name: 'total_paid') required final String totalPaid,
    @JsonKey(name: 'total_owed') required final String totalOwed,
    @JsonKey(name: 'net_balance') required final String netBalance,
    @JsonKey(name: 'expense_count') required final int expenseCount,
    @JsonKey(name: 'percentage_of_total')
    required final String percentageOfTotal,
  }) = _$MemberContributionModelImpl;
  const _MemberContributionModel._() : super._();

  factory _MemberContributionModel.fromJson(Map<String, dynamic> json) =
      _$MemberContributionModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'total_paid')
  String get totalPaid;
  @override
  @JsonKey(name: 'total_owed')
  String get totalOwed;
  @override
  @JsonKey(name: 'net_balance')
  String get netBalance;
  @override
  @JsonKey(name: 'expense_count')
  int get expenseCount;
  @override
  @JsonKey(name: 'percentage_of_total')
  String get percentageOfTotal;
  @override
  @JsonKey(ignore: true)
  _$$MemberContributionModelImplCopyWith<_$MemberContributionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
