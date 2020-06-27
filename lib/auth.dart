import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Authantication {
final FirebaseAuth _firebase;
final GoogleSignIn _googleSignIn;

Authantication({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebase = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),_firestore=Firestore.instance;

final Firestore _firestore;

//SIgn in with Google
Future<FirebaseUser> signInGoogle() async{

await _googleSignIn.signOut();

final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
 AuthResult authResult =await _firebase.signInWithCredential(credential);
 updateUser(authResult.user);
return _firebase.currentUser();
}

// Check current user
 Future<bool> isSignedIn()async{
   final currentUser = await _firebase.currentUser();
   return currentUser!= null;
 }

 Future<FirebaseUser> getUser() async{
   return await _firebase.currentUser();
 }

Future<void> signOut()async{
  return Future.wait([
    _firebase.signOut(),
    _googleSignIn.signOut()
  ]);

}

// Update user data on Database when user is logged in
  updateUser(FirebaseUser user)async{
   DocumentReference ref = _firestore.collection('users').document(user.uid);
   ref.setData({'uid':user.uid, 'email': user.email, 'displayName': user.displayName, 'photoUrl': user.photoUrl,'lastSeen': DateTime.now()});
  }

}

