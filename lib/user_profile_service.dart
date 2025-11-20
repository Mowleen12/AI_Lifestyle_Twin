import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String workoutIntensity;
  String dietPreference;
  String coachGoal;

  UserProfile({
    this.name = 'Alex Rivera',
    this.workoutIntensity = 'Balanced',
    this.dietPreference = 'High-protein',
    this.coachGoal = 'Lean muscle',
  });
}

class UserProfileService extends ChangeNotifier {
  UserProfile _userProfile = UserProfile();

  UserProfile get userProfile => _userProfile;

  void updateProfile({
    String? name,
    String? workoutIntensity,
    String? dietPreference,
    String? coachGoal,
  }) {
    _userProfile.name = name ?? _userProfile.name;
    _userProfile.workoutIntensity = workoutIntensity ?? _userProfile.workoutIntensity;
    _userProfile.dietPreference = dietPreference ?? _userProfile.dietPreference;
    _userProfile.coachGoal = coachGoal ?? _userProfile.coachGoal;
    notifyListeners();
  }
}
