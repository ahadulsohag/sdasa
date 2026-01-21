import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/alert_model.dart';

class AlertService {
  final _supabase = Supabase.instance.client;

  // Fetch all alerts
  Future<List<AlertModel>> getAlerts() async {
    final response = await _supabase
        .from('alerts')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => AlertModel.fromJson(json)).toList();
  }

  // Create new alert (Admin only)
  Future<void> createAlert(AlertModel alert) async {
    await _supabase.from('alerts').insert(alert.toJson());
  }

  // Real-time alerts stream
  Stream<List<AlertModel>> getAlertsStream() {
    return _supabase
        .from('alerts')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) => data.map((json) => AlertModel.fromJson(json)).toList());
  }
}
