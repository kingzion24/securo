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
}
