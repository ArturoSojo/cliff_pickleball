import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/services/http/is_online_provider.dart';

import '../cacheService.dart';

@Injectable(as: IsOnlineProvider)
class CacheOnlineProvider implements IsOnlineProvider {
  final Cache _cache;

  CacheOnlineProvider(this._cache);

  @override
  Future<bool> isOnline() async {
    return await _cache.isOnline();
  }
}
