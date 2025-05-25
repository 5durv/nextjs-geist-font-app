import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/city.dart';
import '../models/category.dart';
import '../widgets/loading_indicator.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../services/service_locator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _searchQuery = '';
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    _recentSearches = serviceLocator.storageService.getRecentSearches();
    setState(() {});
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (query.isNotEmpty) {
      serviceLocator.storageService.addRecentSearch(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          decoration: InputDecoration(
            hintText: 'ابحث عن مدن، معالم سياحية، فنادق...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearch,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (_searchQuery.isEmpty) _buildRecentSearches(),
          if (_searchQuery.isNotEmpty) _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('لا توجد عمليات بحث سابقة'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'عمليات البحث السابقة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await serviceLocator.storageService.clearRecentSearches();
                  _recentSearches = [];
                  setState(() {});
                },
                child: const Text('مسح'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final search = _recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(search),
                onTap: () {
                  _searchController.text = search;
                  _onSearch(search);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    _recentSearches.removeAt(index);
                    await serviceLocator.storageService
                        .setStringList(AppConstants.keyRecentSearches, _recentSearches);
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final cities = appState.cities
            .where((city) =>
                city.name.contains(_searchQuery) ||
                city.description.contains(_searchQuery))
            .toList();

        final categories = Category.categories
            .where((category) =>
                category.title.contains(_searchQuery) ||
                category.description.contains(_searchQuery))
            .toList();

        if (cities.isEmpty && categories.isEmpty) {
          return const Center(
            child: Text('لا توجد نتائج للبحث'),
          );
        }

        return ListView(
          children: [
            if (cities.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'المدن',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...cities.map((city) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(city.imageUrl),
                    ),
                    title: Text(city.name),
                    subtitle: Text(city.description),
                    onTap: () {
                      serviceLocator.navigationService.navigateToCityDetails(city);
                    },
                  )),
            ],
            if (categories.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'الفئات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...categories.map((category) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(category.imageUrl),
                    ),
                    title: Text(category.title),
                    subtitle: Text(category.description),
                    onTap: () {
                      // Navigate to category details
                    },
                  )),
            ],
          ],
        );
      },
    );
  }
}
