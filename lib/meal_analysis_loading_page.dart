import 'dart:io';
import 'package:flutter/material.dart';
import 'meal_analysis_result_page.dart';
import 'ai_service.dart';
import 'app_colors.dart';

class MealAnalysisLoadingPage extends StatefulWidget {
  final File imageFile;

  const MealAnalysisLoadingPage({
    super.key,
    required this.imageFile,
  });

  @override
  State<MealAnalysisLoadingPage> createState() =>
      _MealAnalysisLoadingPageState();
}

class _MealAnalysisLoadingPageState extends State<MealAnalysisLoadingPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  double _progress = 0.0;

  final List<AnalysisStep> _steps = [
    AnalysisStep(
      title: 'Detecting ingredients',
      icon: Icons.search,
      color: AppColors.primaryTeal,
    ),
    AnalysisStep(
      title: 'Verifying items',
      icon: Icons.fact_check,
      color: AppColors.accentGreen,
    ),
    AnalysisStep(
      title: 'Checking freshness',
      icon: Icons.spa,
      color: AppColors.trustBlue,
    ),
    AnalysisStep(
      title: 'Generating meal plans',
      icon: Icons.restaurant_menu,
      color: AppColors.energyOrange,
    ),
  ];

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _startAnalysis();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    for (int i = 0; i < _steps.length; i++) {
      if (mounted) {
        setState(() {
          _currentStep = i;
          _progress = (i + 1) / _steps.length;
        });
      }
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    if (mounted) {
      // Call AI service (currently mock)
      final result = await AiService.analyzeMealImage(widget.imageFile);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MealAnalysisResultPage(
            imageFile: widget.imageFile,
            analysisResult: result,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/lifestyle_twin_logo.png',
                height: 28,
                width: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Analyzing...',
              style: TextStyle(
                color: AppColors.trustBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated AI Icon
              RotationTransition(
                turns: _rotationAnimation,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryTeal,
                        AppColors.trustBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryTeal.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Progress Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'AI is analyzing your meal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.trustBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This usually takes 5-10 seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 12,
                        backgroundColor: AppColors.softGray,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _steps[_currentStep].color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${(_progress * 100).toInt()}% Complete',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.trustBlue,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Steps List
                    ...List.generate(
                      _steps.length,
                      (index) => _buildStepTile(index),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fun Fact Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryTeal.withOpacity(0.1),
                      AppColors.trustBlue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryTeal.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.primaryTeal,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Did you know? Our AI can identify over 10,000 food items and track 40+ nutrients!',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGray,
                          height: 1.4,
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
    );
  }

  Widget _buildStepTile(int index) {
    final step = _steps[index];
    final isDone = index < _currentStep;
    final isActive = index == _currentStep;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.lightMint.withOpacity(0.3)
            : isActive
                ? step.color.withOpacity(0.1)
                : AppColors.softGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone
              ? AppColors.accentGreen
              : isActive
                  ? step.color.withOpacity(0.5)
                  : Colors.transparent,
          width: isDone ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.accentGreen
                  : isActive
                      ? step.color
                      : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone
                  ? Icons.check
                  : isActive
                      ? step.icon
                      : Icons.schedule,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                        isDone || isActive ? AppColors.trustBlue : Colors.grey,
                  ),
                ),
                Text(
                  isDone
                      ? 'Completed'
                      : isActive
                          ? 'In Progress...'
                          : 'Queued',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isDone || isActive ? Colors.grey : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(step.color),
              ),
            ),
        ],
      ),
    );
  }
}

class AnalysisStep {
  final String title;
  final IconData icon;
  final Color color;

  AnalysisStep({
    required this.title,
    required this.icon,
    required this.color,
  });
}
