import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';
import '../providers/ride_provider.dart';
import 'active_ride_screen.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key, required this.group});
  final RideGroup group;

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final _nameCtrl  = TextEditingController(text: 'Weekend Ride to Nandi Hills');
  final _destCtrl  = TextEditingController(text: 'Nandi Hills, Karnataka');
  double _threshold = 200;
  bool _loading = false;

  Future<void> _startRide() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final ride = DummyData.createRide(
      name: _nameCtrl.text.trim(),
      destination: _destCtrl.text.trim(),
      threshold: _threshold,
      groupId: widget.group.id,
    );

    context.read<RideProvider>().startRide(ride);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ActiveRideScreen()),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        foregroundColor: Colors.white,
        title: const Text('Plan a Ride', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Group info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_outline, color: Color(0xFFE53935), size: 20),
                const SizedBox(width: 10),
                Text(widget.group.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text('· ${widget.group.memberIds.length} riders',
                    style: const TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('RIDE DETAILS', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          _field('Ride Name', _nameCtrl, Icons.edit_road_outlined),
          const SizedBox(height: 14),
          _field('Destination', _destCtrl, Icons.location_on_outlined),
          const SizedBox(height: 28),

          // Route preview
          const Text('ROUTE', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _routeStop('Bangalore City Center', '12.97°N, 77.59°E', isStart: true),
                _routeDot(),
                _routeStop('NH 44 Junction', '13.00°N, 77.62°E'),
                _routeDot(),
                _routeStop('Nandi Hills', '13.03°N, 77.68°E', isEnd: true),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Icon(Icons.straighten, color: Colors.white38, size: 14),
                    SizedBox(width: 6),
                    Text('62 km  ·  ~1h 30min', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Connectivity threshold
          const Text('CONNECTIVITY SETTINGS', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gap Threshold', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${_threshold.toInt()} m',
                          style: const TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Alert when gap between riders exceeds this distance',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
                Slider(
                  value: _threshold,
                  min: 50,
                  max: 500,
                  divisions: 9,
                  activeColor: const Color(0xFFE53935),
                  inactiveColor: Colors.white12,
                  onChanged: (v) => setState(() => _threshold = v),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('50 m', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    Text('500 m', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _startRide,
              icon: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.play_arrow_rounded, size: 26),
              label: const Text('Start Ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _field(String label, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
      ),
    );
  }

  Widget _routeStop(String name, String coord, {bool isStart = false, bool isEnd = false}) {
    return Row(
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStart ? Colors.green : isEnd ? const Color(0xFFE53935) : Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(coord, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _routeDot() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 3, bottom: 3),
      child: Column(children: List.generate(4, (_) => Container(
        width: 2, height: 4, margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(1)),
      ))),
    );
  }
}
