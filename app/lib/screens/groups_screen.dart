import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import 'create_group_screen.dart';
import 'group_detail_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = DummyData.groupsForUser(DummyData.currentUser.id);
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text('My Groups', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFE53935)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateGroupScreen())),
          ),
        ],
      ),
      body: groups.isEmpty
          ? const Center(child: Text('No groups yet', style: TextStyle(color: Colors.white38)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) => _GroupCard(group: groups[i]),
            ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});
  final RideGroup group;

  @override
  Widget build(BuildContext context) {
    final owner = DummyData.userById(group.ownerId);
    final isOwner = group.ownerId == DummyData.currentUser.id;

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => GroupDetailScreen(group: group))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.motorcycle, color: Color(0xFFE53935), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.name,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(group.description,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                if (isOwner)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Owner', style: TextStyle(color: Color(0xFFE53935), fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.people_outline, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text('${group.memberIds.length} members',
                    style: const TextStyle(color: Colors.white38, fontSize: 13)),
                const SizedBox(width: 16),
                const Icon(Icons.admin_panel_settings_outlined, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text('Led by ${owner.name.split(' ')[0]}',
                    style: const TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            // Member avatars
            Row(
              children: [
                ...group.memberIds.take(5).map((uid) {
                  final u = DummyData.userById(uid);
                  return Align(
                    widthFactor: 0.7,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(u.avatarColorValue),
                      child: Text(u.initials, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  );
                }),
                if (group.memberIds.length > 5)
                  Align(
                    widthFactor: 0.7,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white12,
                      child: Text('+${group.memberIds.length - 5}',
                          style: const TextStyle(color: Colors.white54, fontSize: 9)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
