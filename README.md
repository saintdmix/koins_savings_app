# Koins Savings – Flutter Technical Assessment

A simple digital-bank savings app built for the Koins MFB Flutter assessment.
Users can log in, browse savings products, view product details, create a savings plan and see a dashboard.

## Screens

| Screen | Highlights |
| --- | --- |
| Login | Email/password validation, mock auth, non-functional *Forgot Password* & *Register* |
| Dashboard | Greeting, total savings (₦850,000 base), quick actions, 3 recent plans, financial tips from a public API |
| Savings Products | Search, filter chips, pull-to-refresh, loading / empty / error states |
| Product Details | Plan name, interest, minimum deposit, duration, *Create Savings* |
| Create Savings | All-fields-required validation, success message, returns to Dashboard |
| Profile | Name, email, phone, biometric lock switch, logout |

**Mock credentials:** `test@bank.com` / `Password123`

## Setup

```bash
flutter --version          # note your version in the section below
flutter pub get
flutter run
flutter test               # unit + widget tests
flutter build apk --release   # APK -> build/app/outputs/flutter-apk/app-release.apk
```

**Flutter version used:** _fill in the output of `flutter --version` (Flutter x.y.z • Dart x.y.z)_

### Platform setup (one-time)

**Android**
1. `android/app/src/main/AndroidManifest.xml` – inside `<manifest>` add:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
   ```
   (`INTERNET` is only added automatically for debug builds, so the release APK needs it for the API call.)
2. `MainActivity.kt` must extend `FlutterFragmentActivity` (required by `local_auth`):
   ```kotlin
   import io.flutter.embedding.android.FlutterFragmentActivity
   class MainActivity : FlutterFragmentActivity()
   ```
3. If the build complains about `minSdk`, set `minSdk = 24` in `android/app/build.gradle(.kts)`.

**iOS** – add to `ios/Runner/Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>Use Face ID to unlock Koins Savings</string>
```

## Packages used

| Package | Why |
| --- | --- |
| `flutter_bloc` + `equatable` | Cubit state management, value equality for states |
| `go_router` | Declarative routing, auth redirects, bottom-nav shell |
| `dio` | HTTP client with timeouts and typed error mapping |
| `shared_preferences` | Persist logged-in user, created plans, biometric flag |
| `intl` | Naira currency and date formatting |
| `local_auth` | Biometric app lock (bonus) |
| `bloc_test`, `mocktail` | Testing |

## Architecture

```
lib/
├── core/          theme, router, constants, AppException, LoadStatus
├── models/        UserModel, SavingsProduct, SavingsPlan, TipModel
├── services/      StorageService, ApiService (Dio), AuthService (mock), BiometricService
├── repositories/  AuthRepository, SavingsRepository, TipsRepository
├── providers/     Cubits + states (auth, savings, products, tips)
├── screens/       One file per screen
├── widgets/       Reusable UI (text field, buttons, cards, state views, animations)
├── utils/         Validators, formatters, icon helper
└── main.dart      Dependency wiring + app root
```

Data flows one way: **Screen → Cubit → Repository → Service**. Widgets never talk to
storage or the network directly, which keeps UI thin and business logic testable.
(`providers/` holds the Cubits – the folder name follows the structure required by the brief.)

## State management: why Cubit?

- The app's logic is simple request → state transitions (login, load, create, filter). Cubit expresses
  that with plain methods and no event classes, so there is far less boilerplate than full Bloc.
- Immutable `Equatable` states make UI rebuilds predictable and let `BlocBuilder.buildWhen` skip
  unnecessary rebuilds.
- It's easy to unit test with `bloc_test` and to mock repositories with `mocktail`.
- Compared with Provider/GetX it enforces a clear separation between UI and logic, which scales
  better for a banking codebase.

`AuthCubit` also drives navigation: `go_router` re-evaluates its `redirect` whenever auth state changes,
so login/logout/lock navigation is automatic and deep links can't bypass authentication.

## Local storage

`SharedPreferences` (wrapped by `StorageService`) persists:
- the logged-in user (session restored on app start),
- created savings plans (JSON),
- the biometric-lock preference.

Corrupted data is handled gracefully (treated as empty rather than crashing).

## API integration

Dashboard → **Financial Tips** loads `GET https://jsonplaceholder.typicode.com/posts?_limit=5` through Dio.
Timeouts, no-internet, and server errors are mapped to friendly messages, with loading, empty and error states
and a retry button.

## Error handling

- Form validation for every input (login and create savings).
- API failures, timeouts and no-internet mapped to `AppException` messages.
- Unexpected exceptions caught in Cubits and surfaced as safe messages (no raw stack traces in the UI).
- Corrupt local data never crashes the app.

## Bonus features implemented

- ✅ Biometrics (optional app lock, enabled from Profile)
- ✅ Pull to refresh (Dashboard, Products)
- ✅ Search savings products
- ✅ Filter products (All / Flexible / Fixed term)
- ✅ Animations (staggered fade/slide list items, hero icon transition, animated balance toggle)
- ✅ Unit tests (validators, formatters, `AuthCubit`, `SavingsCubit`)
- ✅ Widget tests (Login screen validation and submit)

## Assumptions

- Auth is mocked: the only valid account is `test@bank.com` / `Password123`; the user is "John Doe".
- Total Savings starts at ₦850,000 (mock). Each plan the user creates adds its first monthly contribution to the total.
- The three Recent Savings shown on first launch are mock plans; newly created plans appear first.
- The Dashboard greeting adapts to the time of day (Morning/Afternoon/Evening).
- Product minimum deposits for Fixed Deposit, Education and Vacation savings were not specified, so they are assumed.
- Duration in *Create Savings* is entered in months; it is prefilled for fixed-term products.
- Amounts are whole naira (no kobo).
- Public API data (JSONPlaceholder posts) is presented as "Financial Tips" purely to demonstrate API integration.

## Improvements with more time

- Real authentication (JWT + refresh tokens) and secure storage (`flutter_secure_storage`) for the session.
- PIN login as a fallback to biometrics.
- Move persistence to Hive/SQLite with proper models for transactions and per-user data.
- Firebase Analytics and push notifications (FCM).
- Offline caching of API data and connectivity banner.
- Localisation, accessibility audit, and golden tests.
- Integration tests and a CI pipeline (analyze + test + build APK on every PR).
- Edit/withdraw/top-up flows for savings plans.

## Screenshots

Add screenshots to `screenshots/` and link them here.