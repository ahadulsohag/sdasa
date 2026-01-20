import 'package:flutter/material.dart';

class ShelterManagementScreen extends StatelessWidget {
  const ShelterManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shelter Management')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ShelterCard(
            name: 'Central High School Shelter',
            capacity: '500 / 1000',
            status: 'Full',
            color: Colors.red,
          ),
          _ShelterCard(
            name: 'Community Center B',
            capacity: '120 / 300',
            status: 'Available',
            color: Colors.green,
          ),
          _ShelterCard(
            name: 'North Park Stadium',
            capacity: '45 / 500',
            status: 'Available',
            color: Colors.green,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Shelter functionality coming soon!'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ShelterCard extends StatelessWidget {
  final String name;
  final String capacity;
  final String status;
  final Color color;

  const _ShelterCard({
    required this.name,
    required this.capacity,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Occupancy: $capacity',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Manage Inventory'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('View on Map'),
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
