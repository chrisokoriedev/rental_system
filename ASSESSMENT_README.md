# Mobile App Developer Assessment Plan

## Objective
Build a mock-up rental system Flutter app that includes:
- Authentication
- Payment gateway integration (Paystack, Flutterwave, Stripe, or equivalent)
- iOS and Android compatibility

This document is the step-by-step implementation guide.

## Delivery Strategy
- Phase 1 (Today): UI-only implementation for core rental flow.
- Phase 2: Authentication flow integration.
- Phase 3: Payment integration and transaction flow.
- Phase 4: QA, optimization, and platform readiness checks.

## Tech Stack
- Flutter (single codebase for iOS and Android)
- Riverpod (state management)
- GoRouter (navigation)
- Dio (API-ready network layer)
- Firebase Auth (authentication)
- Payment plugin (Paystack/Flutterwave/Stripe)

## Step-by-Step Roadmap

## 1. Project Foundation
1. Confirm dependencies in `pubspec.yaml`.
2. Define folder architecture (feature-first + clean layering):
   - `lib/core/` for app-wide utilities and shared widgets.
   - `lib/features/auth/` for sign in/up UI and logic.
   - `lib/features/rentals/` for listings, details, booking.
   - `lib/features/payments/` for checkout and payment result.
3. Set up app routing with route constants and guarded paths.

## 2. UI Scope for Today
Goal: Complete high-fidelity mock UI that demonstrates the full rental journey.

### 2.1 Screens to Build
1. Splash / onboarding screen.
2. Sign in screen.
3. Sign up screen.
4. Home screen (featured rentals + categories + search).
5. Rental listing screen (grid/list with filters).
6. Rental details screen (images, specs, price, host, reviews).
7. Booking summary screen (dates, totals, fees).
8. Checkout/payment method selection screen.
9. Payment success/failure mock result screen.
10. Profile/orders screen (booking history mock).

### 2.2 UI Components to Reuse
1. `AppButton` (primary/secondary/loading styles).
2. `AppTextField` (email, password, search, validation states).
3. `RentalCard` (image, title, location, price, rating).
4. `SectionHeader` (title + "See all").
5. `PriceBreakdownCard` (subtotal, fees, total).
6. `EmptyState` and `ErrorState` widgets.
7. `Shimmer/Skeleton` loading widgets.

### 2.3 UI State Requirements (Mock Data)
1. Loading state for home and listing.
2. Empty listing state.
3. Error state with retry action.
4. Form validation UI states (invalid email, weak password, required fields).
5. Booking CTA enabled/disabled states.

## 3. Authentication Integration (After UI)
1. Wire sign in/sign up forms to Firebase Auth.
2. Add password reset screen.
3. Add auth guard in router:
   - Logged out users redirected to sign in.
   - Logged in users can access booking/checkout/profile.
4. Show user session in profile and logout action.

## 4. Payment Integration (After Auth)
1. Choose one gateway (recommended: Paystack for this assessment).
2. Add payment initialization flow from checkout totals.
3. Handle callbacks:
   - success
   - cancelled
   - failed
4. Save mock transaction record in Firestore.
5. Display payment result and booking confirmation.

## 5. iOS and Android Compatibility Checklist
1. Verify responsive layouts across small and large devices.
2. Test both portrait and keyboard-safe interactions.
3. Configure Android and iOS app permissions where required.
4. Validate build commands:
   - `flutter run`
   - `flutter build apk`
   - `flutter build ios --no-codesign`
5. Confirm no platform-specific UI breakage.

## 6. Folder Structure Target
```text
lib/
  core/
    constants/
    theme/
    widgets/
    router/
  features/
    auth/
      presentation/
      providers/
    rentals/
      presentation/
      providers/
    payments/
      presentation/
      providers/
    bookings/
      presentation/
      providers/
  main.dart
```

## 7. UI-First Task Breakdown for Today
1. Define app theme (colors, typography, spacing, button styles).
2. Set up route skeleton and blank screens.
3. Build reusable widgets/components.
4. Build auth UI screens.
5. Build rental discovery UI screens.
6. Build booking and checkout UI screens.
7. Build profile/history UI screens.
8. Add mock state flows (loading/empty/error/success).
9. Polish spacing, accessibility, and responsiveness.
10. Take screenshots of key screens for assessment submission.

## 8. Acceptance Criteria
- Core rental flow is navigable end-to-end in UI mock form.
- Authentication screens are complete and ready to wire.
- Checkout/payment screens are complete and ready to wire.
- Layout works on both Android and iOS form factors.
- Code is organized and interview-ready.

## 9. Suggested Timeline
- Day 1: UI complete for all required flows.
- Day 2: Firebase Auth wiring + router guards.
- Day 3: Payment integration + booking confirmation flow.
- Day 4: Testing, bug fixes, and submission packaging.

## 10. Submission Package
1. Source code repository.
2. README with setup and run instructions.
3. Short demo video (2 to 5 minutes) showing:
   - auth flow
   - browsing rentals
   - booking checkout
   - payment success/failure paths
4. Screenshots for key screens.

## Notes
- Today is focused on UI implementation only.
- Real backend integration can be replaced by mock providers first, then swapped with live services.