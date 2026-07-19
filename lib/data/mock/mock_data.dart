import '../models/localized_text.dart';
import '../models/season_model.dart';
import '../models/episode_model.dart';
import '../models/puzzle_model.dart';
import '../models/piece_model.dart';
import '../models/music_model.dart';
import '../models/quote_model.dart';
import '../models/device_model.dart';
import '../models/api_response.dart';

class MockData {
  static final seasons = [
    Season(
      id: 1,
      name: const LocalizedText(
        en: 'Season 1: The Beginning',
        ru: 'Сезон 1: Начало',
        hi: 'सीज़न 1: शुरुआत',
      ),
      image: 'season1.jpg',
      product: 'com.comics.season1',
      order: 1,
      episodesCount: 12,
    ),
    Season(
      id: 2,
      name: const LocalizedText(
        en: 'Season 2: The Journey',
        ru: 'Сезон 2: Путешествие',
        hi: 'सीज़न 2: यात्रा',
      ),
      image: 'season2.jpg',
      product: 'com.comics.season2',
      order: 2,
      episodesCount: 10,
    ),
    Season(
      id: 3,
      name: const LocalizedText(
        en: 'Season 3: The Awakening',
        ru: 'Сезон 3: Пробуждение',
        hi: 'सीज़न 3: जागृति',
      ),
      image: 'season3.jpg',
      order: 3,
      episodesCount: 8,
    ),
  ];

  static List<Episode> getEpisodes(int seasonId) {
    final episodeCounts = {1: 12, 2: 10, 3: 8};
    final count = episodeCounts[seasonId] ?? 5;

    return List.generate(
      count,
      (i) => Episode(
        id: seasonId * 100 + i + 1,
        seasonId: seasonId,
        name: LocalizedText(
          en: 'Episode ${i + 1}',
          ru: 'Эпизод ${i + 1}',
          hi: 'एपिसोड ${i + 1}',
        ),
        image: 'episode_${seasonId}_${i + 1}.jpg',
        file: i < 3 ? 'episode_${seasonId}_${i + 1}.pdf' : null,
        version: 1,
        product: i < 2 ? 'com.comics.s${seasonId}e${i + 1}' : null,
        date: DateTime.now().subtract(Duration(days: count - i)),
        order: i + 1,
      ),
    );
  }

  static List<Episode> get allEpisodes {
    final episodes = <Episode>[];
    for (final season in seasons) {
      episodes.addAll(getEpisodes(season.id));
    }
    return episodes;
  }

  static List<Puzzle> getPuzzles(int episodeId) {
    return List.generate(
      3,
      (i) {
        final puzzleRows = 3 + (i % 2);
        final puzzleCols = 3 + ((i + 1) % 2);
        return Puzzle(
          id: episodeId * 10 + i + 1,
          episodeId: episodeId,
          name: LocalizedText(
            en: 'Puzzle ${i + 1}',
            ru: 'Пазл ${i + 1}',
            hi: 'पहेली ${i + 1}',
          ),
          rows: puzzleRows,
          columns: puzzleCols,
          image: 'puzzle_${episodeId}_${i + 1}.jpg',
          version: 1,
          date: DateTime.now().subtract(Duration(days: 3 - i)),
          order: i + 1,
          piecesCount: puzzleRows * puzzleCols,
        );
      },
    );
  }

  static List<Piece> getPieces(int puzzleId) {
    final pieces = <Piece>[];
    int pieceId = puzzleId * 100;

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        pieceId++;
        pieces.add(Piece(
          id: pieceId,
          puzzleId: puzzleId,
          x: x,
          y: y,
          width: 1,
          height: 1,
          file: 'piece_${puzzleId}_${x}_${y}.png',
          version: 1,
          date: DateTime.now(),
          order: y * 3 + x + 1,
        ));
      }
    }

    return pieces;
  }

  static final music = [
    Music(
      id: 1,
      name: const LocalizedText(
        en: 'Opening Theme',
        ru: 'Вступительная тема',
        hi: 'ओपनिंग थीम',
      ),
      author: const LocalizedText(
        en: 'Composer A',
        ru: 'Композитор А',
        hi: 'संगीतकार ए',
      ),
      file: 'opening_theme.mp3',
      order: 1,
    ),
    Music(
      id: 2,
      name: const LocalizedText(
        en: 'Adventure Begins',
        ru: 'Приключение начинается',
        hi: 'साहसिक शुरू होता है',
      ),
      author: const LocalizedText(
        en: 'Composer B',
        ru: 'Композитор Б',
        hi: 'संगीतकार बी',
      ),
      file: 'adventure_begins.mp3',
      order: 2,
    ),
    Music(
      id: 3,
      name: const LocalizedText(
        en: 'Peaceful Moment',
        ru: 'Мирный момент',
        hi: 'शांतिपूर्ण क्षण',
      ),
      author: const LocalizedText(
        en: 'Composer C',
        ru: 'Композитор В',
        hi: 'संगीतकार सी',
      ),
      file: 'peaceful_moment.mp3',
      order: 3,
    ),
    Music(
      id: 4,
      name: const LocalizedText(
        en: 'Epic Battle',
        ru: 'Эпическая битва',
        hi: 'महाकाव्य युद्ध',
      ),
      author: const LocalizedText(
        en: 'Composer A',
        ru: 'Композитор А',
        hi: 'संगीतकार ए',
      ),
      order: 4,
    ),
  ];

  static final quotes = [
    Quote(
      id: 1,
      text: const LocalizedText(
        en: 'Every journey begins with a single step.',
        ru: 'Каждое путешествие начинается с одного шага.',
        hi: 'हर यात्रा एक कदम से शुरू होती है।',
      ),
      image: const LocalizedText(
        en: 'quote1_en.jpg',
        ru: 'quote1_ru.jpg',
        hi: 'quote1_hi.jpg',
      ),
      status: QuoteStatus.published,
    ),
    Quote(
      id: 2,
      text: const LocalizedText(
        en: 'The heart knows what the mind cannot see.',
        ru: 'Сердце знает то, чего не видит разум.',
        hi: 'दिल वह जानता है जो मन नहीं देख सकता।',
      ),
      image: const LocalizedText(
        en: 'quote2_en.jpg',
        ru: 'quote2_ru.jpg',
        hi: 'quote2_hi.jpg',
      ),
      status: QuoteStatus.published,
    ),
    Quote(
      id: 3,
      text: const LocalizedText(
        en: 'In unity, we find strength.',
        ru: 'В единстве мы находим силу.',
        hi: 'एकता में हम शक्ति पाते हैं।',
      ),
      image: const LocalizedText(
        en: 'quote3_en.jpg',
        ru: 'quote3_ru.jpg',
        hi: 'quote3_hi.jpg',
      ),
      publishDate: DateTime.now().add(const Duration(days: 7)),
      status: QuoteStatus.scheduled,
    ),
    Quote(
      id: 4,
      text: const LocalizedText(
        en: 'Tomorrow brings new hope.',
        ru: 'Завтра принесет новую надежду.',
        hi: 'कल नई आशा लाता है।',
      ),
      image: const LocalizedText(
        en: 'quote4_en.jpg',
        ru: 'quote4_ru.jpg',
        hi: 'quote4_hi.jpg',
      ),
      publishDate: DateTime.now().add(const Duration(days: 14)),
      status: QuoteStatus.scheduled,
    ),
  ];

  static final deviceStats = DeviceStats(
    total: 8542,
    active30days: 2156,
    byPlatform: {'android': 4500, 'ios': 4042},
  );

  static PaginatedResponse<Device> getDevices({String? platform, int page = 1, int limit = 50}) {
    final allDevices = [
      Device(id: 1, platform: 1, platformName: 'ios', culture: 'ru', lastModified: DateTime.now(), pushToken: 'dK4x...f9Qz'),
      Device(id: 2, platform: 0, platformName: 'android', culture: 'en', lastModified: DateTime.now(), pushToken: 'eR7m...a2Lp'),
      Device(id: 3, platform: 0, platformName: 'android', culture: 'ru', lastModified: DateTime.now().subtract(const Duration(days: 1)), pushToken: 'tG1c...x8Wd'),
      Device(id: 4, platform: 1, platformName: 'ios', culture: 'hi', lastModified: DateTime.now().subtract(const Duration(days: 3)), pushToken: 'hV9s...k3Nb'),
      Device(id: 5, platform: 1, platformName: 'ios', culture: 'en', lastModified: DateTime.now().subtract(const Duration(days: 5)), pushToken: 'jK2r...m7Pq'),
      Device(id: 6, platform: 0, platformName: 'android', culture: 'hi', lastModified: DateTime.now().subtract(const Duration(days: 7)), pushToken: 'bN8t...v4Xs'),
    ];

    final filtered = platform != null
        ? allDevices.where((d) => d.platformName == platform).toList()
        : allDevices;

    return PaginatedResponse(
      data: filtered,
      pagination: Pagination(page: page, limit: limit, total: filtered.length),
    );
  }
}
