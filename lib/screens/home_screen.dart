import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/city_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/loading_indicator.dart';
import '../models/category.dart';
import '../models/city.dart';
import '../config/constants.dart';
import '../config/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: false,
        child: CustomScrollView(
          slivers: [
            _buildHeroSection(),
            SliverToBoxAdapter(child: _buildActionButtons(context)),
            _buildCategoriesSection(context),
            _buildCitiesSection(context),
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppConstants.heroTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              AppConstants.categoryImages['معالم سياحية']!,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              left: 16,
              right: 16,
              child: Text(
                AppConstants.heroSubtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            AppConstants.exploreMoreButton,
            Icons.explore,
            () {},
          ),
          _buildActionButton(
            context,
            AppConstants.bookFlightButton,
            Icons.flight,
            () {},
          ),
          _buildActionButton(
            context,
            AppConstants.bookCarButton,
            Icons.directions_car,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.categoriesTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppTheme.paddingSmall),
                Text(
                  AppConstants.categoriesSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingMedium,
              ),
              itemCount: Category.categories.length,
              itemBuilder: (context, index) {
                final category = Category.categories[index];
                return CategoryCard(
                  title: category.title,
                  imageUrl: category.imageUrl,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitiesSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.citiesTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.paddingSmall),
            Text(
              AppConstants.citiesSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.paddingMedium,
                mainAxisSpacing: AppTheme.paddingMedium,
                childAspectRatio: 0.8,
              ),
              itemCount: City.cities.length,
              itemBuilder: (context, index) {
                final city = City.cities[index];
                return CityCard(
                  name: city.name,
                  imageUrl: city.imageUrl,
                  description: city.description,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: AppTheme.paddingMedium),
            Text(
              'إقليم كردستان العراق',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.paddingSmall),
            Text(
              'يقع إقليم كردستان في شمال العراق، وهو منطقة ذات حكم ذاتي تتميز بجمال طبيعتها الخلابة، تراثها الثقافي الغني، ومعالمها التاريخية العريقة.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            ElevatedButton(
              onPressed: () {},
              child: const Text('اكتشف المزيد عن كردستان'),
            ),
          ],
        ),
      ),
    );
  }
}
