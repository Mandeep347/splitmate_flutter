// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseParticipantModel _$ExpenseParticipantModelFromJson(
  Map<String, dynamic> json,
) {
  return _ExpenseParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseParticipantModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'owed_amount')
  String get owedAmount => throw _privateConstructorUsedError;
  String? get percentage => throw _privateConstructorUsedError;
  int? get shares => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseParticipantModelCopyWith<ExpenseParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseParticipantModelCopyWith<$Res> {
  factory $ExpenseParticipantModelCopyWith(
    ExpenseParticipantModel value,
    $Res Function(ExpenseParticipantModel) then,
  ) = _$ExpenseParticipantModelCopyWithImpl<$Res, ExpenseParticipantModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String name,
    @JsonKey(name: 'owed_amount') String owedAmount,
    String? percentage,
    int? shares,
  });
}

/// @nodoc
class _$ExpenseParticipantModelCopyWithImpl<
  $Res,
  $Val extends ExpenseParticipantModel
>
    implements $ExpenseParticipantModelCopyWith<$Res> {
  _$ExpenseParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? owedAmount = null,
    Object? percentage = freezed,
    Object? shares = freezed,
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
            owedAmount: null == owedAmount
                ? _value.owedAmount
                : owedAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            percentage: freezed == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as String?,
            shares: freezed == shares
                ? _value.shares
                : shares // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseParticipantModelImplCopyWith<$Res>
    implements $ExpenseParticipantModelCopyWith<$Res> {
  factory _$$ExpenseParticipantModelImplCopyWith(
    _$ExpenseParticipantModelImpl value,
    $Res Function(_$ExpenseParticipantModelImpl) then,
  ) = __$$ExpenseParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String name,
    @JsonKey(name: 'owed_amount') String owedAmount,
    String? percentage,
    int? shares,
  });
}

/// @nodoc
class __$$ExpenseParticipantModelImplCopyWithImpl<$Res>
    extends
        _$ExpenseParticipantModelCopyWithImpl<
          $Res,
          _$ExpenseParticipantModelImpl
        >
    implements _$$ExpenseParticipantModelImplCopyWith<$Res> {
  __$$ExpenseParticipantModelImplCopyWithImpl(
    _$ExpenseParticipantModelImpl _value,
    $Res Function(_$ExpenseParticipantModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? owedAmount = null,
    Object? percentage = freezed,
    Object? shares = freezed,
  }) {
    return _then(
      _$ExpenseParticipantModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        owedAmount: null == owedAmount
            ? _value.owedAmount
            : owedAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        percentage: freezed == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as String?,
        shares: freezed == shares
            ? _value.shares
            : shares // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseParticipantModelImpl extends _ExpenseParticipantModel {
  const _$ExpenseParticipantModelImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.name,
    @JsonKey(name: 'owed_amount') required this.owedAmount,
    this.percentage,
    this.shares,
  }) : super._();

  factory _$ExpenseParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseParticipantModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(name: 'owed_amount')
  final String owedAmount;
  @override
  final String? percentage;
  @override
  final int? shares;

  @override
  String toString() {
    return 'ExpenseParticipantModel(userId: $userId, name: $name, owedAmount: $owedAmount, percentage: $percentage, shares: $shares)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseParticipantModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owedAmount, owedAmount) ||
                other.owedAmount == owedAmount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.shares, shares) || other.shares == shares));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, name, owedAmount, percentage, shares);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseParticipantModelImplCopyWith<_$ExpenseParticipantModelImpl>
  get copyWith =>
      __$$ExpenseParticipantModelImplCopyWithImpl<
        _$ExpenseParticipantModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseParticipantModelImplToJson(this);
  }
}

abstract class _ExpenseParticipantModel extends ExpenseParticipantModel {
  const factory _ExpenseParticipantModel({
    @JsonKey(name: 'user_id') required final String userId,
    required final String name,
    @JsonKey(name: 'owed_amount') required final String owedAmount,
    final String? percentage,
    final int? shares,
  }) = _$ExpenseParticipantModelImpl;
  const _ExpenseParticipantModel._() : super._();

  factory _ExpenseParticipantModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseParticipantModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'owed_amount')
  String get owedAmount;
  @override
  String? get percentage;
  @override
  int? get shares;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseParticipantModelImplCopyWith<_$ExpenseParticipantModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
