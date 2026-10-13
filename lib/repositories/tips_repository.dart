import '../models/tip_model.dart';
import '../services/api_service.dart';

class TipsRepository {
  TipsRepository(this._api);

  final ApiService _api;

  Future<List<TipModel>> getTips() async {
    final data = await _api.getList('/posts', query: {'_limit': 5});
    return data
        .map((e) => TipModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
