import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/predict_page.dart';
import 'pages/trends_page.dart';
import 'pages/anomalies_page.dart';

void main() => runApp(GoldPredictorApp());

class GoldPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Predictor',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: DashboardPage(),
      routes: {
        '/dashboard': (_) => DashboardPage(),
        '/predict': (_) => PredictPage(),
        '/trends': (_) => TrendsPage(),
        '/anomalies': (_) => AnomaliesPage(),
      },
    );
  }
}
