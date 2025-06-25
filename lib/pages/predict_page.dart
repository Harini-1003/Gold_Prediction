import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/nav_bar.dart';

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  DateTime? selectedDate;
  Map<String, dynamic>? prediction;
  bool isLoading = false;
  String? error;

  // Color palette matching the screenshot
  static const Color primaryOrange = Color(0xFFFF8C42);
  static const Color secondaryOrange = Color(0xFFFF7A2B);
  static const Color darkNavy = Color(0xFF2C3E50);
  static const Color lightNavy = Color(0xFF34495E);
  static const Color creamBackground = Color(0xFFF5F3E8);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color cardWhite = Color(0xFFFFFFF8);

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryOrange,
              onPrimary: Colors.white,
              surface: cardWhite,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        isLoading = true;
        prediction = null;
        error = null;
      });

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      print("📤 Sending future_date = $formattedDate");

      try {
        final result = await ApiService.predictPrice(formattedDate);
        print("✅ Prediction from API: $result");

        setState(() {
          prediction = result;
          isLoading = false;
        });
      } catch (e) {
        print("❌ Error: $e");
        setState(() {
          isLoading = false;
          error = "Prediction failed: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBackground,
      bottomNavigationBar: NavBar(currentIndex: 1),
      body: Column(
        children: [
          // Header with gradient matching the screenshot
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryOrange, secondaryOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gold Predictor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'AI-Powered Price Analysis',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'INR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  // Prediction Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Future Price Prediction',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        SizedBox(height: 24),

                        Text(
                          'Select Prediction Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Date Picker Button
                        GestureDetector(
                          onTap: pickDate,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                              color: creamBackground.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: textLight,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  selectedDate != null
                                      ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                                      : 'Pick a date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedDate != null
                                        ? textDark
                                        : textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Predict Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryOrange, secondaryOrange],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryOrange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: selectedDate != null && !isLoading ? pickDate : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              'Predict Price',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Results Card
                  if (error != null)
                    Container(
                      decoration: BoxDecoration(
                        color: cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              error!,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (prediction != null)
                    Container(
                      decoration: BoxDecoration(
                        color: cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryOrange.withOpacity(0.2), secondaryOrange.withOpacity(0.1)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.trending_up,
                                  color: primaryOrange,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Prediction Result',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          Text(
                            'Date: ${prediction!['future_date']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: textLight,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            '₹${prediction!['predicted_price']}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: successGreen,
                            ),
                          ),

                          SizedBox(height: 12),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [darkNavy.withOpacity(0.1), lightNavy.withOpacity(0.05)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Category: ${prediction!['predicted_category']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: darkNavy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}