import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/city.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Loading states
  bool _isLoadingCategories = false;
  bool _isLoadingCities = false;
  bool _isLoadingCityDetails = false;
  
  // Data states
  List<Category> _categories = [];
  List<City> _cities = [];
  City? _selectedCity;
  List<String> _cityAttractions = [];
  Map<String, dynamic> _weatherData = {};
  List<Map<String, dynamic>> _hotels = [];
  
  // Error states
  String? _error;
  
  // Getters
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingCities => _isLoadingCities;
  bool get isLoadingCityDetails => _isLoadingCityDetails;
  List<Category> get categories => _categories;
  List<City> get cities => _cities;
  City? get selectedCity => _selectedCity;
  List<String> get cityAttractions => _cityAttractions;
  Map<String, dynamic> get weatherData => _weatherData;
  List<Map<String, dynamic>> get hotels => _hotels;
  String? get error => _error;
  
  // Initialize data
  Future<void> initializeApp() async {
    await Future.wait([
      fetchCategories(),
      fetchCities(),
    ]);
  }
  
  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      _isLoadingCategories = true;
      _error = null;
      notifyListeners();
      
      _categories = await _apiService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }
  
  // Fetch cities
  Future<void> fetchCities() async {
    try {
      _isLoadingCities = true;
      _error = null;
      notifyListeners();
      
      _cities = await _apiService.getCities();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCities = false;
      notifyListeners();
    }
  }
  
  // Select and fetch city details
  Future<void> selectCity(String cityName) async {
    try {
      _isLoadingCityDetails = true;
      _error = null;
      notifyListeners();
      
      // Fetch all city-related data concurrently
      final results = await Future.wait([
        _apiService.getCityDetails(cityName),
        _apiService.getCityAttractions(cityName),
        _apiService.getWeather(cityName),
        _apiService.getHotels(cityName),
      ]);
      
      _selectedCity = results[0] as City;
      _cityAttractions = results[1] as List<String>;
      _weatherData = results[2] as Map<String, dynamic>;
      _hotels = results[3] as List<Map<String, dynamic>>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCityDetails = false;
      notifyListeners();
    }
  }
  
  // Clear selected city
  void clearSelectedCity() {
    _selectedCity = null;
    _cityAttractions = [];
    _weatherData = {};
    _hotels = [];
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Reset state
  void resetState() {
    _isLoadingCategories = false;
    _isLoadingCities = false;
    _isLoadingCityDetails = false;
    _categories = [];
    _cities = [];
    _selectedCity = null;
    _cityAttractions = [];
    _weatherData = {};
    _hotels = [];
    _error = null;
    notifyListeners();
  }
}
