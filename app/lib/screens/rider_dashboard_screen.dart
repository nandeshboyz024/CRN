import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../providers/ride_provider.dart';

class RiderDashboardScreen extends StatelessWidget {
  const RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        final locations = rideProvider.locations;
        final components = rideProvider.components;

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D0D0D),
            foregroundColor: Colors.white,
            title: const Text('Rider Status', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary row
              Row(
                children: [
                  _StatBox(label: 'Total Riders', value: '${locations.length}', color: Colors.blue),
                  const SizedBox(width: 10),
                  _StatBox(label: 'Components', value: '${components.length}',
                      color: components.length > 1 ? Colors.redAccent : Colors.green),
                  const SizedBox(width: 10),
                  _StatBox(
                    label: 'Status',
                    value: rideProvider.splitDetected ? 'SPLIT' : 'OK',
                    color: rideProvider.splitDetected ? Colors.redAccent : Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Components
              ...components.asMap().entries.map((entry) {
                final idx  = entry.key;
                final comp = entry.value;
                final label = String.fromCharCode(65 + idx);
                final color = idx == 0 ? Colors.green : Colors.redAccent;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withAlpha(80)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Component header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: color.withAlpha(20),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                              child: Center(child: Text(label,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                            ),
                            const SizedBox(width: 10),
                            Text('Component $label  ·  ${comp.riderIds.length} riders',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                            const Spacer(),
                            if (comp.isPrimary)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: Colors.green.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                                child: const Text('PRIMARY', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ),
                          ],
                        ),
                      ),
                      // Rider rows
                      ...comp.riderIds.map((rid) {
                        final user = DummyData.userById(rid);
                        final loc  = rideProvider.locationOf(rid);
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.white10)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(user.avatarColorValue),
                                child: Text(user.initials,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                    if (loc != null)
                                      Text('${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}',
                                          style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                  ],
                                ),
                              ),
                              if (loc != null) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.speed, color: Colors.white38, size: 14),
                                        const SizedBox(width: 4),
                                        Text('${loc.speed.toInt()} km/h',
                                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text('${(loc.routeProgress / 1000).toStringAsFixed(1)} km',
                                        style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
