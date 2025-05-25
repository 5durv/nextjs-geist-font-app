import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/category.dart';
import '../models/city.dart';
import '../config/constants.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Simulate API calls with Future delays
  Future<List<Category>> getCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return Category.categories;
  }

  Future<List<City>> getCities() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return City.cities;
  }

  Future<City> getCityDetails(String cityName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final city = City.cities.firstWhere(
      (city) => city.name == cityName,
      orElse: () => throw Exception('City not found'),
    );
    
    return city;
  }

  Future<List<String>> getCityAttractions(String cityName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data - in a real app, this would come from an API
    final Map<String, List<String>> cityAttractions = {
      'أربيل': [
        'قلعة أربيل التاريخية',
        'سوق القيصرية',
        'متحف أربيل للآثار',
        'حديقة سامي عبد الرحمن',
      ],
      'السليمانية': [
        'متحف السليمانية',
        'سوق السليمانية المركزي',
        'حديقة آزادي',
        'قصر السليمانية الثقافي',
      ],
      'دهوك': [
        'قلعة دهوك',
        'متحف دهوك',
        'سد دهوك',
        'منتزه دهوك الترفيهي',
      ],
      'زاخو': [
        'جسر دلال',
        'قلعة زاخو',
        'نهر الخابور',
        'سوق زاخو القديم',
      ],
    };

    return cityAttractions[cityName] ?? [];
  }

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock weather data - in a real app, this would come from a weather API
    final Map<String, Map<String, dynamic>> weatherData = {
      'أربيل': {
        'temperature': 28,
        'condition': 'مشمس',
        'humidity': 45,
        'windSpeed': 12,
      },
      'السليمانية': {
        'temperature': 25,
        'condition': 'غائم جزئياً',
        'humidity': 50,
        'windSpeed': 10,
      },
      'دهوك': {
        'temperature': 27,
        'condition': 'مشمس',
        'humidity': 48,
        'windSpeed': 8,
      },
      'زاخو': {
        'temperature': 29,
        'condition': 'مشمس',
        'humidity': 42,
        'windSpeed': 15,
      },
    };

    return weatherData[cityName] ?? {};
  }

  Future<List<Map<String, dynamic>>> getHotels(String cityName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock hotel data - in a real app, this would come from an API
    final Map<String, List<Map<String, dynamic>>> hotelData = {
      'أربيل': [
        {
          'name': 'فندق روتانا أربيل',
          'rating': 5,
          'price': 200,
          'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        },
        {
          'name': 'فندق ديفان أربيل',
          'rating': 4,
          'price': 150,
          'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        },
      ],
      'السليمانية': [
        {
          'name': 'فندق جراند ميلينيوم السليمانية',
          'rating': 5,
          'price': 180,
          'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        },
        {
          'name': 'فندق هاي كريست السليمانية',
          'rating': 4,
          'price': 130,
          'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        },
      ],
    };

    return hotelData[cityName] ?? [];
  }

  // Error handling wrapper
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      throw Exception('حدث خطأ في الاتصال. الرجاء المحاولة مرة أخرى.');
    }
  }
}
