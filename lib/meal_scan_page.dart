import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'meal_analysis_loading_page.dart';
import 'app_colors.dart';

class MealScanPage extends StatefulWidget {
  const MealScanPage({super.key});

  @override
  State<MealScanPage> createState() => _MealScanPageState();
}

class _MealScanPageState extends State<MealScanPage>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _analyzeIngredients() {
    if (_selectedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealAnalysisLoadingPage(
            imageFile: _selectedImage!,
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
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.trustBlue),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
              'Snap My Meal',
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Info Card
              _buildCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryTeal.withOpacity(0.2),
                            AppColors.primaryTeal.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.info_outline,
                          color: AppColors.primaryTeal, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Take a photo of your meal or fridge contents for instant AI analysis',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGray,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Image Preview Area
              _buildCard(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 320,
                      decoration: BoxDecoration(
                        gradient: _selectedImage == null
                            ? LinearGradient(
                                colors: [
                                  AppColors.primaryTeal.withOpacity(0.1),
                                  AppColors.trustBlue.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedImage == null
                              ? AppColors.primaryTeal.withOpacity(0.3)
                              : Colors.transparent,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryTeal.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 48,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No image selected',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.trustBlue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Take a photo or upload from gallery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        icon: const Icon(Icons.close,
                            color: AppColors.energyOrange, size: 18),
                        label: const Text(
                          'Clear Image',
                          style: TextStyle(
                            color: AppColors.energyOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Take Photo',
                      icon: Icons.camera_alt,
                      color: AppColors.primaryTeal,
                      onTap: _takePhoto,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Upload Image',
                      icon: Icons.photo_library,
                      color: AppColors.trustBlue,
                      onTap: _uploadImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Analyze Button
              Container(
                decoration: BoxDecoration(
                  gradient: _selectedImage != null
                      ? LinearGradient(
                          colors: [
                            AppColors.accentGreen,
                            AppColors.primaryTeal
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: _selectedImage == null ? Colors.grey.shade300 : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _selectedImage != null
                      ? [
                          BoxShadow(
                            color: AppColors.accentGreen.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton.icon(
                  onPressed:
                      _selectedImage != null ? _analyzeIngredients : null,
                  icon: Icon(
                    Icons.psychology,
                    color: _selectedImage != null ? Colors.white : Colors.grey,
                  ),
                  label: Text(
                    'Analyze Ingredients',
                    style: TextStyle(
                      color:
                          _selectedImage != null ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // AI Integration Note
              _buildCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: AppColors.accentGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'AI Vision will detect ingredients, check freshness, and suggest personalized meal plans',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.3,
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(0, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
