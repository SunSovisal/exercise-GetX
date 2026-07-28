import 'package:cafe_frontend/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreLocationScreen extends StatelessWidget {
  StoreLocationScreen({super.key});

  static final LatLng _storeLocation = LatLng(11.570863, 104.897367);

  final Uri _osmUrl = Uri.parse('https://www.openstreetmap.org/copyright');

  final Uri _googleMapsUrl = Uri.parse(
    'https://www.google.com/maps/search/'
    '?api=1&query=11.570863,104.897367',
  );

  Future<void> _openGoogleMaps(BuildContext context) async {
    final opened = await launchUrl(
      _googleMapsUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  Future<void> _openOsm() async {
    await launchUrl(_osmUrl);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final mapHeight = (screenHeight * 0.43).clamp(300.0, 390.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Location',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppTheme.contentMaxWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppTheme.pagePadding,
                12,
                AppTheme.pagePadding,
                28,
              ),
              children: [
                Text(
                  'Your next cup is nearby',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 6),
                Text(
                  'Come visit The Brew and enjoy your favorite coffee '
                  'with us.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 20),
                _MapCard(height: mapHeight, onAttributionTap: _openOsm),
                SizedBox(height: 16),
                _LocationCard(),
                SizedBox(height: 20),
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () => _openGoogleMaps(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(Icons.directions_outlined, size: 20),
                    label: Text('Open in Google Maps'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.height, required this.onAttributionTap});

  final double height;
  final VoidCallback onAttributionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: StoreLocationScreen._storeLocation,
                initialZoom: 16,
                minZoom: 3,
                maxZoom: 20,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.cafe_frontend',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: StoreLocationScreen._storeLocation,
                      width: 58,
                      height: 58,
                      child: _StoreMarker(),
                    ),
                  ],
                ),
                SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                  onTap: onAttributionTap,
                ),
              ],
            ),
            Positioned(
              top: 14,
              left: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: AppTheme.floatingShadow,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_cafe_outlined,
                        size: 18,
                        color: AppTheme.primary,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'The Brew',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreMarker extends StatelessWidget {
  const _StoreMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppTheme.floatingShadow,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.local_cafe, color: Colors.white, size: 23),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.location_on_outlined, color: AppTheme.primary),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Brew at ITC',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4),
                Text(
                  'Phnom Penh, Cambodia',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '11.570863, 104.897367',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
