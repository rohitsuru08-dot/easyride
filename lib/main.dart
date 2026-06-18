// Main entry point for EasyRide app
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:easy_ride/core/theme/app_theme.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/providers/auth_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/providers/ticket_provider.dart';
import 'package:easy_ride/providers/route_provider.dart';
import 'package:easy_ride/providers/conductor_provider.dart';
import 'package:easy_ride/providers/admin_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/navigation/app_router.dart';
import 'package:easy_ride/firebase_options.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Force long-polling on web to avoid ERR_QUIC_PROTOCOL_ERROR on the
  // Firestore WebChannel. Has no effect on mobile.
  if (kIsWeb) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      webExperimentalForceLongPolling: true,
    );
  }

  // Portrait lock only applies on mobile — web ignores SystemChrome
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Suppress Flutter web engine-level assertion triggered by browser resize
  // when keyboard is dismissed — not a bug in our code.
  if (kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.toString().contains('ViewInsets cannot be negative')) return;
      FlutterError.presentError(details);
    };
  }

  runApp(const EasyRideApp());
}

class EasyRideApp extends StatelessWidget {
  const EasyRideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Language provider
        ChangeNotifierProvider(create: (_) => LanguageProvider()..initialize()),

        // Auth provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // User provider
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // Ticket provider
        ChangeNotifierProvider(create: (_) => TicketProvider()),

        // Route provider
        ChangeNotifierProvider(create: (_) => RouteProvider()),

        // Conductor provider
        ChangeNotifierProvider(create: (_) => ConductorProvider()),

        // Admin provider
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'EasyRide - APSRTC',
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.lightTheme,

            // Localization
            locale: languageProvider.locale,
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: const [
              LocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              return supportedLocales.first;
            },

            // Routing
            initialRoute: RouteConstants.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
