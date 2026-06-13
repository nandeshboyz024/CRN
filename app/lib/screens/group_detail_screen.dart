import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import 'create_ride_screen.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key, required this.group});
  final RideGroup group;

  @override
  Widget build(BuildContext context) {
    final owner   = DummyData.userById(group.ownerId);
    final members = group.memberIds.map(DummyData.userById).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        foregroundColor: Colors.white,
        title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Group header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF2A1010)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE53935).withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(color: const Color(0xFFE53935).withAlpha(30), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.motorcycle, color: Color(0xFFE53935), size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(group.description, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Chip(icon: Icons.people_outline, label: '${members.length} members'),
                    const SizedBox(width: 10),
                    _Chip(icon: Icons.star_outline, label: 'Led by ${owner.name.split(' ')[0]}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Members list
          const Text('Members', style: TextStyle(color: Colors.white54, fontSize: 13, letterSpacing: 1)),
          const SizedBox(height: 12),
          ...members.map((u) {
            final isOwner = u.id == group.ownerId;
            final isYou   = u.id == DummyData.currentUser.id;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: isYou ? Border.all(color: const Color(0xFFE53935).withAlpha(80)) : null,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(u.avatarColorValue),
                    child: Text(u.initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(u.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            if (isYou) ...[
                              const SizedBox(width: 6),
                              const Text('(You)', style: TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ],
                        ),
                        Text(u.phone, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (isOwner)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Leader', style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 28),

          // Start ride button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreateRideScreen(group: group))),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start a Ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white54),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}
