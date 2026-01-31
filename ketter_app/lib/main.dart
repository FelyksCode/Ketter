import 'package:flutter/material.dart';
import 'package:ketter_app/services/ews_service.dart';

void main() {
  runApp(const KetterApp());
}

class KetterApp extends StatelessWidget {
  const KetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ketter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006B6E), // Calming Teal
          brightness: Brightness.light,
          primary: const Color(0xFF006B6E),
          secondary: const Color(0xFF8BA6A9),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003738)),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _ewsService = EWSService();

  // Simulated vital signs
  double heartRate = 72.0;
  double temperature = 36.8;
  double spo2 = 98.0;
  double systolicBP = 120.0;
  double rr = 16.0;
  bool onOxygen = false;
  String consciousness = 'A';

  @override
  Widget build(BuildContext context) {
    final score = _ewsService.calculateNEWS2(
      respirationRate: rr,
      spo2: spo2,
      onOxygen: onOxygen,
      systolicBP: systolicBP,
      heartRate: heartRate,
      temperature: temperature,
      consciousness: consciousness,
    );

    final riskLevel = _ewsService.getRiskLevel(score);
    final statusColor = _getStatusColor(riskLevel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ketter Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              color: statusColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Health Status', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      riskLevel,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: statusColor),
                    ),
                    const SizedBox(height: 4),
                    Text('NEWS2 Score: $score', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Vital Signs', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _VitalTile(label: 'Heart Rate', value: '$heartRate bpm', icon: Icons.favorite),
                  _VitalTile(label: 'Temperature', value: '$temperature °C', icon: Icons.thermostat),
                  _VitalTile(label: 'SpO2', value: '$spo2 %', icon: Icons.air),
                  _VitalTile(label: 'Blood Pressure', value: '$systolicBP mmHg', icon: Icons.speed),
                  _VitalTile(label: 'Resp. Rate', value: '$rr /min', icon: Icons.lungs),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // In a real app, this would trigger a FHIR Communication alert
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checking in with your care team...')),
          );
        },
        label: const Text('Check In'),
        icon: const Icons.health_and_safety(),
      ),
    );
  }

  Color _getStatusColor(String level) {
    switch (level) {
      case 'Low': return Colors.green.shade700;
      case 'Medium': return Colors.orange.shade700;
      case 'High': return Colors.red.shade700;
      default: return Colors.grey;
    }
  }
}

class _VitalTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _VitalTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
