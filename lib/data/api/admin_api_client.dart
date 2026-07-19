import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/api_response.dart';
import '../models/season_model.dart';
import '../models/episode_model.dart';
import '../models/puzzle_model.dart';
import '../models/piece_model.dart';
import '../models/quote_model.dart';
import '../models/music_model.dart';
import '../models/notification_model.dart';
import '../models/device_model.dart';

class AdminApiClient {
  final Dio _dio;
  final String baseUrl;

  AdminApiClient(this.baseUrl, [String? authToken])
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // ============ AUTH ============
  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return ApiResponse.fromJson(response.data, (data) => data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResponse(success: false, error: e.message ?? 'Login failed');
    }
  }

  // ============ SEASONS ============
  Future<List<Season>> getSeasons() async {
    final response = await _dio.get('/seasons');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load seasons');
  }

  Future<Season> getSeason(int id) async {
    final response = await _dio.get('/seasons/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Season.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Season not found');
  }

  Future<Season> createSeason(SeasonInput input) async {
    final response = await _dio.post('/seasons', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Season.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create season');
  }

  Future<Season> updateSeason(int id, SeasonInput input) async {
    final response = await _dio.put('/seasons/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Season.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update season');
  }

  Future<void> deleteSeason(int id) async {
    final response = await _dio.delete('/seasons/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete season');
    }
  }

  Future<void> reorderSeasons(List<int> order) async {
    final response = await _dio.put('/seasons/reorder', data: {'order': order});
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder seasons');
    }
  }

  // ============ EPISODES ============
  Future<List<Episode>> getEpisodes(int seasonId) async {
    final response = await _dio.get('/episodes', queryParameters: {
      'seasonId': seasonId,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load episodes');
  }

  Future<Episode> getEpisode(int id) async {
    final response = await _dio.get('/episodes/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Episode.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Episode not found');
  }

  Future<Episode> createEpisode(EpisodeInput input) async {
    final response = await _dio.post('/episodes', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Episode.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create episode');
  }

  Future<Episode> updateEpisode(int id, EpisodeInput input) async {
    final response = await _dio.put('/episodes/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Episode.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update episode');
  }

  Future<void> deleteEpisode(int id) async {
    final response = await _dio.delete('/episodes/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete episode');
    }
  }

  Future<void> reorderEpisodes(int seasonId, List<int> order) async {
    final response = await _dio.put('/episodes/reorder', data: {
      'seasonId': seasonId,
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder episodes');
    }
  }

  // ============ PUZZLES ============
  Future<List<Puzzle>> getPuzzles(int episodeId) async {
    final response = await _dio.get('/puzzles', queryParameters: {
      'episodeId': episodeId,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Puzzle.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load puzzles');
  }

  Future<Puzzle> getPuzzle(int id) async {
    final response = await _dio.get('/puzzles/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Puzzle.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Puzzle not found');
  }

  Future<Puzzle> createPuzzle(PuzzleInput input) async {
    final response = await _dio.post('/puzzles', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Puzzle.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create puzzle');
  }

  Future<Puzzle> updatePuzzle(int id, PuzzleInput input) async {
    final response = await _dio.put('/puzzles/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Puzzle.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update puzzle');
  }

  Future<void> deletePuzzle(int id) async {
    final response = await _dio.delete('/puzzles/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete puzzle');
    }
  }

  Future<void> reorderPuzzles(List<int> order) async {
    final response = await _dio.put('/puzzles/reorder', data: {'order': order});
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder puzzles');
    }
  }

  // ============ PIECES ============
  Future<List<Piece>> getPieces(int puzzleId) async {
    final response = await _dio.get('/pieces', queryParameters: {'puzzleId': puzzleId});
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Piece.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load pieces');
  }

  Future<Piece> getPiece(int id) async {
    final response = await _dio.get('/pieces/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Piece.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Piece not found');
  }

  Future<Piece> createPiece(PieceInput input) async {
    final response = await _dio.post('/pieces', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Piece.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create piece');
  }

  Future<Piece> updatePiece(int id, PieceInput input) async {
    final response = await _dio.put('/pieces/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Piece.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update piece');
  }

  Future<void> deletePiece(int id) async {
    final response = await _dio.delete('/pieces/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete piece');
    }
  }

  Future<void> reorderPieces(int puzzleId, List<int> order) async {
    final response = await _dio.put('/pieces/reorder', data: {
      'puzzleId': puzzleId,
      'order': order,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder pieces');
    }
  }

  // ============ QUOTES ============
  Future<List<Quote>> getQuotes({String? status}) async {
    final response = await _dio.get('/quotes', queryParameters: {
      if (status != null) 'status': status,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load quotes');
  }

  Future<Quote> getQuote(int id) async {
    final response = await _dio.get('/quotes/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Quote.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Quote not found');
  }

  Future<Quote> createQuote(QuoteInput input) async {
    final response = await _dio.post('/quotes', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Quote.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create quote');
  }

  Future<Quote> updateQuote(int id, QuoteInput input) async {
    final response = await _dio.put('/quotes/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Quote.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update quote');
  }

  Future<void> deleteQuote(int id) async {
    final response = await _dio.delete('/quotes/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete quote');
    }
  }

  Future<void> publishQuote(int id) async {
    final response = await _dio.put('/quotes/$id/publish');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to publish quote');
    }
  }

  // ============ MUSIC ============
  Future<List<Music>> getMusic() async {
    final response = await _dio.get('/music');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as List)
          .map((e) => Music.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(apiResponse.error ?? 'Failed to load music');
  }

  Future<Music> getMusicTrack(int id) async {
    final response = await _dio.get('/music/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Music.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Music track not found');
  }

  Future<Music> createMusic(MusicInput input) async {
    final response = await _dio.post('/music', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Music.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to create music');
  }

  Future<Music> updateMusic(int id, MusicInput input) async {
    final response = await _dio.put('/music/$id', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return Music.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to update music');
  }

  Future<void> deleteMusic(int id) async {
    final response = await _dio.delete('/music/$id');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete music');
    }
  }

  Future<void> reorderMusic(List<int> order) async {
    final response = await _dio.put('/music/reorder', data: {'order': order});
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to reorder music');
    }
  }

  // ============ NOTIFICATIONS ============
  Future<NotificationResult> sendNotification(NotificationInput input) async {
    final response = await _dio.post('/notifications/send', data: input.toJson());
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return NotificationResult.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to send notification');
  }

  // ============ DEVICES ============
  Future<PaginatedResponse<Device>> getDevices({String? platform, int page = 1, int limit = 50}) async {
    final response = await _dio.get('/devices', queryParameters: {
      if (platform != null) 'platform': platform,
      'page': page,
      'limit': limit,
    });
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      final devices = (apiResponse.data as List)
          .map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResponse(
        data: devices,
        pagination: apiResponse.pagination ?? Pagination(page: page, limit: limit, total: devices.length),
      );
    }
    throw Exception(apiResponse.error ?? 'Failed to load devices');
  }

  Future<DeviceStats> getDeviceStats() async {
    final response = await _dio.get('/devices/stats');
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return DeviceStats.fromJson(apiResponse.data as Map<String, dynamic>);
    }
    throw Exception(apiResponse.error ?? 'Failed to load device stats');
  }

  // ============ FILES ============
  Future<String> uploadFile(PlatformFile file, {String folder = 'uploads'}) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
      ),
      'folder': folder,
    });
    final response = await _dio.post('/files/upload', data: formData);
    final apiResponse = ApiResponse.fromJson(response.data, null);
    if (apiResponse.success && apiResponse.data != null) {
      return (apiResponse.data as Map<String, dynamic>)['url'] as String? ?? '';
    }
    throw Exception(apiResponse.error ?? 'Upload failed');
  }
}
