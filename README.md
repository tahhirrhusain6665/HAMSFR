# Humsafar

Flutter Android ride-booking project: rider flow + driver flow + Firebase OTP + Firestore ride lifecycle + Google Maps/location foundation.

## Important
This repository is a complete **development foundation**, not a claim of a production Uber/Ola-scale backend. Real production dispatch, background driver location, push notifications, payments, KYC/admin, fraud controls and scaling need backend configuration and testing.

## Setup

1. Install Flutter and Android SDK.
2. From the project root run:
   `flutter pub get`
3. Configure Firebase:
   `flutterfire configure`
4. Enable Phone Authentication and Firestore in Firebase.
5. Add a Google Maps Android API key in `android/app/src/main/AndroidManifest.xml`.
6. Add location permissions in the Android manifest if your generated project does not already contain them.
7. Apply `firestore.rules`.
8. Run:
   `flutter run`

## Project structure

- `lib/screens/` rider and driver UI
- `lib/services/` Firebase/auth/ride/driver/location logic
- `lib/utils/` theme
- `firestore.rules` initial security rules

## Next production modules
- Real driver dispatch/geospatial matching
- Background driver location
- FCM ride notifications
- Fare calculation from route distance/time
- Razorpay payment flow
- Driver KYC/document verification
- Admin dashboard
- Cancellation/waiting/surge rules
- Crash reporting, analytics and automated tests


## Design reference
`design_reference.png` is the supplied HUMSAFR design board used as the visual reference.

See `FEATURES_AND_LIMITATIONS.md` for the full feature scope and which production integrations still require real credentials/backend setup.


## Real integration setup
See `docs/REAL_SETUP.md` and `docs/FEATURE_MATRIX.md`. No real secrets are embedded.
