import 'package:flutter/material.dart';

class SosManagementScreen extends StatelessWidget {
  const SosManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS Requests'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SosRequestTile(
            userName: 'Jamal Ahmed',
            location: 'Sector 4, Uttara',
            time: '2 mins ago',
            status: 'Critical',
          ),
          _SosRequestTile(
            userName: 'Sara Rahman',
            location: 'Banani Road 11',
            time: '8 mins ago',
            status: 'Moderate',
          ),
          _SosRequestTile(
            userName: 'Tanvir Hossain',
            location: 'Mirpur DOHS',
            time: '15 mins ago',
            status: 'Critical',
          ),
        ],
      ),
    );
  }
}

class _SosRequestTile extends StatelessWidget {
  final String userName;
  final String location;
  final String time;
  final String status;

  const _SosRequestTile({
    required this.userName,
    required this.location,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCritical = status == 'Critical';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: isCritical ? Colors.red : Colors.orange),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ActionChip(
                          label: const Text('Assign Volunteer'),
                          onPressed: () {},
                          avatar: const Icon(Icons.person_add, size: 16),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          label: const Text('Call'),
                          onPressed: () {},
                          avatar: const Icon(Icons.phone, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
