import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    String? groupId,
    required String name,
    @Default('') String icon,
    @Default('') String color,
    @Default(false) bool isSystem,
    @Default(false) bool isHidden,
    @Default(false) bool treatAsTransfer,
    @Default(false) bool isIgnored,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class CategoryGroup with _$CategoryGroup {
  const factory CategoryGroup({
    required String id,
    required String name,
    @Default('') String icon,
    @Default('') String color,
    @Default(0) int position,
    @Default(false) bool isSystem,
    @Default(false) bool isHidden,
    @Default(<Category>[]) List<Category> categories,
  }) = _CategoryGroup;

  factory CategoryGroup.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupFromJson(json);
}
