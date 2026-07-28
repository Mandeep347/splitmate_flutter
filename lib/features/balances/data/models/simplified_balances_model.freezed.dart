// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simplified_balances_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SimplifiedBalancesModel _$SimplifiedBalancesModelFromJson(
  Map<String, dynamic> json,
) {
  return _SimplifiedBalancesModel.fromJson(json);
}

/// @nodoc
mixin _$SimplifiedBalancesModel {
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<PairwiseBalanceModel> get transactions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SimplifiedBalancesModelCopyWith<SimplifiedBalancesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimplifiedBalancesModelCopyWith<$Res> {
  factory $SimplifiedBalancesModelCopyWith(
    SimplifiedBalancesModel value,
    $Res Function(SimplifiedBalancesModel) then,
  ) = _$SimplifiedBalancesModelCopyWithImpl<$Res, SimplifiedBalancesModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    String currency,
    List<PairwiseBalanceModel> transactions,
  });
}

/// @nodoc
class _$SimplifiedBalancesModelCopyWithImpl<
  $Res,
  $Val extends SimplifiedBalancesModel
>
    implements $SimplifiedBalancesModelCopyWith<$Res> {
  _$SimplifiedBalancesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? currency = null,
    Object? transactions = null,
  }) {
    return _then(
      _value.copyWith(
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<PairwiseBalanceModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SimplifiedBalancesModelImplCopyWith<$Res>
    implements $SimplifiedBalancesModelCopyWith<$Res> {
  factory _$$SimplifiedBalancesModelImplCopyWith(
    _$SimplifiedBalancesModelImpl value,
    $Res Function(_$SimplifiedBalancesModelImpl) then,
  ) = __$$SimplifiedBalancesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    String currency,
    List<PairwiseBalanceModel> transactions,
  });
}

/// @nodoc
class __$$SimplifiedBalancesModelImplCopyWithImpl<$Res>
    extends
        _$SimplifiedBalancesModelCopyWithImpl<
          $Res,
          _$SimplifiedBalancesModelImpl
        >
    implements _$$SimplifiedBalancesModelImplCopyWith<$Res> {
  __$$SimplifiedBalancesModelImplCopyWithImpl(
    _$SimplifiedBalancesModelImpl _value,
    $Res Function(_$SimplifiedBalancesModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? currency = null,
    Object? transactions = null,
  }) {
    return _then(
      _$SimplifiedBalancesModelImpl(
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<PairwiseBalanceModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SimplifiedBalancesModelImpl extends _SimplifiedBalancesModel {
  const _$SimplifiedBalancesModelImpl({
    @JsonKey(name: 'group_id') required this.groupId,
    required this.currency,
    required final List<PairwiseBalanceModel> transactions,
  }) : _transactions = transactions,
       super._();

  factory _$SimplifiedBalancesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimplifiedBalancesModelImplFromJson(json);

  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  final String currency;
  final List<PairwiseBalanceModel> _transactions;
  @override
  List<PairwiseBalanceModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'SimplifiedBalancesModel(groupId: $groupId, currency: $currency, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimplifiedBalancesModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    currency,
    const DeepCollectionEquality().hash(_transactions),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimplifiedBalancesModelImplCopyWith<_$SimplifiedBalancesModelImpl>
  get copyWith =>
      __$$SimplifiedBalancesModelImplCopyWithImpl<
        _$SimplifiedBalancesModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimplifiedBalancesModelImplToJson(this);
  }
}

abstract class _SimplifiedBalancesModel extends SimplifiedBalancesModel {
  const factory _SimplifiedBalancesModel({
    @JsonKey(name: 'group_id') required final String groupId,
    required final String currency,
    required final List<PairwiseBalanceModel> transactions,
  }) = _$SimplifiedBalancesModelImpl;
  const _SimplifiedBalancesModel._() : super._();

  factory _SimplifiedBalancesModel.fromJson(Map<String, dynamic> json) =
      _$SimplifiedBalancesModelImpl.fromJson;

  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  String get currency;
  @override
  List<PairwiseBalanceModel> get transactions;
  @override
  @JsonKey(ignore: true)
  _$$SimplifiedBalancesModelImplCopyWith<_$SimplifiedBalancesModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
