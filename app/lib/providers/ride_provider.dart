import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/models.dart';
import '../data/dummy_data.dart';

class RideProvider extends ChangeNotifier {
  RideSession? _activeRide;
  List<RiderLocation> _locations = [];
  List<ConnectivityComponent> _components = [];
  bool _splitDetected = false;
  Timer? _timer;
  final _rand = Random();
  static const _dist = Distance();

  RideSession? get activeRide => _activeRide;
  List<RiderLocation> get locations => List.unmodifiable(_locations);
  List<ConnectivityComponent> get components => List.unmodifiable(_components);
  bool get splitDetected => _splitDetected;
  bool get isActive => _activeRide != null;

  void startRide(RideSession ride) {
    _activeRide = ride;
    _locations = DummyData.getInitialLocations();
    _calcConnectivity();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _moveRiders();
      _calcConnectivity();
      notifyListeners();
    });
    notifyListeners();
  }

  void endRide() {
    _timer?.cancel();
    _activeRide = null;
    _locations = [];
    _components = [];
    _splitDetected = false;
    notifyListeners();
  }

  void _moveRiders() {
    for (final loc in _locations) {
      loc.speed = (loc.speed + (_rand.nextDouble() * 4 - 2)).clamp(25.0, 80.0);
      // Base movement toward Nandi Hills (NE). 4-second tick at current speed.
      final base = (loc.speed / 3600) * 4 / 111.0;
      // Tiny jitter (±3% of base) keeps riders in the same group within ~10m
      // of each other per tick, so they never drift past the 200m threshold.
      final jitter = base * 0.03;
      loc.latitude  += base + (_rand.nextDouble() * 2 - 1) * jitter;
      loc.longitude += base + (_rand.nextDouble() * 2 - 1) * jitter;
      loc.routeProgress += (loc.speed / 3600) * 4 * 1000;
    }
  }

  void _calcConnectivity() {
    if (_locations.isEmpty) return;
    final threshold = _activeRide?.connectivityThreshold ?? 200;

    final sorted = [..._locations]
      ..sort((a, b) => b.routeProgress.compareTo(a.routeProgress));

    final comps = <ConnectivityComponent>[];
    var group = <String>[sorted[0].riderId];

    for (var i = 1; i < sorted.length; i++) {
      final gap = _dist(
        LatLng(sorted[i - 1].latitude, sorted[i - 1].longitude),
        LatLng(sorted[i].latitude,     sorted[i].longitude),
      );
      if (gap > threshold) {
        comps.add(ConnectivityComponent(riderIds: List.from(group), isPrimary: comps.isEmpty));
        group = [];
      }
      group.add(sorted[i].riderId);
    }
    comps.add(ConnectivityComponent(riderIds: group, isPrimary: comps.isEmpty));

    // Largest group = primary
    comps.sort((a, b) => b.riderIds.length.compareTo(a.riderIds.length));
    _components = comps;
    _splitDetected = comps.length > 1;
  }

  String componentLabel(String riderId) {
    for (var i = 0; i < _components.length; i++) {
      if (_components[i].riderIds.contains(riderId)) {
        return String.fromCharCode(65 + i); // A, B, C …
      }
    }
    return '-';
  }

  Color componentColor(String riderId) {
    final idx = componentLabel(riderId).codeUnitAt(0) - 65;
    const colors = [Colors.green, Colors.redAccent, Colors.orange, Colors.blue];
    return idx >= 0 && idx < colors.length ? colors[idx] : Colors.grey;
  }

  RiderLocation? locationOf(String riderId) {
    try { return _locations.firstWhere((r) => r.riderId == riderId); }
    catch (_) { return null; }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
