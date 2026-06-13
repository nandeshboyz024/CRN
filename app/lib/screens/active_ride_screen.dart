import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../providers/ride_provider.dart';
import 'rider_dashboard_screen.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});
  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  late final MapController _mapController;
  bool _followMode    = true;
  bool _panelExpanded = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RideProvider>().addListener(_onUpdate);
    });
  }

  void _onUpdate() {
    if (!_followMode || !mounted) return;
    final locs = context.read<RideProvider>().locations;
    if (locs.isEmpty) return;
    final lat = locs.map((l) => l.latitude).reduce((a, b) => a + b)  / locs.length;
    final lng = locs.map((l) => l.longitude).reduce((a, b) => a + b) / locs.length;
    _mapController.move(LatLng(lat, lng), 14);
  }

  @override
  void dispose() {
    context.read<RideProvider>().removeListener(_onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideProvider>(
      builder: (context, rp, _) {
        final ride = rp.activeRide;
        if (ride == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0D0D),
            body: Center(child: Text('No active ride', style: TextStyle(color: Colors.white))),
          );
        }

        final markers = rp.locations.map((loc) {
          final user  = DummyData.userById(loc.riderId);
          final color = rp.componentColor(loc.riderId);
          final label = rp.componentLabel(loc.riderId);
          return Marker(
            width: 64,
            height: 72,
            point: LatLng(loc.latitude, loc.longitude),
            child: _RiderMarker(user: user, color: color, speed: loc.speed, label: label),
          );
        }).toList();

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D0D0D),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ride.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text('→ ${ride.destination}  ·  threshold ${ride.connectivityThreshold.toInt()} m',
                    style: const TextStyle(fontSize: 10, color: Colors.white38)),
              ],
            ),
            actions: [
              IconButton(
                tooltip: _followMode ? 'Following group' : 'Follow off',
                icon: Icon(
                  _followMode ? Icons.gps_fixed : Icons.gps_not_fixed,
                  color: _followMode ? const Color(0xFFE53935) : Colors.white54,
                ),
                onPressed: () => setState(() => _followMode = !_followMode),
              ),
              IconButton(
                tooltip: 'Rider dashboard',
                icon: const Icon(Icons.bar_chart_rounded),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RiderDashboardScreen())),
              ),
              PopupMenuButton<String>(
                color: const Color(0xFF1A1A1A),
                onSelected: (v) {
                  if (v == 'end') {
                    rp.endRide();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'end',
                      child: Text('End Ride', style: TextStyle(color: Colors.redAccent))),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              // ── MAP ──────────────────────────────────────────────────
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(13.0050, 77.6250),
                  initialZoom: 13.5,
                  onTap: (tap, pt) => setState(() => _followMode = false),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(polylines: [
                    Polyline(
                      points: ride.route,
                      color: const Color(0xFF1565C0),
                      strokeWidth: 4,
                    ),
                  ]),
                  MarkerLayer(markers: markers),
                ],
              ),

              // ── CONNECTIVITY STATUS BAR ───────────────────────────────
              Positioned(
                top: 8, left: 12, right: 12,
                child: _ConnectivityBanner(rp: rp),
              ),

              // ── BOTTOM PANEL ─────────────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _BottomPanel(
                  rp: rp,
                  expanded: _panelExpanded,
                  onToggle: () => setState(() => _panelExpanded = !_panelExpanded),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Rider marker widget on map ─────────────────────────────────────────────
class _RiderMarker extends StatelessWidget {
  const _RiderMarker({required this.user, required this.color, required this.speed, required this.label});
  final RiderUser user;
  final Color color;
  final double speed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Color(user.avatarColorValue),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
                boxShadow: [BoxShadow(color: color.withAlpha(140), blurRadius: 10, spreadRadius: 1)],
              ),
              child: Center(
                child: Text(user.initials,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              top: -4, right: -4,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
                child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
          child: Text('${speed.toInt()}km/h',
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// ── Connectivity status banner ─────────────────────────────────────────────
class _ConnectivityBanner extends StatelessWidget {
  const _ConnectivityBanner({required this.rp});
  final RideProvider rp;

  @override
  Widget build(BuildContext context) {
    final split = rp.splitDetected;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: split ? Colors.redAccent.withAlpha(220) : Colors.green.withAlpha(220),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(split ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              split
                  ? 'SPLIT DETECTED  ·  ${rp.components.length} groups separated'
                  : 'ALL CONNECTED  ·  ${rp.locations.length} riders in sync',
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom components panel ────────────────────────────────────────────────
class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.rp, required this.expanded, required this.onToggle});
  final RideProvider rp;
  final bool expanded;
  final VoidCallback onToggle;

  static const _compColors = [Colors.green, Colors.redAccent, Colors.orange, Colors.blue, Colors.purple];

  Color _colorFor(int idx) => idx < _compColors.length ? _compColors[idx] : Colors.grey;

  @override
  Widget build(BuildContext context) {
    final statusColor = rp.splitDetected ? Colors.redAccent : Colors.green;
    final statusText  = rp.splitDetected
        ? '${rp.components.length} groups split  ·  ${rp.locations.length} riders'
        : 'All ${rp.locations.length} riders connected';

    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      alignment: Alignment.bottomCenter,
      child: Container(
      constraints: BoxConstraints(maxHeight: expanded ? 260 : 56),
      decoration: const BoxDecoration(
        color: Color(0xF21A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header row — always visible ──────────────────────────────
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
              child: Row(
                children: [
                  // drag handle pill
                  Container(width: 32, height: 4,
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 12),
                  Icon(rp.splitDetected ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                      color: statusColor, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(statusText,
                        style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  // collapse / expand chevron
                  Icon(expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: Colors.white54, size: 22),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          // Scrollable component list — one row per component
          Flexible(
            child: rp.components.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Calculating connectivity…', style: TextStyle(color: Colors.white38)),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: rp.components.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 6),
                    itemBuilder: (ctx, idx) {
                      final comp  = rp.components[idx];
                      final color = _colorFor(idx);
                      final label = String.fromCharCode(65 + idx);
                      // avg speed
                      final speeds = comp.riderIds
                          .map((id) => rp.locationOf(id)?.speed ?? 0)
                          .where((s) => s > 0)
                          .toList();
                      final avgSpeed = speeds.isEmpty
                          ? 0
                          : (speeds.reduce((a, b) => a + b) / speeds.length).toInt();

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: color.withAlpha(18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color.withAlpha(70)),
                        ),
                        child: Row(
                          children: [
                            // Component label badge
                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                              child: Center(child: Text(label,
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                            ),
                            const SizedBox(width: 10),
                            // Rider count + avg speed
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${comp.riderIds.length} rider${comp.riderIds.length == 1 ? '' : 's'}',
                                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('avg $avgSpeed km/h',
                                    style: const TextStyle(color: Colors.white38, fontSize: 11)),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Rider avatar chips — scrollable row
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: comp.riderIds.map((rid) {
                                    final u   = DummyData.userById(rid);
                                    final loc = rp.locationOf(rid);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Color(u.avatarColorValue),
                                            child: Text(u.initials,
                                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(loc != null ? '${loc.speed.toInt()}' : '-',
                                              style: const TextStyle(color: Colors.white54, fontSize: 10)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (expanded) const SizedBox(height: 8),
        ],
      ),
    ),   // Container
    );   // AnimatedSize
  }
}
