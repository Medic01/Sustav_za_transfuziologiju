import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
//U admin welcome page se koristi
  Stream<QuerySnapshot> getAccepted() {
    return _db.collection('accepted').snapshots();
  }

  Stream<QuerySnapshot> getRejected() {
    return _db.collection('rejected').snapshots();
  }

//u registraciji se koristi
  Future<bool> doesUserExist(String email) {
    return _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty);
  }

// u gogle_oauth se koristi
  Future<QuerySnapshot> getUserById(String id) {
    return _db.collection('users').where('userId', isEqualTo: id).get();
  }

// u google_oauth se koristi
  Future<void> saveUserToFirestore(GoogleSignInAccount user) {
    return _db.collection('users').doc(user.id).set({
      'displayName': user.displayName,
      'email': user.email,
      'userId': user.id,
    });
  }
}
