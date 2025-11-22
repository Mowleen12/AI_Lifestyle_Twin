import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// OpenRouter AI Service for meal analysis and workout planning
class OpenRouterService {
  // TODO: Replace with your actual API key
  static const String _apiKey =
      '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';
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  static const String _model = 'x-ai/grok-4.1-fast:free';

  /// Send a chat completion request to OpenRouter
  static Future<OpenRouterResponse> sendChatCompletion({
    required List<Map<String, dynamic>> messages,
    double temperature = 0.7,
    int maxTokens = 2000,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://lifestyle-twin.app',
          'X-Title': 'Lifestyle Twin AI Coach',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': temperature,
          'max_tokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OpenRouterResponse(
          success: true,
          content: data['choices'][0]['message']['content'],
          usage: data['usage'],
        );
      } else {
        return OpenRouterResponse(
          success: false,
          error: 'API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      return OpenRouterResponse(
        success: false,
        error: 'Network Error: $e',
      );
    }
  }

  /// Analyze meal image and extract ingredients
  static Future<OpenRouterResponse> analyzeMealImage(File imageFile) async {
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Determine image type
      final extension = imageFile.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final messages = [
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  '''Analyze this meal/food image and provide a detailed response in JSON format.

Your response MUST be valid JSON with this exact structure:
{
  "ingredients": [
    {
      "name": "ingredient name",
      "quantity": "estimated quantity",
      "category": "protein|carbs|vegetables|fruit|dairy|fats|other"
    }
  ],
  "freshness_checks": [
    {
      "item": "food item name",
      "status": "fresh|warning|expired",
      "message": "brief assessment"
    }
  ],
  "meal_plans": [
    {
      "name": "meal plan name",
      "description": "brief description",
      "calories": 450,
      "protein": 35,
      "carbs": 40,
      "fats": 15,
      "category": "breakfast|lunch|dinner|snack"
    }
  ]
}

Guidelines:
- Identify ALL visible food items in the image
- Provide realistic portion estimates (e.g., "200g", "1 cup", "2 pieces")
- Assess freshness based on visual appearance
- Generate 2-3 meal plan suggestions using detected ingredients
- Ensure all numeric values are integers
- Keep descriptions concise (under 100 characters)

Return ONLY the JSON object, no markdown formatting or additional text.'''
            },
            {
              'type': 'image_url',
              'image_url': {'url': 'data:$mimeType;base64,$base64Image'}
            }
          ]
        }
      ];

      return await sendChatCompletion(
        messages: messages,
        temperature: 0.5,
        maxTokens: 2000,
      );
    } catch (e) {
      return OpenRouterResponse(
        success: false,
        error: 'Image processing error: $e',
      );
    }
  }

  /// Generate workout plan through conversation
  static Future<OpenRouterResponse> generateWorkoutPlanResponse({
    required String userMessage,
    required List<Map<String, dynamic>> conversationHistory,
  }) async {
    // Build full conversation context
    final messages = [
      {
        'role': 'system',
        'content':
            '''You are an expert AI fitness coach helping users create personalized workout plans. 

Your goal is to gather information through natural conversation and eventually generate a complete workout plan.

Information to collect:
1. Fitness goals (muscle building, weight loss, endurance, general fitness)
2. Current fitness level (beginner, intermediate, advanced)
3. Any injuries or physical limitations
4. Available equipment (full gym, home gym, bodyweight only)
5. Weekly schedule (how many days per week)
6. Preferred workout duration (30, 45, 60, or 90+ minutes)

CONVERSATION PHASE:
- Ask ONE question at a time
- Be friendly and encouraging
- Acknowledge user responses positively
- After each response, assess if you have enough information
- If you need more information, ask the next relevant question

PLAN GENERATION PHASE:
When you have collected enough information (after 4-6 exchanges), generate a complete workout plan in this EXACT JSON format:

{
  "plan_complete": true,
  "plan": {
    "name": "Custom Workout Plan Name",
    "description": "Brief overview of the plan",
    "duration_weeks": 8,
    "days_per_week": 4,
    "sessions": [
      {
        "day": "Monday",
        "name": "Upper Body Strength",
        "duration": 45,
        "exercises": [
          {
            "name": "Push-ups",
            "sets": 4,
            "reps": "10-12",
            "rest": 60,
            "notes": "Form tip or modification"
          }
        ]
      }
    ]
  },
  "summary": "Congratulatory message explaining the plan"
}

IMPORTANT:
- During conversation, respond with natural text only (no JSON)
- Include "plan_complete": false in your response metadata if still gathering info
- Only output the complete JSON structure when ready to generate the final plan
- Ensure all exercise details are specific and actionable
- Include 3-4 workout sessions minimum in the final plan
- Each session should have 4-6 exercises'''
      },
      ...conversationHistory,
      {
        'role': 'user',
        'content': userMessage,
      }
    ];

    return await sendChatCompletion(
      messages: messages,
      temperature: 0.7,
      maxTokens: 2500,
    );
  }

  /// Test API connection
  static Future<bool> testConnection() async {
    try {
      final response = await sendChatCompletion(
        messages: [
          {
            'role': 'user',
            'content': 'Hello! Please respond with "OK" if you can hear me.'
          }
        ],
        maxTokens: 50,
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}

/// Response wrapper for OpenRouter API calls
class OpenRouterResponse {
  final bool success;
  final String? content;
  final String? error;
  final Map<String, dynamic>? usage;

  OpenRouterResponse({
    required this.success,
    this.content,
    this.error,
    this.usage,
  });

  /// Parse JSON response safely
  Map<String, dynamic>? parseJson() {
    if (content == null) return null;

    try {
      // Remove markdown code blocks if present
      String cleaned = content!.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7);
      }
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }
      cleaned = cleaned.trim();

      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      print('JSON Parse Error: $e');
      print('Content: $content');
      return null;
    }
  }

  /// Extract text content from response
  String getText() {
    return content?.trim() ?? '';
  }
}
