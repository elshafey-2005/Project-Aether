import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/raid_service.dart';
import '../domain/raid_status.dart';

/// Provider for the RaidService instance.
final raidServiceProvider = Provider<RaidService>((ref) => RaidService());

/// StreamProvider to track live player count from Firestore.
final raidCountProvider = StreamProvider<int>((ref) {
  return ref.watch(raidServiceProvider).playersCountStream;
});

/// Provider for the Raid state notifier.
final raidProvider = StateNotifierProvider<RaidNotifier, RaidStatus>((ref) {
  final service = ref.watch(raidServiceProvider);
  return RaidNotifier(service);
});

/// Notifier to manage the Raid state with concurrency safety.
class RaidNotifier extends StateNotifier<RaidStatus> {
  final RaidService _service;

  RaidNotifier(this._service)
      : super(const RaidStatus(currentPlayers: 0, maxPlayers: 15));

  /// Attempts to join the raid using the atomic service method.
  Future<void> joinRaid() async {
    if (state.isJoined || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // In a real app, you'd get the actual user ID from an Auth provider.
      final String mockUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      
      final success = await _service.joinRaid(userId: mockUserId);
      
      if (success) {
        state = state.copyWith(
          isLoading: false,
          isJoined: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'The raid is full or event not found.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'System error: ${e.toString()}',
      );
    }
  }
}
