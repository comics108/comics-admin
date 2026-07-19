import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/admin_api_client.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/api_response.dart';
import '../../data/models/season_model.dart';
import '../../data/models/episode_model.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/models/piece_model.dart';
import '../../data/models/music_model.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/device_model.dart';
import 'auth_provider.dart';

// API Client provider
final apiClientProvider = Provider<AdminApiClient?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config == null || config.isMockMode) return null;
  return AdminApiClient(config.apiUrl!, config.authToken);
});

// Seasons
final seasonsProvider = FutureProvider<List<Season>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.seasons;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getSeasons();
});

// Episodes
final episodesProvider = FutureProvider.family<List<Episode>, int>((ref, seasonId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getEpisodes(seasonId);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getEpisodes(seasonId);
});

final allEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.allEpisodes;
  }
  final client = ref.watch(apiClientProvider);
  final seasons = await ref.watch(seasonsProvider.future);
  final episodes = <Episode>[];
  for (final season in seasons) {
    episodes.addAll(await client!.getEpisodes(season.id));
  }
  return episodes;
});

// Puzzles
final puzzlesProvider = FutureProvider.family<List<Puzzle>, int>((ref, episodeId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getPuzzles(episodeId);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getPuzzles(episodeId);
});

// Pieces
final piecesProvider = FutureProvider.family<List<Piece>, int>((ref, puzzleId) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getPieces(puzzleId);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getPieces(puzzleId);
});

// Music
final musicProvider = FutureProvider<List<Music>>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.music;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getMusic();
});

// Quotes
class QuoteQuery {
  final QuoteStatus? status;

  QuoteQuery({this.status});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteQuery &&
          runtimeType == other.runtimeType &&
          status == other.status;

  @override
  int get hashCode => status.hashCode;
}

final quotesProvider = FutureProvider.family<List<Quote>, QuoteQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    final quotes = MockData.quotes;
    if (query.status == null) return quotes;
    return quotes.where((q) => q.status == query.status).toList();
  }
  final client = ref.watch(apiClientProvider);
  return client!.getQuotes(status: query.status?.name);
});

final allQuotesProvider = FutureProvider<List<Quote>>((ref) async {
  return ref.watch(quotesProvider(QuoteQuery()).future);
});

// Devices
class DeviceQuery {
  final String? platform;
  final int page;
  final int limit;

  DeviceQuery({this.platform, this.page = 1, this.limit = 50});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceQuery &&
          runtimeType == other.runtimeType &&
          platform == other.platform &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => (platform?.hashCode ?? 0) ^ page.hashCode ^ limit.hashCode;
}

final devicesProvider = FutureProvider.family<PaginatedResponse<Device>, DeviceQuery>((ref, query) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.getDevices(platform: query.platform, page: query.page, limit: query.limit);
  }
  final client = ref.watch(apiClientProvider);
  return client!.getDevices(platform: query.platform, page: query.page, limit: query.limit);
});

final deviceStatsProvider = FutureProvider<DeviceStats>((ref) async {
  final config = ref.watch(appConfigProvider);
  if (config?.isMockMode ?? true) {
    return MockData.deviceStats;
  }
  final client = ref.watch(apiClientProvider);
  return client!.getDeviceStats();
});

// Selected filters state
final selectedSeasonIdProvider = StateProvider<int?>((ref) => null);
final selectedEpisodeIdProvider = StateProvider<int?>((ref) => null);
final selectedPuzzleIdProvider = StateProvider<int?>((ref) => null);
