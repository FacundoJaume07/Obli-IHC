import 'package:eventio/screens/categories.dart';
import 'package:flutter/material.dart';
import '../screens/landing_page.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_page.dart';
import '../screens/event_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String eventDetails = '/event-details';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String categories = '/categories';

  static Map<String, WidgetBuilder> routes = {
    landing: (context) => const LandingPage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    dashboard: (context) => const DashboardScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    categories: (context) => const ExploreEventsScreen(),
  };

  // onGenerateRoute para rutas con argumentos
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == eventDetails) {
      final eventId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => EventDetailScreen(eventId: eventId),
      );
    }
    return null;
  }
}

/*
Asi se navega por las rutas:
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, AppRoutes.login); // Va al login
  },
  child: Text('Ir al login'),
)
*/
