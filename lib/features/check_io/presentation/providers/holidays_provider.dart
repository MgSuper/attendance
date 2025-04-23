import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uHolidayDatesProvider = FutureProvider<Map<String, String>>((ref) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('holidays').get();

  return {
    for (var doc in snapshot.docs)
      doc.id: (doc.data()['name'] ?? 'Public Holiday') as String,
  };
});
