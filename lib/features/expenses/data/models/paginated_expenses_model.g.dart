// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_expenses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedExpensesModelImpl _$$PaginatedExpensesModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedExpensesModelImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
  totalItems: (json['total_items'] as num).toInt(),
);

Map<String, dynamic> _$$PaginatedExpensesModelImplToJson(
  _$PaginatedExpensesModelImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'limit': instance.limit,
  'total_pages': instance.totalPages,
  'total_items': instance.totalItems,
};
