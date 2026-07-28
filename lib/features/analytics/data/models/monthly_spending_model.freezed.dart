// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_spending_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MonthlySpendingModel _$MonthlySpendingModelFromJson(Map<String, dynamic> json) {
  return _MonthlySpendingModel.fromJson(json);
}

/// @nodoc
mixin _$MonthlySpendingModel {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'month_label')
  String get monthLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  String get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_count')
  int get expenseCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonthlySpendingModelCopyWith<MonthlySpendingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlySpendingModelCopyWith<$Res> {
  factory $MonthlySpendingModelCopyWith(
    MonthlySpendingModel value,
    $Res Function(MonthlySpendingModel) then,
  ) = _$MonthlySpendingModelCopyWithImpl<$Res, MonthlySpendingModel>;
  @useResult
  $Res call({
    int year,
    int month,
    @JsonKey(name: 'month_label') String monthLabel,
    @JsonKey(name: 'total_amount') String totalAmount,
    @JsonKey(name: 'expense_count') int expenseCount,
  });
}

/// @nodoc
class _$MonthlySpendingModelCopyWithImpl<
  $Res,
  $Val extends MonthlySpendingModel
>
    implements $MonthlySpendingModelCopyWith<$Res> {
  _$MonthlySpendingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? monthLabel = null,
    Object? totalAmount = null,
    Object? expenseCount = null,
  }) {
    return _then(
      _value.copyWith(
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int,
            monthLabel: null == monthLabel
                ? _value.monthLabel
                : monthLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            expenseCount: null == expenseCount
                ? _value.expenseCount
                : expenseCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthlySpendingModelImplCopyWith<$Res>
    implements $MonthlySpendingModelCopyWith<$Res> {
  factory _$$MonthlySpendingModelImplCopyWith(
    _$MonthlySpendingModelImpl value,
    $Res Function(_$MonthlySpendingModelImpl) then,
  ) = __$$MonthlySpendingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int year,
    int month,
    @JsonKey(name: 'month_label') String monthLabel,
    @JsonKey(name: 'total_amount') String totalAmount,
    @JsonKey(name: 'expense_count') int expenseCount,
  });
}

/// @nodoc
class __$$MonthlySpendingModelImplCopyWithImpl<$Res>
    extends _$MonthlySpendingModelCopyWithImpl<$Res, _$MonthlySpendingModelImpl>
    implements _$$MonthlySpendingModelImplCopyWith<$Res> {
  __$$MonthlySpendingModelImplCopyWithImpl(
    _$MonthlySpendingModelImpl _value,
    $Res Function(_$MonthlySpendingModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? monthLabel = null,
    Object? totalAmount = null,
    Object? expenseCount = null,
  }) {
    return _then(
      _$MonthlySpendingModelImpl(
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int,
        monthLabel: null == monthLabel
            ? _value.monthLabel
            : monthLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        expenseCount: null == expenseCount
            ? _value.expenseCount
            : expenseCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlySpendingModelImpl extends _MonthlySpendingModel {
  const _$MonthlySpendingModelImpl({
    required this.year,
    required this.month,
    @JsonKey(name: 'month_label') required this.monthLabel,
    @JsonKey(name: 'total_amount') required this.totalAmount,
    @JsonKey(name: 'expense_count') required this.expenseCount,
  }) : super._();

  factory _$MonthlySpendingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlySpendingModelImplFromJson(json);

  @override
  final int year;
  @override
  final int month;
  @override
  @JsonKey(name: 'month_label')
  final String monthLabel;
  @override
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  @override
  @JsonKey(name: 'expense_count')
  final int expenseCount;

  @override
  String toString() {
    return 'MonthlySpendingModel(year: $year, month: $month, monthLabel: $monthLabel, totalAmount: $totalAmount, expenseCount: $expenseCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlySpendingModelImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.monthLabel, monthLabel) ||
                other.monthLabel == monthLabel) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.expenseCount, expenseCount) ||
                other.expenseCount == expenseCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    year,
    month,
    monthLabel,
    totalAmount,
    expenseCount,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlySpendingModelImplCopyWith<_$MonthlySpendingModelImpl>
  get copyWith =>
      __$$MonthlySpendingModelImplCopyWithImpl<_$MonthlySpendingModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlySpendingModelImplToJson(this);
  }
}

abstract class _MonthlySpendingModel extends MonthlySpendingModel {
  const factory _MonthlySpendingModel({
    required final int year,
    required final int month,
    @JsonKey(name: 'month_label') required final String monthLabel,
    @JsonKey(name: 'total_amount') required final String totalAmount,
    @JsonKey(name: 'expense_count') required final int expenseCount,
  }) = _$MonthlySpendingModelImpl;
  const _MonthlySpendingModel._() : super._();

  factory _MonthlySpendingModel.fromJson(Map<String, dynamic> json) =
      _$MonthlySpendingModelImpl.fromJson;

  @override
  int get year;
  @override
  int get month;
  @override
  @JsonKey(name: 'month_label')
  String get monthLabel;
  @override
  @JsonKey(name: 'total_amount')
  String get totalAmount;
  @override
  @JsonKey(name: 'expense_count')
  int get expenseCount;
  @override
  @JsonKey(ignore: true)
  _$$MonthlySpendingModelImplCopyWith<_$MonthlySpendingModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
