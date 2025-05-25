import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/city.dart';
import '../services/service_locator.dart';
import '../widgets/loading_indicator.dart';
import '../config/theme.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['المدن', 'المعالم السياحية', 'الفنادق'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCitiesList(),
          _buildAttractionsList(),
          _buildHotelsList(),
        ],
      ),
    );
  }

  Widget _buildCitiesList() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final favorites = serviceLocator.storageService.getFavorites();
        final favoriteCities = appState.cities
            .where((city) => favorites.contains(city.name))
            .toList();

        if (favoriteCities.isEmpty) {
          return _buildEmptyState('لم تقم بإضافة أي مدن إلى المفضلة');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteCities.length,
          itemBuilder: (context, index) {
            final city = favoriteCities[index];
            return _buildCityCard(city);
          },
        );
      },
    );
  }

  Widget _buildAttractionsList() {
    final favorites = serviceLocator.storageService.getFavorites();
    if (favorites.isEmpty) {
      return _buildEmptyState('لم تقم بإضافة أي معالم سياحية إلى المفضلة');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return _buildAttractionCard(favorites[index]);
      },
    );
  }

  Widget _buildHotelsList() {
    final favorites = serviceLocator.storageService.getFavorites();
    if (favorites.isEmpty) {
      return _buildEmptyState('لم تقم بإضافة أي فنادق إلى المفضلة');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return _buildHotelCard(favorites[index]);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('استكشف المزيد'),
          ),
        ],
      ),
    );
  }

  Widget _buildCityCard(City city) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => serviceLocator.navigationService.navigateToCityDetails(city),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                city.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    city.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'إزالة من المفضلة',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => _removeFromFavorites(city.name),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttractionCard(String attractionId) {
    // In a real app, you would fetch attraction details from your data source
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(attractionId),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _removeFromFavorites(attractionId),
        ),
      ),
    );
  }

  Widget _buildHotelCard(String hotelId) {
    // In a real app, you would fetch hotel details from your data source
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(hotelId),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _removeFromFavorites(hotelId),
        ),
      ),
    );
  }

  Future<void> _removeFromFavorites(String itemId) async {
    final confirmed = await serviceLocator.showConfirmation(
      'هل أنت متأكد من رغبتك في إزالة هذا العنصر من المفضلة؟',
    );

    if (confirmed) {
      await serviceLocator.storageService.removeFromFavorites(itemId);
      setState(() {});
      if (mounted) {
        serviceLocator.showSnackBar('تم إزالة العنصر من المفضلة');
      }
    }
  }
}
