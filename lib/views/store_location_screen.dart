import 'package:cafe_frontend/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreLocationScreen extends StatelessWidget {
  StoreLocationScreen({super.key});

  // coordinated of ETEC
  final LatLng storeLocation = LatLng(11.570863, 104.897367);
  final Uri osmUrl = Uri.parse('https://www.openstreetmap.org/copyright');

  Future<void> openOsm() async {
    await launchUrl(osmUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Location',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 780,
            width: 500,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: storeLocation,
                initialZoom: 15,
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
                      point: storeLocation,
                      width: 42,
                      height: 42,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: AppTheme.floatingShadow,
                        ),
                        child: const Icon(
                          Icons.local_cafe,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SimpleAttributionWidget(
                  source: const Text('OpenStreetMap contributors'),
                  onTap: openOsm,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              openGoogleMaps();
            },
            child: Text('Visit us'),
          ),
        ],
      ),
    );
  }
}

final Uri googleMapsUrl = Uri.parse(
  'https://www.google.com/maps/search/?api=1&query=11.570863,104.897367',
);

Future<void> openGoogleMaps() async {
  if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not open Google Maps');
  }
}

// Widget _buildTopBar(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(
//       horizontal: AppTheme.pagePadding,
//       vertical: 8,
//     ),
//     child: Row(
//       children: [
//         IconButton(
//           style: ButtonStyle(),
//           tooltip: 'Back',
//           onPressed: () => Navigator.of(context).maybePop(),
//           icon: const Icon(Icons.arrow_back),
//         ),
//         SizedBox(width: 105),
//         Text('The Brew', style: Theme.of(context).textTheme.headlineSmall),
//       ],
//     ),
//   );
// }
