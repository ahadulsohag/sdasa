import 'package:flutter/material.dart';
import '../weather/weather_card.dart';

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  bool _isActive = true;

  void _showFeatureNote(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon in the next update!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const WeatherCard(),
            const SizedBox(height: 24),
            // Status Card
            Card(
              color: _isActive ? Colors.green.shade50 : Colors.grey.shade100,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _isActive ? Colors.green : Colors.grey,
                      child: Icon(
                        _isActive ? Icons.check : Icons.power_settings_new,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: ${_isActive ? "Active" : "Inactive"}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isActive
                                      ? Colors.green.shade900
                                      : Colors.grey.shade900,
                                ),
                          ),
                          Text(
                            _isActive
                                ? 'Ready to respond'
                                : 'Currently off-duty',
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isActive,
                      activeThumbColor: Colors.green,
                      onChanged: (val) => setState(() => _isActive = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showFeatureNote('New Tasks Module'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.assignment),
                    label: const Text('New Tasks'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showFeatureNote('History Module'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('History'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent Activity Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Assigned Tasks',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: Text('Task #${100 + index}'),
                    subtitle: const Text('Deliver supplies to Shelter A'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showFeatureNote('Task Details'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
