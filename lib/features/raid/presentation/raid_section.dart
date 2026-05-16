import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'raid_provider.dart';
import '../../../core/theme/app_theme.dart';

class RaidSection extends ConsumerWidget {
  const RaidSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(raidProvider);
    final playerCountAsync = ref.watch(raidCountProvider);

    // Get current players from the stream, default to the local state if loading/error
    final int currentPlayers = playerCountAsync.maybeWhen(
      data: (count) => count,
      orElse: () => status.currentPlayers,
    );
    final int maxPlayers = status.maxPlayers;
    final bool isFull = currentPlayers >= maxPlayers;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.purpleNeon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.groups_rounded, color: AppTheme.purpleNeon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RAID SQUAD [ALPHA]',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  isFull
                      ? 'DEPLOYMENT FULL'
                      : '$currentPlayers / $maxPlayers SLOTS OCCUPIED',
                  style: TextStyle(
                    color: isFull
                        ? AppTheme.pinkNeon
                        : AppTheme.purpleNeon.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                if (status.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(status.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 10)),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (status.isLoading || status.isJoined || isFull) 
                ? null 
                : () => ref.read(raidProvider.notifier).joinRaid(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: (status.isJoined || isFull)
                    ? null
                    : const LinearGradient(colors: [AppTheme.purpleNeon, Color(0xFF7000FF)]),
                color: (status.isJoined || isFull)
                    ? Colors.white.withOpacity(0.05)
                    : null,
                borderRadius: BorderRadius.circular(8),
                boxShadow: (status.isJoined || isFull)
                    ? []
                    : [
                        BoxShadow(
                            color: AppTheme.purpleNeon.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
              ),
              child: status.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(
                      status.isJoined
                          ? 'READY'
                          : (isFull ? 'LOCKED' : 'JOIN'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: status.isJoined
                            ? Colors.greenAccent
                            : (isFull
                                ? Colors.white24
                                : Colors.white),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
