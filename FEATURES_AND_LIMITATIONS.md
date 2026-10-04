# HUMSAFR — feature scope

The project has been expanded to mirror the provided HUMSAFR design board:
- green/black H icon branding
- customer splash/login/home
- pickup/destination flow
- vehicle/fare selection
- driver-found screen
- live tracking screen
- ride completion/rating
- wallet/payments area
- trip sharing
- ride scheduling
- SOS/support/local-places/rewards/referrals/multi-language feature center
- driver login/dashboard/request/navigation/earnings foundation
- admin dashboard foundation

IMPORTANT:
A UI that looks like Uber/Ola is not, by itself, a production ride-hailing service. The following require real external configuration/backend work:
1. Google Maps API + Directions/Routes and map rendering
2. Firebase project + Phone Auth + Firestore
3. server-side geospatial driver matching
4. background driver GPS + foreground service
5. FCM push notifications
6. real-time ride state synchronization
7. payment gateway credentials and server-side verification
8. KYC/document storage and driver approval
9. SOS/contacts/call integration
10. admin authentication and role-based access
11. cancellation, waiting, surge and fare rules
12. monitoring, rate limits, fraud prevention and backups

The included code is intentionally a safe, configurable foundation. It does not pretend to have live payment/dispatch credentials.
