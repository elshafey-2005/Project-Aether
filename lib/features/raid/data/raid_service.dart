import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synchronized/synchronized.dart';

/// Service responsible for managing Raid state using Firestore Transactions.
/// Implements Mutex locking to handle high-concurrency bursts safely.
class RaidService {
  final FirebaseFirestore _firestore;
  final Lock _lock = Lock();

  RaidService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Returns a stream of the current player count for the raid.
  Stream<int> get playersCountStream => _firestore
      .collection('events')
      .doc('dragon_raid')
      .snapshots()
      .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        final Map<String, dynamic>? data = snapshot.data();
        return (data?['slots_filled'] as int?) ?? 0;
      });

  /// Joins a raid using a Firestore Transaction protected by a local Mutex.
  /// 
  /// This ensures that exactly 15 successful joins occur even under
  /// extreme concurrency (e.g., 50+ simultaneous requests).
  Future<bool> joinRaid({required String userId}) async {
    final DocumentReference raidRef = _firestore.collection('events').doc('dragon_raid');

    // Use a lock to serialize requests locally.
    // This prevents multiple transactions from reading the same stale state
    // during a thundering herd event, ensuring strict adherence to the player cap.
    return await _lock.synchronized(() async {
      try {
        final dynamic result = await _firestore.runTransaction((Transaction transaction) async {
          final DocumentSnapshot raidDoc = await transaction.get(raidRef);

          if (!raidDoc.exists) {
            throw Exception("Raid event not found");
          }

          final Map<String, dynamic> data = raidDoc.data() as Map<String, dynamic>;
          final int currentPlayers = (data['slots_filled'] as int?) ?? 0;
          final int maxPlayers = (data['max_slots'] as int?) ?? 15;

          if (currentPlayers < maxPlayers) {
            transaction.update(raidRef, <String, dynamic>{
              'slots_filled': currentPlayers + 1,
              'last_player_joined': userId,
              'updated_at': FieldValue.serverTimestamp(),
            });
            return true;
          }

          return false; // Raid is full
        });

        return result == true;
      } catch (e) {
        // Log error and fail gracefully
        return false;
      }
    });
  }
}
