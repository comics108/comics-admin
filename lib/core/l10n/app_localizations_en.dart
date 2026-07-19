import 'app_localizations.dart';

class AppLocalizationsEn implements AppLocalizations {
  @override String get appTitle => 'Comics';
  @override String get adminPanel => 'Admin Panel';
  @override String get login => 'Login';
  @override String get logout => 'Logout';
  @override String get save => 'Save';
  @override String get cancel => 'Cancel';
  @override String get add => 'Add';
  @override String get edit => 'Edit';
  @override String get delete => 'Delete';
  @override String get confirm => 'Confirm';
  @override String get yes => 'Yes';
  @override String get no => 'No';
  @override String get loading => 'Loading...';
  @override String get error => 'Error';
  @override String get success => 'Success';
  @override String get rememberMe => 'Remember me';

  @override String get email => 'Email';
  @override String get password => 'Password';
  @override String get loginButton => 'Login';
  @override String get loginError => 'Invalid email or password';

  @override String get menuSeasons => 'Seasons';
  @override String get menuEpisodes => 'Episodes';
  @override String get menuPuzzles => 'Puzzles';
  @override String get menuPieces => 'Pieces';
  @override String get menuQuotes => 'Quotes';
  @override String get menuMusic => 'Music';
  @override String get menuNotifications => 'Notifications';
  @override String get menuDevices => 'Devices';

  @override String get seasonName => 'Name';
  @override String get seasonImage => 'Image';
  @override String get seasonProduct => 'Product ID';
  @override String get seasonOrder => 'Order';
  @override String get seasonEpisodes => 'Episodes';
  @override String get addSeason => 'Add season';
  @override String get editSeason => 'Edit season';
  @override String get deleteSeasonConfirm => 'Season and all episodes will be deleted';

  @override String get episodeName => 'Name';
  @override String get episodeImage => 'Image';
  @override String get episodeFile => 'File';
  @override String get episodeVersion => 'Version';
  @override String get episodeProduct => 'Product ID';
  @override String get episodeDate => 'Date';
  @override String get episodeOrder => 'Order';
  @override String get addEpisode => 'Add episode';
  @override String get editEpisode => 'Edit episode';
  @override String get deleteEpisodeConfirm => 'Episode and all puzzles will be deleted';
  @override String get selectSeason => 'Select season';

  @override String get puzzleName => 'Name';
  @override String get puzzleRows => 'Rows';
  @override String get puzzleColumns => 'Columns';
  @override String get puzzleImage => 'Image';
  @override String get puzzleVersion => 'Version';
  @override String get puzzleDate => 'Date';
  @override String get puzzleOrder => 'Order';
  @override String get puzzlePieces => 'Pieces';
  @override String get addPuzzle => 'Add puzzle';
  @override String get editPuzzle => 'Edit puzzle';
  @override String get deletePuzzleConfirm => 'Puzzle and all pieces will be deleted';
  @override String get selectEpisode => 'Select episode';

  @override String get piecePosition => 'Position';
  @override String get pieceSize => 'Size';
  @override String get pieceFile => 'File';
  @override String get pieceVersion => 'Version';
  @override String get pieceDate => 'Date';
  @override String get pieceOrder => 'Order';
  @override String get addPiece => 'Add piece';
  @override String get editPiece => 'Edit piece';
  @override String get deletePieceConfirm => 'Piece will be deleted';
  @override String get selectPuzzle => 'Select puzzle';

  @override String get musicName => 'Name';
  @override String get musicAuthor => 'Author';
  @override String get musicFile => 'File';
  @override String get musicOrder => 'Order';
  @override String get addMusic => 'Add music';
  @override String get editMusic => 'Edit music';
  @override String get deleteMusicConfirm => 'Music track will be deleted';

  @override String get quoteText => 'Text';
  @override String get quoteImage => 'Image';
  @override String get quotePublishDate => 'Publish date';
  @override String get quoteStatus => 'Status';
  @override String get quotePublished => 'Published';
  @override String get quoteScheduled => 'Scheduled';
  @override String get addQuote => 'Add quote';
  @override String get editQuote => 'Edit quote';
  @override String get deleteQuoteConfirm => 'Quote will be deleted';
  @override String get publishNow => 'Publish now';
  @override String get allQuotes => 'All quotes';

  @override String get notificationTitle => 'Title';
  @override String get notificationBody => 'Body';
  @override String get notificationPlatform => 'Platform';
  @override String get notificationPlatformAll => 'All platforms';
  @override String get notificationPlatformIos => 'iOS only';
  @override String get notificationPlatformAndroid => 'Android only';
  @override String get sendNotification => 'Send notification';
  @override String get notificationSent => 'Notification sent';
  @override String notificationResult(int sent, int failed) => 'Sent: $sent, Failed: $failed';

  @override String get devicesTitle => 'Devices';
  @override String get devicesTotal => 'Total devices';
  @override String get devicesActive30 => 'active in 30 days';
  @override String get devicesToken => 'Token';
  @override String get devicesPlatform => 'Platform';
  @override String get devicesLanguage => 'Language';
  @override String get devicesLastActivity => 'Last activity';
  @override String get devicesAllPlatforms => 'All platforms';

  @override String get textEnglish => 'English';
  @override String get textRussian => 'Russian';
  @override String get textHindi => 'Hindi';

  @override String get page => 'Page';
  @override String get pageOf => 'of';
  @override String showing(int start, int end, int total) => 'Showing $start–$end of $total';

  @override String get dragFileHere => 'Drop file here';
  @override String get orClickToSelect => 'or click to select';
  @override String get allowedFormats => 'Allowed formats';
  @override String get replaceFile => 'Replace';
  @override String get noFile => 'No file';

  @override String get confirmDeleteTitle => 'Confirm deletion';
  @override String confirmDeleteMessage(String item) => 'Delete "$item"?';

  @override String get reorder => 'Reorder';
  @override String get reorderHint => 'Drag to reorder items';
}
