import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/models.dart';

class DummyData {
  static const List<RiderUser> users = [
    RiderUser(id: 'u1', name: 'Rahul Sharma',  phone: '+91 98765 43210', avatarColorValue: 0xFFE53935),
    RiderUser(id: 'u2', name: 'Priya Mehta',   phone: '+91 87654 32109', avatarColorValue: 0xFF7B1FA2),
    RiderUser(id: 'u3', name: 'Arjun Singh',   phone: '+91 76543 21098', avatarColorValue: 0xFF1565C0),
    RiderUser(id: 'u4', name: 'Sneha Nair',    phone: '+91 65432 10987', avatarColorValue: 0xFF2E7D32),
    RiderUser(id: 'u5', name: 'Vikram Patel',  phone: '+91 54321 09876', avatarColorValue: 0xFFE65100),
    RiderUser(id: 'u6', name: 'Kavya Reddy',   phone: '+91 43210 98765', avatarColorValue: 0xFF00838F),
  ];

  static final List<RideGroup> groups = [
    RideGroup(
      id: 'g1',
      name: 'Thunder Bikers',
      ownerId: 'u1',
      memberIds: ['u1', 'u2', 'u3', 'u4', 'u5', 'u6'],
      description: 'Weekend adventure riders from Bangalore',
    ),
    RideGroup(
      id: 'g2',
      name: 'Highway Wolves',
      ownerId: 'u3',
      memberIds: ['u3', 'u4', 'u5'],
      description: 'Long distance touring group',
    ),
    RideGroup(
      id: 'g3',
      name: 'City Cruisers',
      ownerId: 'u2',
      memberIds: ['u1', 'u2', 'u6'],
      description: 'City exploration rides every Sunday',
    ),
  ];

  // Bangalore → Nandi Hills route
  static final List<LatLng> bangaloreToNandiRoute = [
    const LatLng(12.9716, 77.5946),
    const LatLng(12.9880, 77.6060),
    const LatLng(13.0000, 77.6180),
    const LatLng(13.0150, 77.6350),
    const LatLng(13.0280, 77.6520),
    const LatLng(13.0370, 77.6829),
  ];

  static RiderUser currentUser = users[0];

  static RideSession createRide({
    required String name,
    required String destination,
    required double threshold,
    required String groupId,
  }) {
    return RideSession(
      id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
      groupId: groupId,
      name: name,
      destination: destination,
      connectivityThreshold: threshold,
      route: bangaloreToNandiRoute,
      startTime: DateTime.now(),
    );
  }

  // Initial positions: spacing of ~0.0008° ≈ 88m lat + 76m lng ≈ 116m diagonal (< 200m threshold)
  // Gap between front and back group is ~1.7 km (split detected)
  static List<RiderLocation> getInitialLocations() => [
    // Front group — Component A (riders ~116m apart from each other)
    RiderLocation(riderId: 'u1', latitude: 13.0155, longitude: 77.6355, speed: 52, heading: 45, routeProgress: 5800),
    RiderLocation(riderId: 'u2', latitude: 13.0147, longitude: 77.6347, speed: 48, heading: 45, routeProgress: 5680),
    RiderLocation(riderId: 'u3', latitude: 13.0139, longitude: 77.6339, speed: 50, heading: 45, routeProgress: 5560),
    // ── gap ~1.7 km here — split detected ──
    // Back group — Component B (riders ~116m apart from each other)
    RiderLocation(riderId: 'u4', latitude: 12.9985, longitude: 77.6185, speed: 45, heading: 45, routeProgress: 3700),
    RiderLocation(riderId: 'u5', latitude: 12.9977, longitude: 77.6177, speed: 47, heading: 45, routeProgress: 3580),
    RiderLocation(riderId: 'u6', latitude: 12.9969, longitude: 77.6169, speed: 43, heading: 45, routeProgress: 3460),
  ];

  static RiderUser userById(String id) =>
      users.firstWhere((u) => u.id == id, orElse: () => users[0]);

  static RideGroup groupById(String id) =>
      groups.firstWhere((g) => g.id == id, orElse: () => groups[0]);

  static List<RideGroup> groupsForUser(String userId) =>
      groups.where((g) => g.memberIds.contains(userId)).toList();

  static Color colorOf(RiderUser user) => Color(user.avatarColorValue);
}
