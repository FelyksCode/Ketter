import 'package:flutter/material.dart';
import 'package:ketter_app/services/ews_service.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const KetterApp());
}

class KetterApp extends StatelessWidget {
  const KetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ketter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006B6E), // Warm Teal
          background: const Color(0xFFFDFCFB), // Soft White
          surface: const Color(0xFFFDFCFB),
          primary: const Color(0xFF006B6E),
          secondary: const Color(0xFF9CAF88), // Sage Green
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFE0F2F2),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF003738),
            fontSize: 28,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color(0xFF003738),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFF2F3E3F),
          ),
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

  // Heart rate trend data
  final List<FlSpot> _hrSpots = const [
    FlSpot(0, 68),
    FlSpot(1, 70),
    FlSpot(2, 75),
    FlSpot(3, 72),
    FlSpot(4, 74),
    FlSpot(5, 72),
    FlSpot(6, 71),
  ];

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
    final statusText = _getStatusText(riskLevel);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Ketter', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Health Status Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_moon_outlined, color: statusColor, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Your Status: $statusText',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF003738),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You are doing well. We are monitoring your vitals closely.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF4A6363),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Vitals Stream Graph
            Text('Heart Rate Trends', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 60,
                  maxY: 90,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _hrSpots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Quick Check-in Button
            ElevatedButton.icon(
              onPressed: () {
                _showCheckInModal(context);
              },
              icon: const Icon(Icons.favorite_border, size: 28),
              label: const Text('Start Daily Check-in'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            // Other Vitals List
            Text('Latest Vitals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _VitalCard(label: 'Temperature', value: '$temperature °C', icon: Icons.thermostat),
            _VitalCard(label: 'Oxygen (SpO2)', value: '$spo2 %', icon: Icons.air),
            _VitalCard(label: 'Blood Pressure', value: '$systolicBP/80', icon: Icons.speed),
          ],
        ),
      ),
    );
  }

  void _showCheckInModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How are you feeling?', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _EmojiButton(emoji: '😊', label: 'Good'),
                  _EmojiButton(emoji: '😐', label: 'Okay'),
                  _EmojiButton(emoji: '😔', label: 'Tired'),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Submit Check-in'),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String level) {
    switch (level) {
      case 'Low': return const Color(0xFF4CAF50); // Accessible Green
      case 'Medium': return const Color(0xFFFFA000); // Warm Orange
      case 'High': return const Color(0xFFD32F2F); // Noticeable but not clinical red
      default: return Colors.grey;
    }
  }

  String _getStatusText(String level) {
    switch (level) {
      case 'Low': return 'Stable';
      case 'Medium': return 'Monitoring';
      case 'High': return 'Care Team Notified';
      default: return 'Unknown';
    }
  }
}

class _VitalCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _VitalCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(label, style: const TextStyle(fontSize: 18)),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}

class _EmojiButton extends StatelessWidget {
  final String emoji;
  final String label;

  const _EmojiButton({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
