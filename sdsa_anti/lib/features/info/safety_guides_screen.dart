import 'package:flutter/material.dart';

class SafetyGuidesScreen extends StatelessWidget {
  const SafetyGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Safety Guides'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.water_drop), text: 'Flood'),
              Tab(icon: Icon(Icons.terrain), text: 'Earthquake'),
              Tab(icon: Icon(Icons.local_fire_department), text: 'Fire'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _GuideContent(
              title: 'Flood Safety',
              points: [
                'Identify high ground and safe paths.',
                'Keep an emergency kit ready (food, water, radio).',
                'Do not walk or drive through floodwaters.',
                'Stay tuned to local weather alerts on the SDASA app.',
                'Disconnect electrical appliances if safe to do so.',
              ],
            ),
            _GuideContent(
              title: 'Earthquake Safety',
              points: [
                'Drop, Cover, and Hold On.',
                'Stay away from windows and heavy furniture.',
                'If outside, move to an open area away from buildings.',
                'Expect aftershocks.',
                'Do not use elevators.',
              ],
            ),
            _GuideContent(
              title: 'Fire Safety',
              points: [
                'Stay low to the ground to avoid smoke.',
                'Stop, Drop, and Roll if your clothes catch fire.',
                'Feel doors for heat before opening them.',
                'Have a pre-planned escape route.',
                'Call emergency services immediately.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideContent extends StatelessWidget {
  final String title;
  final List<String> points;

  const _GuideContent({required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(point, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'In case of immediate danger, use the SOS button on the main dashboard.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
