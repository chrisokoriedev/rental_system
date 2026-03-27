import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_session_provider.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/bookings/presentation/screens/booking_summary_screen.dart';
import '../../features/payments/presentation/screens/checkout_screen.dart';
import '../../features/payments/presentation/screens/payment_result_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/rentals/presentation/screens/home_screen.dart';
import '../../features/rentals/presentation/screens/rental_details_screen.dart';
import '../../features/rentals/presentation/screens/rental_listing_screen.dart';
import '../../features/rentals/presentation/screens/search_screen.dart';
import '../constants/app_routes.dart';
import 'app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authSessionProvider);

  return GoRouter(
    initialLocation: isLoggedIn ? AppRoutes.home : AppRoutes.signIn,
    redirect: (context, state) {
      final onAuthPages =
          state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp;

      if (!isLoggedIn && !onAuthPages) {
        return AppRoutes.signIn;
      }

      if (isLoggedIn && onAuthPages) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.bookings,
            builder: (context, state) => const BookingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.rentals,
        builder: (context, state) => const RentalListingScreen(),
      ),
      GoRoute(
        path: AppRoutes.rentalDetails,
        builder: (context, state) => const RentalDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingSummary,
        builder: (context, state) => const BookingSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentResult,
        builder: (context, state) => const PaymentResultScreen(),
      ),
    ],
  );
});
