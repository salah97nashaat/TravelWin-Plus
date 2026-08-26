import 'package:get/get.dart';
import 'package:travelwin/logic/bindings/provider_binding.dart';
import 'package:travelwin/logic/bindings/services_binding.dart';
import 'package:travelwin/view/screens/activities/activities_Screen.dart';
import 'package:travelwin/view/screens/auth/enter_code.dart';
import 'package:travelwin/view/screens/booking/booking.dart';
import 'package:travelwin/view/screens/favorites/favorites.dart';
import 'package:travelwin/view/screens/favorites/places_favorite.dart';
import 'package:travelwin/view/screens/favorites/realestate_favorite.dart';
import 'package:travelwin/view/screens/favorites/tour_guide_favorite.dart';
import 'package:travelwin/view/screens/favorites/trip_favorite.dart';
import 'package:travelwin/view/screens/medical%20tourism/medical%20tourism.dart';
import 'package:travelwin/view/screens/messeges/chat.dart';
import 'package:travelwin/view/screens/real%20state/add_property.dart';
import 'package:travelwin/view/screens/real%20state/add_property2.dart';
import 'package:travelwin/view/screens/real%20state/explore_real_state.dart';
import 'package:travelwin/view/screens/real%20state/real_state_details.dart';
import 'package:travelwin/view/screens/services/provider_chooser.dart';
import 'package:travelwin/view/screens/services/service_chooser.dart';
import 'package:travelwin/view/screens/services/state_chooser.dart';
import 'package:travelwin/view/screens/tour%20guidiens/search_for_tourG.dart';
import 'package:travelwin/view/screens/tour%20guidiens/sign_as_guide.dart';
import 'package:travelwin/view/screens/tourism_areas/area_details.dart';
import 'package:travelwin/view/screens/tourism_areas/place_details.dart';
import 'package:travelwin/view/screens/tourism_areas/tourism_areas.dart';
import 'package:travelwin/view/screens/welcome_screen.dart';
import '../logic/bindings/auth_biniding.dart';
import '../view/screens/about_screen.dart';
import '../view/screens/auth/edit_profile_screen.dart';
import '../view/screens/auth/forgot_password_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/signup_email_screen.dart';
import '../view/screens/auth/signup_screen.dart';
import 'package:travelwin/logic/bindings/main_binding.dart';
import '../view/screens/extra_prizes_screen.dart';
import '../view/screens/favorite/favorite_home.dart';
import '../view/screens/favorite/view_favorite_trip_details_screen.dart';
import '../view/screens/favorite/view_favorite_trips_screen.dart';
import '../view/screens/favorite/view_tour_place_favorite_details_screen.dart';
import '../view/screens/fortune_wheel.dart';
import '../view/screens/main_screen.dart';
import '../view/screens/notifications/view_notification_details_screen.dart';
import '../view/screens/notifications/view_notifications_screen.dart';
import '../view/screens/point_screen.dart';
import '../view/screens/privacy_screen.dart';
import '../view/screens/profile_screen.dart';
import '../view/screens/settings_screen.dart';
import '../view/screens/ticket/view_ticket_screen.dart';
import '../view/screens/tour guidiens/sign_as_guide2.dart';
import '../view/screens/tour_programs.dart';
import '../view/screens/tourist_areas/choose_state.dart';
import '../view/screens/tourist_areas/choose_type_tourist_areas.dart';
import '../view/screens/tourist_areas/view_tour_place_details_screen.dart';
import '../view/screens/tourist_areas/view_touristArea_favorite_screen.dart';
import '../view/screens/tourist_areas/view_touristArea_screen.dart';
import '../view/screens/trip/view_trip_details_screen.dart';
import '../view/screens/trip/view_trips_screen.dart';
import '../view/term/view_term_screen.dart';

class AppRoutes {
  //initialRoute

  static const welcome = Routes.welcomeScreen;
  static const mainScreen = Routes.mainScreen;
  //getPages

  static final routes = [
    GetPage(
      name: Routes.welcomeScreen,
      page: () => const WelcomeScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SettingsScreen,
      page: () => SettingsScreen(),
      bindings: [
        AuthBinding(),
        MainBininding(),
      ],
    ),
    GetPage(
      name: Routes.signUpScreen,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SignUpEmailScreen,
      page: () => SignUpEmailScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPasswordScreen,
      page: () => ForgotPasswordScreen(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => MainScreen(), //AppLovinAdv(),
      bindings: [
        AuthBinding(),
        MainBininding(),
      ],
    ),
    GetPage(name: Routes.SearchTour, page: () => SearchForTourGuide()),
    GetPage(
      name: Routes.tourprogramsScreen,
      page: () => TourProgramsScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ViewTripsScreen,
      page: () => ViewTripsScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ViewFavoritrTripsScreen,
      page: () => ViewFavoritrTripsScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ViewTripsDetailsScreen,
      page: () => ViewTripsDetailsScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ViewFavoriteTripsDetailsScreen,
      page: () => ViewFavoriteTripsDetailsScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ProfileScreen,
      page: () => ProfileScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ChooseState,
      page: () => ChooseState(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ChooseTypeTouristAreasScreen,
      page: () => ChooseTypeTouristAreasScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ViewTouristAreaScreen,
      page: () => ViewTouristAreaScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ViewTourPlaceDetailsScreen,
      page: () => ViewTourPlaceDetailsScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.EditProfileScreen,
      page: () => EditProfileScreen(),
      bindings: [
        AuthBinding(),
        MainBininding(),
      ],
    ),
    GetPage(
      name: Routes.ViewNotificationScreen,
      page: () => ViewNotificationScreen(),
      //  binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.ViewNotificationDetailsScreen,
      page: () => ViewNotificationDetailsScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.FavoriteHomeScreen,
      page: () => FavoriteHomeScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.AboutScreen,
      page: () => AboutScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.ViewTouristAreaFavoriteScreen,
      page: () => ViewTouristAreaFavoriteScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.ViewTourPlaceFavoriteDetailsScreen,
      page: () => ViewTourPlaceFavoriteDetailsScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.PointScreen,
      page: () => PointScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.ViewTicketScreen,
      page: () => ViewTicketScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.PrivacyScreen,
      page: () => PrivacyScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.ViewTermScreen,
      page: () => ViewTermScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.signUpAsGuide,
      page: () => SignAsGuide(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.signUpAsGuide2,
      page: () => SignAsGuide2(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.ExtraPrizesScreen,
      page: () => ExtraPrizesScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(
      name: Routes.FortuneWheelScreen,
      page: () => FortuneWheelScreen(),
      // binding: NotificationBininding(),
    ),
    GetPage(name: Routes.ChatScreen, page: () => Chat()),
    GetPage(name: Routes.MedicalTourism, page: () => MedicalTourism()),
    GetPage(name: Routes.booking, page: () => Booking()),
    GetPage(name: Routes.tourismAreas, page: () => TourismAreas()),
    GetPage(name: Routes.areaDetails, page: () => AreaDetails()),
    GetPage(name: Routes.placeDetails, page: () => PlaceDetails()),
    GetPage(name: Routes.exploreRealState, page: () => ExploreRealState()),
    GetPage(name: Routes.favorites, page: () => Favorites()),
    GetPage(name: Routes.favoriteTrip, page: () => TripFavorite()),
    GetPage(name: Routes.favoritePlace, page: () => PlacesFavorite()),
    GetPage(name: Routes.favoriteGuide, page: () => TourGuideFavorite()),
    GetPage(name: Routes.favoriteRealEstate, page: () => RealStateFavorite()),
    GetPage(name: Routes.addProperty, page: () => AddProperty()),
    GetPage(name: Routes.addProperty2, page: () => AddProperty2()),
    GetPage(name: Routes.propertyDetails, page: () => PropertyDetails()),
    GetPage(name: Routes.enterCode, page: () => EnterCodeScreen()),
    GetPage(name: Routes.stateChooser, page: () => StateChooser()),
    GetPage(
        name: Routes.serviceChooser,
        page: () => ServiceChooser(),
        binding: ServicesBinding()),
    GetPage(
        name: Routes.providerChooser,
        page: () => ProviderChooser(),
        binding: ProviderBinding()),
    GetPage(
      name: Routes.ActivitiesScreen,
      page: () => ActivitiesScreen(),
      binding: MainBininding(),
    )
  ];
}

class Routes {
  static const welcomeScreen = '/welcomeScreen';
  static const booking = '/booking';
  static const enterCode = '/enterCode';
  static const areaDetails = '/areaDetails';
  static const placeDetails = '/placeDetails';
  static const tourismAreas = '/tourismAreas';
  static const MedicalTourism = '/medicalTourism';
  static const loginScreen = '/loginScreen';
  static const signUpScreen = '/signUpScreen';
  static const signUpAsGuide = '/signUpAsGide';
  static const signUpAsGuide2 = '/signUpAsGide2';
  static const forgotPasswordScreen = '/forgotPasswordScreen';
  static const mainScreen = '/mainScreen';
  static const tourprogramsScreen = '/tourprogramsScreen';
  static const ViewTripsScreen = '/ViewTripsScreen';
  static const ViewFavoritrTripsScreen = '/ViewFavoritrTripsScreen';
  static const SearchTour = '/SearchTour';
  static const ViewTripsDetailsScreen = '/ViewTripsDetailsScreen';
  static const ChatScreen = '/ChatScreen';
  static const SettingsScreen = '/SettingsScreen';
  static const ProfileScreen = '/ProfileScreen';
  static const ChooseState = '/ChooseState';
  static const ChooseTypeTouristAreasScreen = '/ChooseTypeTouristAreasScreen';
  static const ViewTouristAreaScreen = '/ViewTouristAreaScreen';
  static const ViewTourPlaceDetailsScreen = '/ViewTourPlaceDetailsScreen';
  static const SignUpEmailScreen = '/SignUpEmailScreen';
  static const EditProfileScreen = '/EditProfileScreen';
  static const ViewNotificationScreen = '/ViewNotificationScreen';
  static const ViewNotificationDetailsScreen = '/ViewNotificationDetailsScreen';
  static const ActivitiesScreen = '/ActivitiesScreen';
  static const FavoriteHomeScreen = '/FavoriteHomeScreen';
  static const AboutScreen = '/AboutScreen';
  static const ViewFavoriteTripsDetailsScreen =
      '/ViewFavoriteTripsDetailsScreen';
  static const ViewTouristAreaFavoriteScreen = '/ViewTouristAreaFavoriteScreen';

  static const ViewTourPlaceFavoriteDetailsScreen =
      '/ViewTourPlaceFavoriteDetailsScreen';
  static const PointScreen = '/PointScreen';
  static const ViewTicketScreen = '/ViewTicketScreen';
  static const PrivacyScreen = '/PrivacyScreen';
  static const ViewTermScreen = '/ViewTermScreen';
  static const ExtraPrizesScreen = '/ExtraPrizesScreen';
  static const FortuneWheelScreen = '/FortuneWheelScreen';
  static const exploreRealState = '/exploreRealState';
  static const favorites = '/favorites';
  static const favoriteTrip = '/favoriteTrip';
  static const favoritePlace = '/favoritePlace';
  static const favoriteGuide = '/favoriteGuide';
  static const favoriteRealEstate = '/favoriteRealEstate';
  static const addProperty = '/addProperty';
  static const addProperty2 = '/addProperty2';
  static const propertyDetails = '/propertyDetails';

  static const stateChooser = '/stateChooser';
  static const serviceChooser = '/serviceChooser';
  static const providerChooser = '/providerChooser';
}
