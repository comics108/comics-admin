import 'package:flutter/material.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ru'),
    Locale('en'),
  ];

  // General
  String get appTitle;
  String get adminPanel;
  String get login;
  String get logout;
  String get save;
  String get cancel;
  String get add;
  String get edit;
  String get delete;
  String get confirm;
  String get yes;
  String get no;
  String get loading;
  String get error;
  String get success;
  String get rememberMe;

  // Login
  String get email;
  String get password;
  String get loginButton;
  String get loginError;

  // Menu
  String get menuSeasons;
  String get menuEpisodes;
  String get menuPuzzles;
  String get menuPieces;
  String get menuQuotes;
  String get menuMusic;
  String get menuNotifications;
  String get menuDevices;

  // Seasons
  String get seasonName;
  String get seasonImage;
  String get seasonProduct;
  String get seasonOrder;
  String get seasonEpisodes;
  String get addSeason;
  String get editSeason;
  String get deleteSeasonConfirm;

  // Episodes
  String get episodeName;
  String get episodeImage;
  String get episodeFile;
  String get episodeVersion;
  String get episodeProduct;
  String get episodeDate;
  String get episodeOrder;
  String get addEpisode;
  String get editEpisode;
  String get deleteEpisodeConfirm;
  String get selectSeason;

  // Puzzles
  String get puzzleName;
  String get puzzleRows;
  String get puzzleColumns;
  String get puzzleImage;
  String get puzzleVersion;
  String get puzzleDate;
  String get puzzleOrder;
  String get puzzlePieces;
  String get addPuzzle;
  String get editPuzzle;
  String get deletePuzzleConfirm;
  String get selectEpisode;

  // Pieces
  String get piecePosition;
  String get pieceSize;
  String get pieceFile;
  String get pieceVersion;
  String get pieceDate;
  String get pieceOrder;
  String get addPiece;
  String get editPiece;
  String get deletePieceConfirm;
  String get selectPuzzle;

  // Music
  String get musicName;
  String get musicAuthor;
  String get musicFile;
  String get musicOrder;
  String get addMusic;
  String get editMusic;
  String get deleteMusicConfirm;

  // Quotes
  String get quoteText;
  String get quoteImage;
  String get quotePublishDate;
  String get quoteStatus;
  String get quotePublished;
  String get quoteScheduled;
  String get addQuote;
  String get editQuote;
  String get deleteQuoteConfirm;
  String get publishNow;
  String get allQuotes;

  // Notifications
  String get notificationTitle;
  String get notificationBody;
  String get notificationPlatform;
  String get notificationPlatformAll;
  String get notificationPlatformIos;
  String get notificationPlatformAndroid;
  String get sendNotification;
  String get notificationSent;
  String notificationResult(int sent, int failed);

  // Devices
  String get devicesTitle;
  String get devicesTotal;
  String get devicesActive30;
  String get devicesToken;
  String get devicesPlatform;
  String get devicesLanguage;
  String get devicesLastActivity;
  String get devicesAllPlatforms;

  // Localized text fields
  String get textEnglish;
  String get textRussian;
  String get textHindi;

  // Pagination
  String get page;
  String get pageOf;
  String showing(int start, int end, int total);

  // File drop zone
  String get dragFileHere;
  String get orClickToSelect;
  String get allowedFormats;
  String get replaceFile;
  String get noFile;

  // Confirm dialog
  String get confirmDeleteTitle;
  String confirmDeleteMessage(String item);

  // Reorder
  String get reorder;
  String get reorderHint;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ru', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'ru':
      default:
        return AppLocalizationsRu();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
