import 'dart:io';
import 'package:flutter/material.dart';
import 'app_colors.dart';

// lib/ai_service.dart

/// AI Service for meal image analysis
/// TODO: Replace mock implementation with real AI Vision API integration
class AiService {
  /// Analyze a meal image and return detected ingredients, freshness, and meal plans
  ///
  /// TODO: integrate AI Vision API here
  /// - Send image to vision model endpoint
  /// - Parse response for ingredients detection
  /// - Analyze freshness indicators
  /// - Generate personalized meal recommendations
  ///
  /// Current implementation returns mock data for UI testing
  static Future<MealAnalysisResult> analyzeMealImage(File imageFile) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // Example:
    // final response = await http.post(
    //   Uri.parse('https://api.example.com/analyze-meal'),
    //   headers: {'Authorization': 'Bearer YOUR_API_KEY'},
    //   body: {'image': base64Encode(imageFile.readAsBytesSync())},
    // );
    // return MealAnalysisResult.fromJson(jsonDecode(response.body));

    // Mock data for now
    return MealAnalysisResult(
      ingredients: [
        Ingredient(
          name: 'Chicken Breast',
          icon: Icons.set_meal,
          quantity: '200g',
        ),
        Ingredient(
          name: 'Brown Rice',
          icon: Icons.rice_bowl,
          quantity: '150g',
        ),
        Ingredient(
          name: 'Broccoli',
          icon: Icons.eco,
          quantity: '100g',
        ),
        Ingredient(
          name: 'Olive Oil',
          icon: Icons.water_drop,
          quantity: '1 tbsp',
        ),
        Ingredient(
          name: 'Bell Pepper',
          icon: Icons.local_florist,
          quantity: '80g',
        ),
        Ingredient(
          name: 'Garlic',
          icon: Icons.eco,
          quantity: '2 cloves',
        ),
      ],
      freshnessChecks: [
        FreshnessCheck(
          item: 'Chicken Breast',
          status: FreshnessStatus.fresh,
          message: 'Looks fresh and properly stored',
        ),
        FreshnessCheck(
          item: 'Vegetables',
          status: FreshnessStatus.fresh,
          message: 'Crisp and vibrant - excellent quality',
        ),
        FreshnessCheck(
          item: 'Rice',
          status: FreshnessStatus.warning,
          message: 'Use within 2 days for best quality',
        ),
      ],
      mealPlans: [
        MealPlan(
          name: 'High-Protein Power Bowl',
          description:
              'Grilled chicken with brown rice, steamed broccoli, and roasted bell peppers. Perfect for muscle recovery.',
          calories: 520,
          protein: 45,
          carbs: 52,
          fats: 12,
          icon: Icons.fitness_center,
          color: AppColors.accentGreen,
        ),
        MealPlan(
          name: 'Mediterranean Stir-Fry',
          description:
              'Pan-seared chicken with garlic, olive oil, and colorful vegetables over fluffy rice.',
          calories: 485,
          protein: 42,
          carbs: 48,
          fats: 15,
          icon: Icons.restaurant,
          color: AppColors.primaryTeal,
        ),
        MealPlan(
          name: 'Balanced Macro Meal',
          description:
              'Perfectly portioned chicken, rice, and veggies for sustained energy throughout the day.',
          calories: 495,
          protein: 43,
          carbs: 50,
          fats: 13,
          icon: Icons.balance,
          color: AppColors.trustBlue,
        ),
      ],
    );
  }
}

/// Result of meal image analysis
class MealAnalysisResult {
  final List<Ingredient> ingredients;
  final List<FreshnessCheck> freshnessChecks;
  final List<MealPlan> mealPlans;

  MealAnalysisResult({
    required this.ingredients,
    required this.freshnessChecks,
    required this.mealPlans,
  });

  // TODO: Add fromJson constructor when integrating real API
  // factory MealAnalysisResult.fromJson(Map<String, dynamic> json) {
  //   return MealAnalysisResult(
  //     ingredients: (json['ingredients'] as List)
  //         .map((i) => Ingredient.fromJson(i))
  //         .toList(),
  //     freshnessChecks: (json['freshness_checks'] as List)
  //         .map((f) => FreshnessCheck.fromJson(f))
  //         .toList(),
  //     mealPlans: (json['meal_plans'] as List)
  //         .map((m) => MealPlan.fromJson(m))
  //         .toList(),
  //   );
  // }
}

/// Detected ingredient from image
class Ingredient {
  final String name;
  final IconData icon;
  final String? quantity;

  Ingredient({
    required this.name,
    required this.icon,
    this.quantity,
  });

  // TODO: Add fromJson constructor
  // factory Ingredient.fromJson(Map<String, dynamic> json) {
  //   return Ingredient(
  //     name: json['name'],
  //     icon: _iconFromString(json['category']),
  //     quantity: json['quantity'],
  //   );
  // }
}

/// Freshness check result for an item
class FreshnessCheck {
  final String item;
  final FreshnessStatus status;
  final String message;

  FreshnessCheck({
    required this.item,
    required this.status,
    required this.message,
  });

  // TODO: Add fromJson constructor
  // factory FreshnessCheck.fromJson(Map<String, dynamic> json) {
  //   return FreshnessCheck(
  //     item: json['item'],
  //     status: FreshnessStatus.values.firstWhere(
  //       (s) => s.toString().split('.').last == json['status'],
  //     ),
  //     message: json['message'],
  //   );
  // }
}

enum FreshnessStatus {
  fresh,
  warning,
  expired,
}

/// Suggested meal plan based on detected ingredients
class MealPlan {
  final String name;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final IconData icon;
  final Color color;

  MealPlan({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.icon,
    required this.color,
  });

  // TODO: Add fromJson constructor
  // factory MealPlan.fromJson(Map<String, dynamic> json) {
  //   return MealPlan(
  //     name: json['name'],
  //     description: json['description'],
  //     calories: json['calories'],
  //     protein: json['protein'],
  //     carbs: json['carbs'],
  //     fats: json['fats'],
  //     icon: _iconFromString(json['icon']),
  //     color: _colorFromString(json['color']),
  //   );
  // }
}
