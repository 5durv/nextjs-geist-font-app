import 'package:flutter/material.dart';
import '../services/service_locator.dart';
import '../models/city.dart';
import '../config/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['الأماكن المزارة', 'عمليات البحث'];

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
        title: const Text('السجل'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showClearHistoryDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVisitedPlaces(),
          _buildSearchHistory(),
        ],
      ),
    );
  }

  Widget _buildVisitedPlaces() {
    final visitedPlaces = serviceLocator.storageService.getLastVisited();

    if (visitedPlaces.isEmpty) {
      return _buildEmptyState(
        icon: Icons.place_outlined,
        message: 'لم تقم بزيارة أي أماكن بعد',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: visitedPlaces.length,
      itemBuilder: (context, index) {
        final cityId = visitedPlaces[index];
        return _buildVisitedPlaceCard(cityId);
      },
    );
  }

  Widget _buildVisitedPlaceCard(String cityId) {
    // In a real app, you would fetch the city details from your data source
    final city = City.cities.firstWhere(
      (city) => city.name == cityId,
      orElse: () => City(
        name: cityId,
        imageUrl: 'https://via.placeholder.com/150',
        description: 'لا يوجد وصف',
        longDescription: '',
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(city.imageUrl),
        ),
        title: Text(city.name),
        subtitle: Text(
          'تمت الزيارة في ${DateTime.now().toString().split(' ')[0]}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: Colors.red,
          onPressed: () => _removeFromHistory(cityId),
        ),
        onTap: () {
          serviceLocator.navigationService.navigateToCityDetails(city);
        },
      ),
    );
  }

  Widget _buildSearchHistory() {
    final searches = serviceLocator.storageService.getRecentSearches();

    if (searches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off_outlined,
        message: 'لا توجد عمليات بحث سابقة',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searches.length,
      itemBuilder: (context, index) {
        final search = searches[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.history),
            title: Text(search),
            subtitle: Text(
              'تم البحث في ${DateTime.now().toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              onPressed: () => _removeSearchItem(search),
            ),
            onTap: () {
              // Perform the search again
              Navigator.pop(context, search);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
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
        ],
      ),
    );
  }

  Future<void> _removeFromHistory(String cityId) async {
    final confirmed = await serviceLocator.showConfirmation(
      'هل تريد إزالة هذا المكان من السجل؟',
    );

    if (confirmed) {
      final visited = serviceLocator.storageService.getLastVisited();
      visited.remove(cityId);
      await serviceLocator.storageService.setStringList('last_visited', visited);
      setState(() {});
    }
  }

  Future<void> _removeSearchItem(String search) async {
    final confirmed = await serviceLocator.showConfirmation(
      'هل تريد إزالة عملية البحث هذه من السجل؟',
    );

    if (confirmed) {
      final searches = serviceLocator.storageService.getRecentSearches();
      searches.remove(search);
      await serviceLocator.storageService.setStringList('recent_searches', searches);
      setState(() {});
    }
  }

  Future<void> _showClearHistoryDialog() async {
    final confirmed = await serviceLocator.showConfirmation(
      'هل أنت متأكد من رغبتك في مسح السجل بالكامل؟',
    );

    if (confirmed) {
      if (_tabController.index == 0) {
        await serviceLocator.storageService.setStringList('last_visited', []);
      } else {
        await serviceLocator.storageService.setStringList('recent_searches', []);
      }
      setState(() {});
    }
  }
}
