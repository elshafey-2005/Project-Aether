import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:projectaether/features/raid/data/raid_service.dart'; 

void main() {
  group('Aether Raid Concurrency Integrity', () {
    late FakeFirebaseFirestore fakeFirestore;
    late RaidService raidService;

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      
      // Injecting the fake firestore into the service
      raidService = RaidService(firestore: fakeFirestore);
      
      await fakeFirestore.collection('events').doc('dragon_raid').set(<String, dynamic>{
        'slots_filled': 0,
        'max_slots': 15,
      });
    });

    test('Thundering Herd: 50 simultaneous join requests must strictly cap at 15', () async {
      final List<Future<bool>> joinRequests = <Future<bool>>[];
      
      for (int i = 0; i < 50; i++) {
        joinRequests.add(raidService.joinRaid(userId: 'user_$i'));
      }

      final List<bool> results = await Future.wait(joinRequests);
      final int successfulJoins = results.where((bool result) => result == true).length;
      
      final snapshot = await fakeFirestore.collection('events').doc('dragon_raid').get();
      final int slotsFilled = (snapshot.data()?['slots_filled'] as int?) ?? 0;

      expect(successfulJoins, 15, reason: 'Exactly 15 requests should report success. Check transaction logic.');
      expect(slotsFilled, 15, reason: 'The database must record exactly 15 filled slots to prevent overbooking.');
    });
  });
}
