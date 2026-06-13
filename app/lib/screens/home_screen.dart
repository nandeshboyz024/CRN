import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../providers/ride_provider.dart';
import 'groups_screen.dart';
import 'active_ride_screen.dart';
import 'group_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: IndexedStack(
        index: _tab,
        children: const [_DashboardTab(), GroupsScreen(), _ProfileTab()],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF141414),
        indicatorColor: const Color(0xFFE53935).withAlpha(40),
        selectedIndex: _tab,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),   selectedIcon: Icon(Icons.home,   color: Color(0xFFE53935)), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_outline),  selectedIcon: Icon(Icons.people, color: Color(0xFFE53935)), label: 'Groups'),
          NavigationDestination(icon: Icon(Icons.person_outline),  selectedIcon: Icon(Icons.person, color: Color(0xFFE53935)), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── Dashboard Tab ────────────────────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final rp   = context.watch<RideProvider>();
    final user = DummyData.currentUser;
    final myGroups = DummyData.groupsForUser(user.id);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF0D0D0D),
            floating: true,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(user.avatarColorValue),
                  child: Text(user.initials,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hey, ${user.name.split(' ')[0]}!',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const Text('Ready to ride?', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Active ride card ─────────────────────────────
                if (rp.isActive) ...[
                  _ActiveRideCard(rp: rp),
                  const SizedBox(height: 20),
                ] else ...[
                  _NoRideCard(),
                  const SizedBox(height: 20),
                ],

                // ── Quick stats ──────────────────────────────────
                Row(children: [
                  _QuickStat(icon: Icons.people, label: 'Groups',  value: '${myGroups.length}'),
                  const SizedBox(width: 10),
                  _QuickStat(icon: Icons.route,  label: 'Rides',   value: '12', color: Colors.blue),
                  const SizedBox(width: 10),
                  _QuickStat(icon: Icons.straighten, label: 'km',  value: '742', color: Colors.orange),
                ]),
                const SizedBox(height: 24),

                // ── My groups ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Groups', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See all', style: TextStyle(color: Color(0xFFE53935))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...myGroups.map((g) => GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GroupDetailScreen(group: g))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.motorcycle, color: Color(0xFFE53935), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              Text('${g.memberIds.length} members  ·  ${g.description}',
                                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white24),
                      ],
                    ),
                  ),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveRideCard extends StatelessWidget {
  const _ActiveRideCard({required this.rp});
  final RideProvider rp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveRideScreen())),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB71C1C), Color(0xFFE53935)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: const Color(0xFFE53935).withAlpha(80), blurRadius: 20, spreadRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                  child: const Row(children: [
                    SizedBox(width: 6, height: 6, child: DecoratedBox(decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle))),
                    SizedBox(width: 5),
                    Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ]),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
              ],
            ),
            const SizedBox(height: 12),
            Text(rp.activeRide!.name,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('→ ${rp.activeRide!.destination}',
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoPill(icon: Icons.people, label: '${rp.locations.length} riders'),
                const SizedBox(width: 8),
                _InfoPill(
                  icon: rp.splitDetected ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                  label: rp.splitDetected ? '${rp.components.length} groups' : 'All connected',
                  color: rp.splitDetected ? Colors.orange : Colors.greenAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoRideCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Icon(Icons.motorcycle, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          const Text('No active ride', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Go to Groups → Start a Ride', style: TextStyle(color: Colors.white38, fontSize: 13)),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({required this.icon, required this.label, required this.value, this.color = const Color(0xFFE53935)});
  final IconData icon;
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label, this.color = Colors.white70});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withAlpha(20), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─── Profile Tab ──────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Color(user.avatarColorValue),
                  child: Text(user.initials,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 14),
                Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.phone, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('RIDE STATS', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          _ProfileStat(icon: Icons.route,         label: 'Total Rides',      value: '12'),
          _ProfileStat(icon: Icons.straighten,    label: 'Total Distance',   value: '742 km'),
          _ProfileStat(icon: Icons.group,         label: 'Groups Joined',    value: '3'),
          _ProfileStat(icon: Icons.emoji_events,  label: 'Longest Ride',     value: '124 km'),
          const SizedBox(height: 24),
          const Text('SETTINGS', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          _ProfileStat(icon: Icons.notifications_outlined, label: 'Push Notifications', value: 'On',  isToggle: true),
          _ProfileStat(icon: Icons.location_on_outlined,   label: 'Background Location', value: 'On', isToggle: true),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.icon, required this.label, required this.value, this.isToggle = false});
  final IconData icon;
  final String label, value;
  final bool isToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE53935), size: 20),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14))),
          Text(value, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          if (isToggle) ...[const SizedBox(width: 8), const Icon(Icons.chevron_right, color: Colors.white24, size: 18)],
        ],
      ),
    );
  }
}
