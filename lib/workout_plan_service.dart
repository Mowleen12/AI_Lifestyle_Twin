import 'smart_plan_chat_page.dart';
import 'openrouter_service.dart';
import 'dart:convert';

/// Service for AI-powered workout plan generation using OpenRouter
class WorkoutPlanService {
  /// Get AI response based on user message and conversation history
  static Future<AIResponse> getAIResponse({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
  }) async {
    try {
      // Convert chat history to API format
      final apiMessages = conversationHistory.map((msg) {
        return {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        };
      }).toList();

      // Call OpenRouter API
      final response = await OpenRouterService.generateWorkoutPlanResponse(
        userMessage: userMessage,
        conversationHistory: apiMessages,
      );

      if (!response.success) {
        return AIResponse(
          message: 'Sorry, I encountered an error: ${response.error}\n\n'
              'Please try again or rephrase your message.',
          isPlanComplete: false,
        );
      }

      final content = response.getText();

      // Try to parse as JSON (for complete plan)
      final jsonData = response.parseJson();

      if (jsonData != null && jsonData['plan_complete'] == true) {
        // Plan is complete, parse it
        final planData = jsonData['plan'];
        final workoutPlan = WorkoutPlan.fromJson(planData);

        return AIResponse(
          message: jsonData['summary'] ??
              'Great! Your personalized workout plan is ready!',
          isPlanComplete: true,
          generatedPlan: workoutPlan,
          planData: {
            'title': '✨ Your Plan is Ready!',
            'details': '${workoutPlan.daysPerWeek}-day custom plan',
          },
        );
      } else {
        // Still in conversation phase
        return AIResponse(
          message: content,
          isPlanComplete: false,
          planData: _extractPlanData(content),
        );
      }
    } catch (e) {
      print('Error getting AI response: $e');
      return AIResponse(
        message: 'I\'m having trouble processing that. Could you rephrase?',
        isPlanComplete: false,
      );
    }
  }

  /// Extract any plan-related data from conversational response
  static Map<String, dynamic>? _extractPlanData(String content) {
    final lowerContent = content.toLowerCase();

    // Look for mentions of workout days, exercises, etc.
    if (lowerContent.contains('workout') ||
        lowerContent.contains('exercise') ||
        lowerContent.contains('training')) {
      return {
        'title': 'Planning in Progress',
        'details': 'Building your custom routine...',
      };
    }

    return null;
  }

  /// Reset conversation state
  static void resetConversation() {
    // No state to reset with API-based approach
  }
}

/// AI response with optional plan data
class AIResponse {
  final String message;
  final bool isPlanComplete;
  final WorkoutPlan? generatedPlan;
  final Map<String, dynamic>? planData;

  AIResponse({
    required this.message,
    required this.isPlanComplete,
    this.generatedPlan,
    this.planData,
  });
}

/// Complete workout plan structure
class WorkoutPlan {
  final String name;
  final String description;
  final int durationWeeks;
  final int daysPerWeek;
  final List<WorkoutSession> sessions;

  WorkoutPlan({
    required this.name,
    required this.description,
    required this.durationWeeks,
    required this.daysPerWeek,
    required this.sessions,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      name: json['name'] ?? 'Custom Workout Plan',
      description: json['description'] ?? 'Your personalized fitness plan',
      durationWeeks: json['duration_weeks'] ?? 8,
      daysPerWeek: json['days_per_week'] ?? 4,
      sessions: (json['sessions'] as List?)
              ?.map((s) => WorkoutSession.fromJson(s))
              .toList() ??
          [],
    );
  }
}

/// Individual workout session
class WorkoutSession {
  final String day;
  final String name;
  final int duration; // minutes
  final List<Exercise> exercises;

  WorkoutSession({
    required this.day,
    required this.name,
    required this.duration,
    required this.exercises,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      day: json['day'] ?? 'Monday',
      name: json['name'] ?? 'Workout',
      duration: json['duration'] ?? 45,
      exercises: (json['exercises'] as List?)
              ?.map((e) => Exercise.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// Individual exercise
class Exercise {
  final String name;
  final int sets;
  final String reps;
  final int rest; // seconds
  final String notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.notes,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? 'Exercise',
      sets: json['sets'] ?? 3,
      reps: json['reps']?.toString() ?? '10-12',
      rest: json['rest'] ?? 60,
      notes: json['notes'] ?? '',
    );
  }
}
