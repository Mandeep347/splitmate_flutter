// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairwise_balance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PairwiseBalanceModel _$PairwiseBalanceModelFromJson(Map<String, dynamic> json) {
  return _PairwiseBalanceModel.fromJson(json);
}

/// @nodoc
mixin _$PairwiseBalanceModel {
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PairwiseBalanceModelCopyWith<PairwiseBalanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairwiseBalanceModelCopyWith<$Res> {
  factory $PairwiseBalanceModelCopyWith(
    PairwiseBalanceModel value,
    $Res Function(PairwiseBalanceModel) then,
  ) = _$PairwiseBalanceModelCopyWithImpl<$Res, PairwiseBalanceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'from_user_id') String fromUserId,
    @JsonKey(name: 'from_user_name') String fromUserName,
    @JsonKey(name: 'to_user_id') String toUserId,
    @JsonKey(name: 'to_user_name') String toUserName,
    String amount,
    String currency,
  });
}

/// @nodoc
class _$PairwiseBalanceModelCopyWithImpl<
  $Res,
  $Val extends PairwiseBalanceModel
>
    implements $PairwiseBalanceModelCopyWith<$Res> {
  _$PairwiseBalanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromUserId = null,
    Object? fromUserName = null,
    Object? toUserId = null,
    Object? toUserName = null,
    Object? amount = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairwiseBalanceModelImplCopyWith<$Res>
    implements $PairwiseBalanceModelCopyWith<$Res> {
  factory _$$PairwiseBalanceModelImplCopyWith(
    _$PairwiseBalanceModelImpl value,
    $Res Function(_$PairwiseBalanceModelImpl) then,
  ) = __$$PairwiseBalanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'from_user_id') String fromUserId,
    @JsonKey(name: 'from_user_name') String fromUserName,
    @JsonKey(name: 'to_user_id') String toUserId,
    @JsonKey(name: 'to_user_name') String toUserName,
    String amount,
    String currency,
  });
}

/// @nodoc
class __$$PairwiseBalanceModelImplCopyWithImpl<$Res>
    extends _$PairwiseBalanceModelCopyWithImpl<$Res, _$PairwiseBalanceModelImpl>
    implements _$$PairwiseBalanceModelImplCopyWith<$Res> {
  __$$PairwiseBalanceModelImplCopyWithImpl(
    _$PairwiseBalanceModelImpl _value,
    $Res Function(_$PairwiseBalanceModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromUserId = null,
    Object? fromUserName = null,
    Object? toUserId = null,
    Object? toUserName = null,
    Object? amount = null,
    Object? currency = null,
  }) {
    return _then(
      _$PairwiseBalanceModelImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PairwiseBalanceModelImpl extends _PairwiseBalanceModel {
  const _$PairwiseBalanceModelImpl({
    @JsonKey(name: 'from_user_id') required this.fromUserId,
    @JsonKey(name: 'from_user_name') required this.fromUserName,
    @JsonKey(name: 'to_user_id') required this.toUserId,
    @JsonKey(name: 'to_user_name') required this.toUserName,
    required this.amount,
    required this.currency,
  }) : super._();

  factory _$PairwiseBalanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairwiseBalanceModelImplFromJson(json);

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
  String toString() {
    return 'PairwiseBalanceModel(fromUserId: $fromUserId, fromUserName: $fromUserName, toUserId: $toUserId, toUserName: $toUserName, amount: $amount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairwiseBalanceModelImpl &&
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
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fromUserId,
    fromUserName,
    toUserId,
    toUserName,
    amount,
    currency,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairwiseBalanceModelImplCopyWith<_$PairwiseBalanceModelImpl>
  get copyWith =>
      __$$PairwiseBalanceModelImplCopyWithImpl<_$PairwiseBalanceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PairwiseBalanceModelImplToJson(this);
  }
}

abstract class _PairwiseBalanceModel extends PairwiseBalanceModel {
  const factory _PairwiseBalanceModel({
    @JsonKey(name: 'from_user_id') required final String fromUserId,
    @JsonKey(name: 'from_user_name') required final String fromUserName,
    @JsonKey(name: 'to_user_id') required final String toUserId,
    @JsonKey(name: 'to_user_name') required final String toUserName,
    required final String amount,
    required final String currency,
  }) = _$PairwiseBalanceModelImpl;
  const _PairwiseBalanceModel._() : super._();

  factory _PairwiseBalanceModel.fromJson(Map<String, dynamic> json) =
      _$PairwiseBalanceModelImpl.fromJson;

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
  @JsonKey(ignore: true)
  _$$PairwiseBalanceModelImplCopyWith<_$PairwiseBalanceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
