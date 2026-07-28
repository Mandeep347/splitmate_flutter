// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_balances_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GroupBalancesModel _$GroupBalancesModelFromJson(Map<String, dynamic> json) {
  return _GroupBalancesModel.fromJson(json);
}

/// @nodoc
mixin _$GroupBalancesModel {
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<PairwiseBalanceModel> get balances => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupBalancesModelCopyWith<GroupBalancesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupBalancesModelCopyWith<$Res> {
  factory $GroupBalancesModelCopyWith(
    GroupBalancesModel value,
    $Res Function(GroupBalancesModel) then,
  ) = _$GroupBalancesModelCopyWithImpl<$Res, GroupBalancesModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    String currency,
    List<PairwiseBalanceModel> balances,
  });
}

/// @nodoc
class _$GroupBalancesModelCopyWithImpl<$Res, $Val extends GroupBalancesModel>
    implements $GroupBalancesModelCopyWith<$Res> {
  _$GroupBalancesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? currency = null,
    Object? balances = null,
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
            balances: null == balances
                ? _value.balances
                : balances // ignore: cast_nullable_to_non_nullable
                      as List<PairwiseBalanceModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupBalancesModelImplCopyWith<$Res>
    implements $GroupBalancesModelCopyWith<$Res> {
  factory _$$GroupBalancesModelImplCopyWith(
    _$GroupBalancesModelImpl value,
    $Res Function(_$GroupBalancesModelImpl) then,
  ) = __$$GroupBalancesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'group_id') String groupId,
    String currency,
    List<PairwiseBalanceModel> balances,
  });
}

/// @nodoc
class __$$GroupBalancesModelImplCopyWithImpl<$Res>
    extends _$GroupBalancesModelCopyWithImpl<$Res, _$GroupBalancesModelImpl>
    implements _$$GroupBalancesModelImplCopyWith<$Res> {
  __$$GroupBalancesModelImplCopyWithImpl(
    _$GroupBalancesModelImpl _value,
    $Res Function(_$GroupBalancesModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? currency = null,
    Object? balances = null,
  }) {
    return _then(
      _$GroupBalancesModelImpl(
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        balances: null == balances
            ? _value._balances
            : balances // ignore: cast_nullable_to_non_nullable
                  as List<PairwiseBalanceModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupBalancesModelImpl extends _GroupBalancesModel {
  const _$GroupBalancesModelImpl({
    @JsonKey(name: 'group_id') required this.groupId,
    required this.currency,
    required final List<PairwiseBalanceModel> balances,
  }) : _balances = balances,
       super._();

  factory _$GroupBalancesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupBalancesModelImplFromJson(json);

  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  final String currency;
  final List<PairwiseBalanceModel> _balances;
  @override
  List<PairwiseBalanceModel> get balances {
    if (_balances is EqualUnmodifiableListView) return _balances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_balances);
  }

  @override
  String toString() {
    return 'GroupBalancesModel(groupId: $groupId, currency: $currency, balances: $balances)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupBalancesModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._balances, _balances));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    currency,
    const DeepCollectionEquality().hash(_balances),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupBalancesModelImplCopyWith<_$GroupBalancesModelImpl> get copyWith =>
      __$$GroupBalancesModelImplCopyWithImpl<_$GroupBalancesModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupBalancesModelImplToJson(this);
  }
}

abstract class _GroupBalancesModel extends GroupBalancesModel {
  const factory _GroupBalancesModel({
    @JsonKey(name: 'group_id') required final String groupId,
    required final String currency,
    required final List<PairwiseBalanceModel> balances,
  }) = _$GroupBalancesModelImpl;
  const _GroupBalancesModel._() : super._();

  factory _GroupBalancesModel.fromJson(Map<String, dynamic> json) =
      _$GroupBalancesModelImpl.fromJson;

  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  String get currency;
  @override
  List<PairwiseBalanceModel> get balances;
  @override
  @JsonKey(ignore: true)
  _$$GroupBalancesModelImplCopyWith<_$GroupBalancesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
