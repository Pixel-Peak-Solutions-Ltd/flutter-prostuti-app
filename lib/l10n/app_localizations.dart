import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @createFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Create Flashcard'**
  String get createFlashcard;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Subject, Chapter and Unit'**
  String get titleHint;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get term;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Another Card'**
  String get addCard;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @exploration.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploration;

  /// No description provided for @yourFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Your Flashcards'**
  String get yourFlashcards;

  /// No description provided for @createNewFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Create New Flashcard'**
  String get createNewFlashcard;

  /// No description provided for @recentFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Recent Flashcards'**
  String get recentFlashcards;

  /// No description provided for @yourFlashcardsList.
  ///
  /// In en, this message translates to:
  /// **'Your Flashcards List'**
  String get yourFlashcardsList;

  /// No description provided for @emptyFlashcardMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no flashcards here'**
  String get emptyFlashcardMessage;

  /// No description provided for @emptyYourFlashcardMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any flashcards'**
  String get emptyYourFlashcardMessage;

  /// No description provided for @endOfList.
  ///
  /// In en, this message translates to:
  /// **'You\'ve seen all flashcards'**
  String get endOfList;

  /// No description provided for @setOptions.
  ///
  /// In en, this message translates to:
  /// **'Set Options'**
  String get setOptions;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @visibleBy.
  ///
  /// In en, this message translates to:
  /// **'Visible By'**
  String get visibleBy;

  /// No description provided for @onlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only me'**
  String get onlyMe;

  /// No description provided for @everyone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get everyone;

  /// No description provided for @cardCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Flashcard successfully created!'**
  String get cardCreatedSuccessfully;

  /// No description provided for @swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe'**
  String get swipe;

  /// No description provided for @viewCardList.
  ///
  /// In en, this message translates to:
  /// **'View Card List'**
  String get viewCardList;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @youHaveAchieved.
  ///
  /// In en, this message translates to:
  /// **'You have achieved'**
  String get youHaveAchieved;

  /// No description provided for @learned.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get learned;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @reviewCardsAgain.
  ///
  /// In en, this message translates to:
  /// **'Review Cards Again'**
  String get reviewCardsAgain;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Search flashcards...'**
  String get searchFlashcards;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @openFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Open flashcard'**
  String get openFlashcard;

  /// No description provided for @openYourFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Open your flashcard'**
  String get openYourFlashcard;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No description provided for @noFlashcardItems.
  ///
  /// In en, this message translates to:
  /// **'No flashcard items found for this set'**
  String get noFlashcardItems;

  /// No description provided for @swipeLeftToLearn.
  ///
  /// In en, this message translates to:
  /// **'Swipe Left to Learn'**
  String get swipeLeftToLearn;

  /// No description provided for @swipeRightToKnow.
  ///
  /// In en, this message translates to:
  /// **'Swipe Right to Know'**
  String get swipeRightToKnow;

  /// No description provided for @favoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
