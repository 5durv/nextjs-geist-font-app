import 'dart:convert';
import 'package:shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _keyPrefix = 'kurdistan_tourism_';
  static const String _keyLanguage = '${_keyPrefix}language';
  static const String _keyTheme = '${_keyPrefix}theme';
  static const String _keyFirstTime = '${_keyPrefix}first_time';
  static const String _keyUserData = '${_keyPrefix}user_data';
  static const String _keyFavorites = '${_keyPrefix}favorites';
  static const String _keyRecentSearches = '${_keyPrefix}recent_searches';
  static const String _keyLastVisited = '${_keyPrefix}last_visited';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language preferences
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_keyLanguage, languageCode);
  }

  String? getLanguage() {
    return _prefs.getString(_keyLanguage);
  }

  // Theme preferences
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_keyTheme, isDark);
  }

  bool getDarkMode() {
    return _prefs.getBool(_keyTheme) ?? false;
  }

  // First time app launch
  Future<void> setFirstTimeLaunch(bool isFirstTime) async {
    await _prefs.setBool(_keyFirstTime, isFirstTime);
  }

  bool isFirstTimeLaunch() {
    return _prefs.getBool(_keyFirstTime) ?? true;
  }

  // User data
  Future<void> setUserData(Map<String, dynamic> userData) async {
    await _prefs.setString(_keyUserData, json.encode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final String? userDataString = _prefs.getString(_keyUserData);
    if (userDataString != null) {
      return json.decode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  // Favorite cities/places
  Future<void> addToFavorites(String itemId) async {
    final favorites = getFavorites();
    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await _prefs.setStringList(_keyFavorites, favorites);
    }
  }

  Future<void> removeFromFavorites(String itemId) async {
    final favorites = getFavorites();
    favorites.remove(itemId);
    await _prefs.setStringList(_keyFavorites, favorites);
  }

  List<String> getFavorites() {
    return _prefs.getStringList(_keyFavorites) ?? [];
  }

  bool isFavorite(String itemId) {
    return getFavorites().contains(itemId);
  }

  // Recent searches
  Future<void> addRecentSearch(String search) async {
    final searches = getRecentSearches();
    if (searches.contains(search)) {
      searches.remove(search);
    }
    searches.insert(0, search);
    if (searches.length > 10) {
      searches.removeLast();
    }
    await _prefs.setStringList(_keyRecentSearches, searches);
  }

  List<String> getRecentSearches() {
    return _prefs.getStringList(_keyRecentSearches) ?? [];
  }

  Future<void> clearRecentSearches() async {
    await _prefs.setStringList(_keyRecentSearches, []);
  }

  // Last visited cities
  Future<void> addLastVisited(String cityId) async {
    final visited = getLastVisited();
    if (visited.contains(cityId)) {
      visited.remove(cityId);
    }
    visited.insert(0, cityId);
    if (visited.length > 5) {
      visited.removeLast();
    }
    await _prefs.setStringList(_keyLastVisited, visited);
  }

  List<String> getLastVisited() {
    return _prefs.getStringList(_keyLastVisited) ?? [];
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  // Remove specific key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Generic methods for storing different types of data
  Future<void> setString(String key, String value) async {
    await _prefs.setString('$_keyPrefix$key', value);
  }

  String? getString(String key) {
    return _prefs.getString('$_keyPrefix$key');
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt('$_keyPrefix$key', value);
  }

  int? getInt(String key) {
    return _prefs.getInt('$_keyPrefix$key');
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool('$_keyPrefix$key', value);
  }

  bool? getBool(String key) {
    return _prefs.getBool('$_keyPrefix$key');
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble('$_keyPrefix$key', value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble('$_keyPrefix$key');
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList('$_keyPrefix$key', value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList('$_keyPrefix$key');
  }
}
