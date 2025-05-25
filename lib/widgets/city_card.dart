import 'package:flutter/material.dart';
import '../models/city.dart';
import '../screens/city_details_screen.dart';

class CityCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;

  const CityCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  void _navigateToCityDetails(BuildContext context) {
    final city = City(
      name: name,
      imageUrl: imageUrl,
      description: description,
      longDescription: 'تفاصيل إضافية عن $name ومعالمها السياحية والتاريخية.',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsScreen(city: city),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToCityDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
