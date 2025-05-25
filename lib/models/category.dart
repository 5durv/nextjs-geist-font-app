class Category {
  final String title;
  final String imageUrl;
  final String description;

  Category({
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  static List<Category> categories = [
    Category(
      title: 'معالم سياحية',
      imageUrl: 'https://images.unsplash.com/photo-1539650116574-75c0c6d68bc4?w=600&h=400',
      description: 'قلعة أربيل التاريخية والمتاحف',
    ),
    Category(
      title: 'فنادق ومنتجعات',
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600&h=400',
      description: 'إقامة فاخرة ومريحة',
    ),
    Category(
      title: 'مطاعم',
      imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&h=400',
      description: 'أشهى المأكولات الكردية والعالمية',
    ),
    Category(
      title: 'مقاهي شعبية',
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600&h=400',
      description: 'قهوة أصيلة وأجواء تراثية',
    ),
    Category(
      title: 'أماكن ترفيهية',
      imageUrl: 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=600&h=400',
      description: 'حدائق ومراكز ترفيه عائلية',
    ),
  ];
}
