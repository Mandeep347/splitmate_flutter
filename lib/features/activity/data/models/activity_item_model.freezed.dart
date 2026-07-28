// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityItemModel _$ActivityItemModelFromJson(Map<String, dynamic> json) {
  return _ActivityItemModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityItemModel {
  String get type => throw _privateConstructorUsedError;
  String get actor => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityItemModelCopyWith<ActivityItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityItemModelCopyWith<$Res> {
  factory $ActivityItemModelCopyWith(
    ActivityItemModel value,
    $Res Function(ActivityItemModel) then,
  ) = _$ActivityItemModelCopyWithImpl<$Res, ActivityItemModel>;
  @useResult
  $Res call({
    String type,
    String actor,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$ActivityItemModelCopyWithImpl<$Res, $Val extends ActivityItemModel>
    implements $ActivityItemModelCopyWith<$Res> {
  _$ActivityItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? actor = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            actor: null == actor
                ? _value.actor
                : actor // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityItemModelImplCopyWith<$Res>
    implements $ActivityItemModelCopyWith<$Res> {
  factory _$$ActivityItemModelImplCopyWith(
    _$ActivityItemModelImpl value,
    $Res Function(_$ActivityItemModelImpl) then,
  ) = __$$ActivityItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    String actor,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$ActivityItemModelImplCopyWithImpl<$Res>
    extends _$ActivityItemModelCopyWithImpl<$Res, _$ActivityItemModelImpl>
    implements _$$ActivityItemModelImplCopyWith<$Res> {
  __$$ActivityItemModelImplCopyWithImpl(
    _$ActivityItemModelImpl _value,
    $Res Function(_$ActivityItemModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? actor = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ActivityItemModelImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        actor: null == actor
            ? _value.actor
            : actor // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityItemModelImpl extends _ActivityItemModel {
  const _$ActivityItemModelImpl({
    required this.type,
    required this.actor,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : super._();

  factory _$ActivityItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityItemModelImplFromJson(json);

  @override
  final String type;
  @override
  final String actor;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'ActivityItemModel(type: $type, actor: $actor, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityItemModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, actor, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityItemModelImplCopyWith<_$ActivityItemModelImpl> get copyWith =>
      __$$ActivityItemModelImplCopyWithImpl<_$ActivityItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityItemModelImplToJson(this);
  }
}

abstract class _ActivityItemModel extends ActivityItemModel {
  const factory _ActivityItemModel({
    required final String type,
    required final String actor,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$ActivityItemModelImpl;
  const _ActivityItemModel._() : super._();

  factory _ActivityItemModel.fromJson(Map<String, dynamic> json) =
      _$ActivityItemModelImpl.fromJson;

  @override
  String get type;
  @override
  String get actor;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ActivityItemModelImplCopyWith<_$ActivityItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
