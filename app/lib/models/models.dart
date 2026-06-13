import 'package:latlong2/latlong.dart';

class RiderUser {
  final String id;
  final String name;
  final String phone;
  final int avatarColorValue;

  const RiderUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarColorValue,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class RideGroup {
  final String id;
  final String name;
  final String ownerId;
  final List<String> memberIds;
  final String description;

  const RideGroup({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.memberIds,
    required this.description,
  });
}

class RideSession {
  final String id;
  final String groupId;
  final String name;
  final String destination;
  final double connectivityThreshold;
  final List<LatLng> route;
  final DateTime startTime;

  RideSession({
    required this.id,
    required this.groupId,
    required this.name,
    required this.destination,
    required this.connectivityThreshold,
    required this.route,
    required this.startTime,
  });
}

class RiderLocation {
  final String riderId;
  double latitude;
  double longitude;
  double speed;
  double heading;
  double routeProgress;

  RiderLocation({
    required this.riderId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.routeProgress,
  });
}

class ConnectivityComponent {
  final List<String> riderIds;
  final bool isPrimary;

  const ConnectivityComponent({
    required this.riderIds,
    required this.isPrimary,
  });
}
