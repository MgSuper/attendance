import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final holidayDatesProvider = FutureProvider<Set<String>>((ref) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('holidays').get();
  return snapshot.docs.map((doc) => doc.id).toSet(); // 'yyyy-MM-dd'
});
