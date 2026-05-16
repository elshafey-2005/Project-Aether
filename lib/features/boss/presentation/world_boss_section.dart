import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class WorldBossSection extends StatefulWidget {
  const WorldBossSection({super.key});

  @override
  State<WorldBossSection> createState() => _WorldBossSectionState();
}

class _WorldBossSectionState extends State<WorldBossSection> with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 0, minutes: 14, seconds: 59, milliseconds: 900);
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    
    // High-performance countdown timer (100ms interval)
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft.inMilliseconds > 0) {
            _timeLeft = Duration(milliseconds: _timeLeft.inMilliseconds - 100);
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _glowController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    String ms = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return "$hours:$minutes:$seconds.$ms";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.cyanNeon.withOpacity(0.2 + (_glowController.value * 0.2)),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cyanNeon.withOpacity(0.1 * _glowController.value),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 4, height: 30, color: AppTheme.pinkNeon),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ACTIVE ANOMALY', style: TextStyle(color: AppTheme.pinkNeon, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    Text('LEVIATHAN PRIME', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
              const Icon(Icons.radar, color: AppTheme.cyanNeon, size: 24),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            _formatDuration(_timeLeft),
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w200,
              fontFamily: 'monospace',
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text('TIME UNTIL REALITY COLLAPSE', style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _timeLeft.inMilliseconds / (15 * 60 * 1000),
              backgroundColor: Colors.white.withOpacity(0.05),
              color: AppTheme.cyanNeon,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
