// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_expenses_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedExpensesModel _$PaginatedExpensesModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedExpensesModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedExpensesModel {
  List<ExpenseModel> get items => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginatedExpensesModelCopyWith<PaginatedExpensesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedExpensesModelCopyWith<$Res> {
  factory $PaginatedExpensesModelCopyWith(
    PaginatedExpensesModel value,
    $Res Function(PaginatedExpensesModel) then,
  ) = _$PaginatedExpensesModelCopyWithImpl<$Res, PaginatedExpensesModel>;
  @useResult
  $Res call({
    List<ExpenseModel> items,
    int page,
    int limit,
    @JsonKey(name: 'total_pages') int totalPages,
    @JsonKey(name: 'total_items') int totalItems,
  });
}

/// @nodoc
class _$PaginatedExpensesModelCopyWithImpl<
  $Res,
  $Val extends PaginatedExpensesModel
>
    implements $PaginatedExpensesModelCopyWith<$Res> {
  _$PaginatedExpensesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
    Object? totalItems = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ExpenseModel>,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            totalItems: null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedExpensesModelImplCopyWith<$Res>
    implements $PaginatedExpensesModelCopyWith<$Res> {
  factory _$$PaginatedExpensesModelImplCopyWith(
    _$PaginatedExpensesModelImpl value,
    $Res Function(_$PaginatedExpensesModelImpl) then,
  ) = __$$PaginatedExpensesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ExpenseModel> items,
    int page,
    int limit,
    @JsonKey(name: 'total_pages') int totalPages,
    @JsonKey(name: 'total_items') int totalItems,
  });
}

/// @nodoc
class __$$PaginatedExpensesModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedExpensesModelCopyWithImpl<$Res, _$PaginatedExpensesModelImpl>
    implements _$$PaginatedExpensesModelImplCopyWith<$Res> {
  __$$PaginatedExpensesModelImplCopyWithImpl(
    _$PaginatedExpensesModelImpl _value,
    $Res Function(_$PaginatedExpensesModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
    Object? totalItems = null,
  }) {
    return _then(
      _$PaginatedExpensesModelImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ExpenseModel>,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        totalItems: null == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedExpensesModelImpl extends _PaginatedExpensesModel {
  const _$PaginatedExpensesModelImpl({
    required final List<ExpenseModel> items,
    required this.page,
    required this.limit,
    @JsonKey(name: 'total_pages') required this.totalPages,
    @JsonKey(name: 'total_items') required this.totalItems,
  }) : _items = items,
       super._();

  factory _$PaginatedExpensesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedExpensesModelImplFromJson(json);

  final List<ExpenseModel> _items;
  @override
  List<ExpenseModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int page;
  @override
  final int limit;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'total_items')
  final int totalItems;

  @override
  String toString() {
    return 'PaginatedExpensesModel(items: $items, page: $page, limit: $limit, totalPages: $totalPages, totalItems: $totalItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedExpensesModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    page,
    limit,
    totalPages,
    totalItems,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedExpensesModelImplCopyWith<_$PaginatedExpensesModelImpl>
  get copyWith =>
      __$$PaginatedExpensesModelImplCopyWithImpl<_$PaginatedExpensesModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedExpensesModelImplToJson(this);
  }
}

abstract class _PaginatedExpensesModel extends PaginatedExpensesModel {
  const factory _PaginatedExpensesModel({
    required final List<ExpenseModel> items,
    required final int page,
    required final int limit,
    @JsonKey(name: 'total_pages') required final int totalPages,
    @JsonKey(name: 'total_items') required final int totalItems,
  }) = _$PaginatedExpensesModelImpl;
  const _PaginatedExpensesModel._() : super._();

  factory _PaginatedExpensesModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedExpensesModelImpl.fromJson;

  @override
  List<ExpenseModel> get items;
  @override
  int get page;
  @override
  int get limit;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(ignore: true)
  _$$PaginatedExpensesModelImplCopyWith<_$PaginatedExpensesModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
