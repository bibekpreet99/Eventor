import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;

Future<FirebaseUser> signIn(String email, String password) async
{
  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
  if(user!=null)
  {
    return user.user;
  }
  else{
    return null;
  }
}

Future<FirebaseUser> registerUser(String email, String password) async {

  final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  if(user!=null)
  {
    _db.collection('users').add({
    'email': email,
    });
    return user.user;
  }
  else{
    return null;
  }
  
}

void signOut() async {
  _auth.signOut();
}

Future<FirebaseUser> loggedInUser() async
{
  final user = await _auth.currentUser();
  if(user!=null)
  {
    return user;
  }
  else{
    return null;
  }
}

Stream<FirebaseUser> get user{
  return _auth.onAuthStateChanged;
}