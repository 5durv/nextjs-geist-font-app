class AppConstants {
  // App Information
  static const String appName = 'Kurdistan Tourism';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.kurdistantourism.com';
  
  // Image Assets
  static const Map<String, String> cityImages = {
    'أربيل': 'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
    'السليمانية': 'https://images.unsplash.com/photo-1482938289607-e9573fc25ebb',
    'دهوك': 'https://images.unsplash.com/photo-1472396961693-142e6e269027',
    'زاخو': 'https://images.unsplash.com/photo-1466442929976-97f336a657be',
  };

  static const Map<String, String> categoryImages = {
    'معالم سياحية': 'https://images.unsplash.com/photo-1539650116574-75c0c6d68bc4?w=600&h=400',
    'فنادق ومنتجعات': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600&h=400',
    'مطاعم': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&h=400',
    'مقاهي شعبية': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600&h=400',
    'أماكن ترفيهية': 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=600&h=400',
  };

  // Text Content
  static const String heroTitle = 'اكتشف جمال إقليم كردستان';
  static const String heroSubtitle = 'تجول بين الجبال الشاهقة، المعالم التاريخية، والثقافة الغنية في أجمل مناطق العراق';
  
  static const String categoriesTitle = 'استكشف معالم كردستان';
  static const String categoriesSubtitle = 'اختر فئة لاستكشاف أجمل الوجهات في أربيل والمدن الأخرى';
  
  static const String citiesTitle = 'اكتشف مدن كردستان';
  static const String citiesSubtitle = 'استكشف جمال وسحر المدن الرئيسية في إقليم كردستان العراق';

  // Button Labels
  static const String exploreMoreButton = 'اكتشف المزيد';
  static const String bookFlightButton = 'حجز طيران';
  static const String bookCarButton = 'حجز سيارة';
  static const String bookHotelButton = 'حجز فندق';

  // Error Messages
  static const String imageLoadError = 'خطأ في تحميل الصورة';
  static const String networkError = 'خطأ في الاتصال بالشبكة';
  static const String generalError = 'حدث خطأ ما';

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 350;
  static const int longAnimationDuration = 500;

  // Layout Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 4.0;

  // City Descriptions
  static const Map<String, String> cityDescriptions = {
    'أربيل': 'قلعة أربيل التاريخية ومدينة حضارية عمرها أكثر من 6000 عام',
    'السليمانية': 'مدينة الثقافة والشعر والمتاحف والطبيعة الخلابة',
    'دهوك': 'مدينة الجبال والبحيرات المحاطة بمناظر طبيعية خلابة',
    'زاخو': 'بوابة إقليم كردستان وموطن الجسر العباسي التاريخي',
  };

  // Category Descriptions
  static const Map<String, String> categoryDescriptions = {
    'معالم سياحية': 'قلعة أربيل التاريخية والمتاحف',
    'فنادق ومنتجعات': 'إقامة فاخرة ومريحة',
    'مطاعم': 'أشهى المأكولات الكردية والعالمية',
    'مقاهي شعبية': 'قهوة أصيلة وأجواء تراثية',
    'أماكن ترفيهية': 'حدائق ومراكز ترفيه عائلية',
  };
}
