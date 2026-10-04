/*
 Firebase Auth ID tokens are JWTs. The mobile app should normally obtain its
 token from Firebase Auth and send it to your trusted backend. The backend
 verifies it with Firebase Admin SDK instead of implementing JWT verification
 from scratch.

If you later expose a separate HTTP API, use getAuth().verifyIdToken(token)
 there and authorize from decoded custom claims such as role.
*/
