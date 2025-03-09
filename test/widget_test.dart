import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
//import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

void main() {
  test('Mock Firebase Test', () async {
    final auth = MockFirebaseAuth();
    final firestore = MockFirestoreInstance();

    final user = await auth.signInWithEmailAndPassword(
      email: 'test@test.com',
      password: 'password',
    );

    expect(user.user?.email, 'test@test.com');
  });
}

class MockFirestoreInstance {
}
