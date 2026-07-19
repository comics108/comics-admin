import 'app_localizations.dart';

class AppLocalizationsRu implements AppLocalizations {
  @override String get appTitle => 'Комиксы';
  @override String get adminPanel => 'Панель администратора';
  @override String get login => 'Вход';
  @override String get logout => 'Выйти';
  @override String get save => 'Сохранить';
  @override String get cancel => 'Отмена';
  @override String get add => 'Добавить';
  @override String get edit => 'Изменить';
  @override String get delete => 'Удалить';
  @override String get confirm => 'Подтвердить';
  @override String get yes => 'Да';
  @override String get no => 'Нет';
  @override String get loading => 'Загрузка...';
  @override String get error => 'Ошибка';
  @override String get success => 'Успешно';
  @override String get rememberMe => 'Запомнить меня';

  @override String get email => 'Email';
  @override String get password => 'Пароль';
  @override String get loginButton => 'Войти';
  @override String get loginError => 'Неверный логин или пароль';

  @override String get menuSeasons => 'Сезоны';
  @override String get menuEpisodes => 'Эпизоды';
  @override String get menuPuzzles => 'Пазлы';
  @override String get menuPieces => 'Детали';
  @override String get menuQuotes => 'Цитаты';
  @override String get menuMusic => 'Музыка';
  @override String get menuNotifications => 'Уведомления';
  @override String get menuDevices => 'Устройства';

  @override String get seasonName => 'Название';
  @override String get seasonImage => 'Изображение';
  @override String get seasonProduct => 'Product ID';
  @override String get seasonOrder => 'Порядок';
  @override String get seasonEpisodes => 'Эпизодов';
  @override String get addSeason => 'Добавить сезон';
  @override String get editSeason => 'Редактировать сезон';
  @override String get deleteSeasonConfirm => 'Сезон и все эпизоды будут удалены';

  @override String get episodeName => 'Название';
  @override String get episodeImage => 'Изображение';
  @override String get episodeFile => 'Файл';
  @override String get episodeVersion => 'Версия';
  @override String get episodeProduct => 'Product ID';
  @override String get episodeDate => 'Дата';
  @override String get episodeOrder => 'Порядок';
  @override String get addEpisode => 'Добавить эпизод';
  @override String get editEpisode => 'Редактировать эпизод';
  @override String get deleteEpisodeConfirm => 'Эпизод и все пазлы будут удалены';
  @override String get selectSeason => 'Выберите сезон';

  @override String get puzzleName => 'Название';
  @override String get puzzleRows => 'Строк';
  @override String get puzzleColumns => 'Столбцов';
  @override String get puzzleImage => 'Изображение';
  @override String get puzzleVersion => 'Версия';
  @override String get puzzleDate => 'Дата';
  @override String get puzzleOrder => 'Порядок';
  @override String get puzzlePieces => 'Деталей';
  @override String get addPuzzle => 'Добавить пазл';
  @override String get editPuzzle => 'Редактировать пазл';
  @override String get deletePuzzleConfirm => 'Пазл и все детали будут удалены';
  @override String get selectEpisode => 'Выберите эпизод';

  @override String get piecePosition => 'Позиция';
  @override String get pieceSize => 'Размер';
  @override String get pieceFile => 'Файл';
  @override String get pieceVersion => 'Версия';
  @override String get pieceDate => 'Дата';
  @override String get pieceOrder => 'Порядок';
  @override String get addPiece => 'Добавить деталь';
  @override String get editPiece => 'Редактировать деталь';
  @override String get deletePieceConfirm => 'Деталь будет удалена';
  @override String get selectPuzzle => 'Выберите пазл';

  @override String get musicName => 'Название';
  @override String get musicAuthor => 'Автор';
  @override String get musicFile => 'Файл';
  @override String get musicOrder => 'Порядок';
  @override String get addMusic => 'Добавить музыку';
  @override String get editMusic => 'Редактировать музыку';
  @override String get deleteMusicConfirm => 'Музыкальный трек будет удален';

  @override String get quoteText => 'Текст';
  @override String get quoteImage => 'Изображение';
  @override String get quotePublishDate => 'Дата публикации';
  @override String get quoteStatus => 'Статус';
  @override String get quotePublished => 'Опубликовано';
  @override String get quoteScheduled => 'Запланировано';
  @override String get addQuote => 'Добавить цитату';
  @override String get editQuote => 'Редактировать цитату';
  @override String get deleteQuoteConfirm => 'Цитата будет удалена';
  @override String get publishNow => 'Опубликовать сейчас';
  @override String get allQuotes => 'Все цитаты';

  @override String get notificationTitle => 'Заголовок';
  @override String get notificationBody => 'Текст';
  @override String get notificationPlatform => 'Платформа';
  @override String get notificationPlatformAll => 'Все платформы';
  @override String get notificationPlatformIos => 'Только iOS';
  @override String get notificationPlatformAndroid => 'Только Android';
  @override String get sendNotification => 'Отправить уведомление';
  @override String get notificationSent => 'Уведомление отправлено';
  @override String notificationResult(int sent, int failed) => 'Отправлено: $sent, Ошибок: $failed';

  @override String get devicesTitle => 'Устройства';
  @override String get devicesTotal => 'Всего устройств';
  @override String get devicesActive30 => 'активных за 30 дней';
  @override String get devicesToken => 'Токен';
  @override String get devicesPlatform => 'Платформа';
  @override String get devicesLanguage => 'Язык';
  @override String get devicesLastActivity => 'Последняя активность';
  @override String get devicesAllPlatforms => 'Все платформы';

  @override String get textEnglish => 'Английский';
  @override String get textRussian => 'Русский';
  @override String get textHindi => 'Хинди';

  @override String get page => 'Страница';
  @override String get pageOf => 'из';
  @override String showing(int start, int end, int total) => 'Показано $start–$end из $total';

  @override String get dragFileHere => 'Перетащите файл сюда';
  @override String get orClickToSelect => 'или нажмите для выбора';
  @override String get allowedFormats => 'Допустимые форматы';
  @override String get replaceFile => 'Заменить';
  @override String get noFile => 'Нет файла';

  @override String get confirmDeleteTitle => 'Подтверждение удаления';
  @override String confirmDeleteMessage(String item) => 'Удалить "$item"?';

  @override String get reorder => 'Упорядочить';
  @override String get reorderHint => 'Перетащите для изменения порядка';
}
