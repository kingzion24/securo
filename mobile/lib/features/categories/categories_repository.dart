import '../../core/api/api_client.dart';
import '../../models/category.dart';

class CategoriesRepository {
  CategoriesRepository(this._api);
  final ApiClient _api;

  Future<List<Category>> list() async {
    final data = await _api.get<List<dynamic>>('/categories');
    return data
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .where((c) => !c.isHidden)
        .toList();
  }

  Future<Category> create({
    required String name,
    required String icon,
    required String color,
    bool treatAsTransfer = false,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/categories',
      body: {
        'name': name,
        'icon': icon,
        'color': color,
        'treat_as_transfer': treatAsTransfer,
      },
    );
    return Category.fromJson(data);
  }

  Future<Category> update(
    String id, {
    String? name,
    String? icon,
    String? color,
  }) async {
    final data = await _api.patch<Map<String, dynamic>>(
      '/categories/$id',
      body: {
        'name': ?name,
        'icon': ?icon,
        'color': ?color,
      },
    );
    return Category.fromJson(data);
  }

  Future<void> delete(String id) => _api.delete<dynamic>('/categories/$id');
}
