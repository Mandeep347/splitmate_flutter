// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_overall_balance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserOverallBalanceModel _$UserOverallBalanceModelFromJson(
  Map<String, dynamic> json,
) {
  return _UserOverallBalanceModel.fromJson(json);
}

/// @nodoc
mixin _$UserOverallBalanceModel {
  @JsonKey(name: 'counterpart_user_id')
  String get counterpartUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterpart_name')
  String get counterpartName => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_amount')
  String get netAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserOverallBalanceModelCopyWith<UserOverallBalanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserOverallBalanceModelCopyWith<$Res> {
  factory $UserOverallBalanceModelCopyWith(
    UserOverallBalanceModel value,
    $Res Function(UserOverallBalanceModel) then,
  ) = _$UserOverallBalanceModelCopyWithImpl<$Res, UserOverallBalanceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'counterpart_user_id') String counterpartUserId,
    @JsonKey(name: 'counterpart_name') String counterpartName,
    @JsonKey(name: 'net_amount') String netAmount,
    String currency,
  });
}

/// @nodoc
class _$UserOverallBalanceModelCopyWithImpl<
  $Res,
  $Val extends UserOverallBalanceModel
>
    implements $UserOverallBalanceModelCopyWith<$Res> {
  _$UserOverallBalanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartUserId = null,
    Object? counterpartName = null,
    Object? netAmount = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            counterpartUserId: null == counterpartUserId
                ? _value.counterpartUserId
                : counterpartUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            counterpartName: null == counterpartName
                ? _value.counterpartName
                : counterpartName // ignore: cast_nullable_to_non_nullable
                      as String,
            netAmount: null == netAmount
                ? _value.netAmount
                : netAmount // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$UserOverallBalanceModelImplCopyWith<$Res>
    implements $UserOverallBalanceModelCopyWith<$Res> {
  factory _$$UserOverallBalanceModelImplCopyWith(
    _$UserOverallBalanceModelImpl value,
    $Res Function(_$UserOverallBalanceModelImpl) then,
  ) = __$$UserOverallBalanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'counterpart_user_id') String counterpartUserId,
    @JsonKey(name: 'counterpart_name') String counterpartName,
    @JsonKey(name: 'net_amount') String netAmount,
    String currency,
  });
}

/// @nodoc
class __$$UserOverallBalanceModelImplCopyWithImpl<$Res>
    extends
        _$UserOverallBalanceModelCopyWithImpl<
          $Res,
          _$UserOverallBalanceModelImpl
        >
    implements _$$UserOverallBalanceModelImplCopyWith<$Res> {
  __$$UserOverallBalanceModelImplCopyWithImpl(
    _$UserOverallBalanceModelImpl _value,
    $Res Function(_$UserOverallBalanceModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartUserId = null,
    Object? counterpartName = null,
    Object? netAmount = null,
    Object? currency = null,
  }) {
    return _then(
      _$UserOverallBalanceModelImpl(
        counterpartUserId: null == counterpartUserId
            ? _value.counterpartUserId
            : counterpartUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        counterpartName: null == counterpartName
            ? _value.counterpartName
            : counterpartName // ignore: cast_nullable_to_non_nullable
                  as String,
        netAmount: null == netAmount
            ? _value.netAmount
            : netAmount // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$UserOverallBalanceModelImpl extends _UserOverallBalanceModel {
  const _$UserOverallBalanceModelImpl({
    @JsonKey(name: 'counterpart_user_id') required this.counterpartUserId,
    @JsonKey(name: 'counterpart_name') required this.counterpartName,
    @JsonKey(name: 'net_amount') required this.netAmount,
    required this.currency,
  }) : super._();

  factory _$UserOverallBalanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserOverallBalanceModelImplFromJson(json);

  @override
  @JsonKey(name: 'counterpart_user_id')
  final String counterpartUserId;
  @override
  @JsonKey(name: 'counterpart_name')
  final String counterpartName;
  @override
  @JsonKey(name: 'net_amount')
  final String netAmount;
  @override
  final String currency;

  @override
  String toString() {
    return 'UserOverallBalanceModel(counterpartUserId: $counterpartUserId, counterpartName: $counterpartName, netAmount: $netAmount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserOverallBalanceModelImpl &&
            (identical(other.counterpartUserId, counterpartUserId) ||
                other.counterpartUserId == counterpartUserId) &&
            (identical(other.counterpartName, counterpartName) ||
                other.counterpartName == counterpartName) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    counterpartUserId,
    counterpartName,
    netAmount,
    currency,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserOverallBalanceModelImplCopyWith<_$UserOverallBalanceModelImpl>
  get copyWith =>
      __$$UserOverallBalanceModelImplCopyWithImpl<
        _$UserOverallBalanceModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserOverallBalanceModelImplToJson(this);
  }
}

abstract class _UserOverallBalanceModel extends UserOverallBalanceModel {
  const factory _UserOverallBalanceModel({
    @JsonKey(name: 'counterpart_user_id')
    required final String counterpartUserId,
    @JsonKey(name: 'counterpart_name') required final String counterpartName,
    @JsonKey(name: 'net_amount') required final String netAmount,
    required final String currency,
  }) = _$UserOverallBalanceModelImpl;
  const _UserOverallBalanceModel._() : super._();

  factory _UserOverallBalanceModel.fromJson(Map<String, dynamic> json) =
      _$UserOverallBalanceModelImpl.fromJson;

  @override
  @JsonKey(name: 'counterpart_user_id')
  String get counterpartUserId;
  @override
  @JsonKey(name: 'counterpart_name')
  String get counterpartName;
  @override
  @JsonKey(name: 'net_amount')
  String get netAmount;
  @override
  String get currency;
  @override
  @JsonKey(ignore: true)
  _$$UserOverallBalanceModelImplCopyWith<_$UserOverallBalanceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
