class City {
  final String name;
  final String imageUrl;
  final String description;
  final String longDescription;

  City({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.longDescription,
  });

  static List<City> cities = [
    City(
      name: 'أربيل',
      imageUrl: 'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
      description: 'قلعة أربيل التاريخية ومدينة حضارية',
      longDescription: 'قلعة أربيل التاريخية ومدينة حضارية عمرها أكثر من 6000 عام، تجمع بين التاريخ العريق والحداثة المعاصرة',
    ),
    City(
      name: 'السليمانية',
      imageUrl: 'https://images.unsplash.com/photo-1482938289607-e9573fc25ebb',
      description: 'مدينة الثقافة والشعر والمتاحف',
      longDescription: 'مدينة الثقافة والشعر والمتاحف والطبيعة الخلابة، تتميز بتنوعها الثقافي وجمالها الطبيعي',
    ),
    City(
      name: 'دهوك',
      imageUrl: 'https://images.unsplash.com/photo-1472396961693-142e6e269027',
      description: 'مدينة الجبال والبحيرات',
      longDescription: 'مدينة الجبال والبحيرات المحاطة بمناظر طبيعية خلابة، توفر تجربة سياحية فريدة',
    ),
    City(
      name: 'زاخو',
      imageUrl: 'https://images.unsplash.com/photo-1466442929976-97f336a657be',
      description: 'بوابة إقليم كردستان',
      longDescription: 'بوابة إقليم كردستان وموطن الجسر العباسي التاريخي، تجمع بين الطبيعة الخلابة والتراث العريق',
    ),
  ];
}
