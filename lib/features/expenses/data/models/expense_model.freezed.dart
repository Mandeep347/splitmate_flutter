// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_by_user_id')
  String get paidByUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_by_name')
  String get paidByName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  String get totalAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'split_type')
  String get splitType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  List<ExpenseParticipantModel> get participants =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
    ExpenseModel value,
    $Res Function(ExpenseModel) then,
  ) = _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'paid_by_user_id') String paidByUserId,
    @JsonKey(name: 'paid_by_name') String paidByName,
    String title,
    String? description,
    @JsonKey(name: 'total_amount') String totalAmount,
    String currency,
    @JsonKey(name: 'split_type') String splitType,
    String status,
    @JsonKey(name: 'created_at') String createdAt,
    List<ExpenseParticipantModel> participants,
  });
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? paidByUserId = null,
    Object? paidByName = null,
    Object? title = null,
    Object? description = freezed,
    Object? totalAmount = null,
    Object? currency = null,
    Object? splitType = null,
    Object? status = null,
    Object? createdAt = null,
    Object? participants = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String,
            paidByUserId: null == paidByUserId
                ? _value.paidByUserId
                : paidByUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            paidByName: null == paidByName
                ? _value.paidByName
                : paidByName // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            splitType: null == splitType
                ? _value.splitType
                : splitType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<ExpenseParticipantModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
    _$ExpenseModelImpl value,
    $Res Function(_$ExpenseModelImpl) then,
  ) = __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'group_id') String groupId,
    @JsonKey(name: 'paid_by_user_id') String paidByUserId,
    @JsonKey(name: 'paid_by_name') String paidByName,
    String title,
    String? description,
    @JsonKey(name: 'total_amount') String totalAmount,
    String currency,
    @JsonKey(name: 'split_type') String splitType,
    String status,
    @JsonKey(name: 'created_at') String createdAt,
    List<ExpenseParticipantModel> participants,
  });
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
    _$ExpenseModelImpl _value,
    $Res Function(_$ExpenseModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? paidByUserId = null,
    Object? paidByName = null,
    Object? title = null,
    Object? description = freezed,
    Object? totalAmount = null,
    Object? currency = null,
    Object? splitType = null,
    Object? status = null,
    Object? createdAt = null,
    Object? participants = null,
  }) {
    return _then(
      _$ExpenseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        paidByUserId: null == paidByUserId
            ? _value.paidByUserId
            : paidByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        paidByName: null == paidByName
            ? _value.paidByName
            : paidByName // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        splitType: null == splitType
            ? _value.splitType
            : splitType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<ExpenseParticipantModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseModelImpl extends _ExpenseModel {
  const _$ExpenseModelImpl({
    required this.id,
    @JsonKey(name: 'group_id') required this.groupId,
    @JsonKey(name: 'paid_by_user_id') required this.paidByUserId,
    @JsonKey(name: 'paid_by_name') required this.paidByName,
    required this.title,
    this.description,
    @JsonKey(name: 'total_amount') required this.totalAmount,
    required this.currency,
    @JsonKey(name: 'split_type') required this.splitType,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
    final List<ExpenseParticipantModel> participants = const [],
  }) : _participants = participants,
       super._();

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'paid_by_user_id')
  final String paidByUserId;
  @override
  @JsonKey(name: 'paid_by_name')
  final String paidByName;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  @override
  final String currency;
  @override
  @JsonKey(name: 'split_type')
  final String splitType;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  final List<ExpenseParticipantModel> _participants;
  @override
  @JsonKey()
  List<ExpenseParticipantModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, groupId: $groupId, paidByUserId: $paidByUserId, paidByName: $paidByName, title: $title, description: $description, totalAmount: $totalAmount, currency: $currency, splitType: $splitType, status: $status, createdAt: $createdAt, participants: $participants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.paidByUserId, paidByUserId) ||
                other.paidByUserId == paidByUserId) &&
            (identical(other.paidByName, paidByName) ||
                other.paidByName == paidByName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.splitType, splitType) ||
                other.splitType == splitType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    groupId,
    paidByUserId,
    paidByName,
    title,
    description,
    totalAmount,
    currency,
    splitType,
    status,
    createdAt,
    const DeepCollectionEquality().hash(_participants),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(this);
  }
}

abstract class _ExpenseModel extends ExpenseModel {
  const factory _ExpenseModel({
    required final String id,
    @JsonKey(name: 'group_id') required final String groupId,
    @JsonKey(name: 'paid_by_user_id') required final String paidByUserId,
    @JsonKey(name: 'paid_by_name') required final String paidByName,
    required final String title,
    final String? description,
    @JsonKey(name: 'total_amount') required final String totalAmount,
    required final String currency,
    @JsonKey(name: 'split_type') required final String splitType,
    required final String status,
    @JsonKey(name: 'created_at') required final String createdAt,
    final List<ExpenseParticipantModel> participants,
  }) = _$ExpenseModelImpl;
  const _ExpenseModel._() : super._();

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'paid_by_user_id')
  String get paidByUserId;
  @override
  @JsonKey(name: 'paid_by_name')
  String get paidByName;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'total_amount')
  String get totalAmount;
  @override
  String get currency;
  @override
  @JsonKey(name: 'split_type')
  String get splitType;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  List<ExpenseParticipantModel> get participants;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
