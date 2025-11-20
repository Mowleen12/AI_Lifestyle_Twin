import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'app_colors.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  /* ---------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    print('>>> MissionScreen: video init start');
    // use YOUR file
    _controller = VideoPlayerController.asset('assets/videos/workout_video.mp4')
      ..initialize().then((_) {
        print('>>> Video initialized ✅');
        if (mounted) setState(() => _isInitialized = true);
      }).catchError((e) {
        print('>>> Asset failed: $e → falling back to network');
        _controller = VideoPlayerController.network(
            'https://www.w3schools.com/html/mov_bbb.mp4')
          ..initialize().then((_) {
            print('>>> Network fallback initialized ✅');
            if (mounted) setState(() => _isInitialized = true);
          });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /* ---------------- Video Controls ---------------- */
  void _play() => _controller.play();
  void _pause() => _controller.pause();
  void _skip() => _controller.seekTo(_controller.value.duration);

  /* ---------------------------------------------------------- */
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
              'Strength Quest',
              style: TextStyle(
                color: AppColors.trustBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              '⭐ 45 XP',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /* ---------------- Video Card ---------------- */
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /* Video or Gradient Fallback */
                  _isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryTeal,
                                AppColors.trustBlue
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.sports_gymnastics,
                              size: 64, color: Colors.white),
                        ),

                  /* Play / Pause Overlay */
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 56,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /* ---------------- Title & Cue ---------------- */
            const Text(
              'Push-ups',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep your back straight. Elbows at ~45°. Core tight.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            /* ---------------- Progress Circle ---------------- */
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.trustBlue),
                      strokeWidth: 10,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('00:30',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      Text('Time • Round 1/3',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /* ---------------- Quest Progress ---------------- */
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quest Progress',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _progressStep('Warmup', true),
                      _progressStep('Set 1', false),
                      _progressStep('Set 2', false),
                      _progressStep('Cooldown', false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /* ---------------- AI Tip ---------------- */
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://placehold.co/100x100/A0FFD7/000000?text=AI'),
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '⚡ You got this! Last 5 seconds, push harder!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /* ---------------- Control Buttons ---------------- */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlButton(
                    label: 'Pause', icon: Icons.pause, onTap: _pause),
                _controlButton(
                    label: 'Skip', icon: Icons.skip_next, onTap: _skip),
                _controlButton(
                    label: 'End',
                    icon: Icons.power_settings_new,
                    onTap: () => Navigator.pop(context),
                    isDanger: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* ---------------- UI Helpers ---------------- */
  Widget _progressStep(String label, bool isCompleted) => Column(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? AppColors.trustBlue : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );

  Widget _controlButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDanger ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isDanger ? Colors.white : AppColors.trustBlue,
                  size: 24),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: isDanger ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
}
