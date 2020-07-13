import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authantication {
final FirebaseAuth _firebase;
final GoogleSignIn _googleSignIn;




Authantication({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebase = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),_firestore=Firestore.instance;

final Firestore _firestore;
SharedPreferences prefs;

FirebaseUser adminUser;

//SIgn in with Google
Future<FirebaseUser> signInGoogle() async{

await _googleSignIn.signOut();

final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
 AuthResult authResult = await _firebase.signInWithCredential(credential);
  prefs = await SharedPreferences.getInstance();
 FirebaseUser aadmin = authResult.user;
 if(aadmin != null){
       final QuerySnapshot result =
          await Firestore.instance.collection('users').where('uid', isEqualTo: aadmin.uid).getDocuments();
           final List<DocumentSnapshot> documents = result.documents;
           if(documents.length == 0){
              updateUser(authResult.user);
           }
           else{
             await prefs.setString('uid', documents[0]['uid']);
        await prefs.setString('displayName', documents[0]['displayName']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('email', documents[0]['email']);


           }


 }
 else{

 }
 
return _firebase.currentUser();
}

// Check current user
 Future<bool> isSignedIn()async{
    prefs = await SharedPreferences.getInstance();
   final currentUser = await _firebase.currentUser();
   return currentUser!= null;
 }

 Future<FirebaseUser> getUser() async{
    prefs = await SharedPreferences.getInstance();
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
     prefs = await SharedPreferences.getInstance();
   DocumentReference ref = _firestore.collection('users').document(user.uid);
   ref.setData({'uid':user.uid, 'email': user.email, 'displayName': user.displayName, 'photoUrl': user.photoUrl,'lastSeen': DateTime.now()});
    
    
     adminUser = user;
  //   print(adminUser.email);
        await prefs.setString('uid', adminUser.uid);
        await prefs.setString('displayName', adminUser.displayName);
        await prefs.setString('photoUrl', adminUser.photoUrl);
        await prefs.setString('email', adminUser.email);

       
  }

}

