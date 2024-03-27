import 'dart:async';
import 'package:bro_app_to/firebase_options.dart';
import 'package:bro_app_to/src/auth/presentation/screens/Sing_in.dart';
import 'package:bro_app_to/utils/agente_model.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:bro_app_to/utils/router_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Intro.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/agent_provider.dart';
import 'providers/player_provider.dart';
import 'providers/user_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/auth/data/datasources/remote_data_source_impl.dart';
import 'src/auth/domain/entitites/user_entity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = ApiConstants.stripePublicKey;
  await Stripe.instance.applySettings();

  // Bloquear la orientación del dispositivo en modo vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    MaterialColor customGreen = const MaterialColor(
      0xFF00F056,
      <int, Color>{
        50: Color(0xFFE0F7EF),
        100: Color(0xFFB3E1C9),
        200: Color(0xFF80CEA1),
        300: Color(0xFF4DBB79),
        400: Color(0xFF26AC5E),
        500: Color(0xFF00F056),
        600: Color(0xFF00C84B),
        700: Color(0xFF009A3B),
        800: Color(0xFF00732B),
        900: Color(0xFF004C1D),
      },
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => AgenteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: GetMaterialApp(
        title: 'Bro app',
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: customGreen, // Color principal
            backgroundColor: Colors.black, // Color de fondo
            cardColor: Colors.white, // Color de la tarjeta
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: const Locale('es', 'ES'),
        initialRoute: RouteHelper.getInitialRoute(),
        getPages: RouteHelper.routes,
        defaultTransition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 350),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
        ],
      ),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    loadRememberMe();
  }

  Future<void> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final String savedUsername = prefs.getString('username') ?? '';
      final String savedPassword = prefs.getString('password') ?? '';
      if (savedUsername.isNotEmpty && savedPassword.isNotEmpty) {
        final playerProvider =
            Provider.of<PlayerProvider>(context, listen: false);
        RemoteDataSourceImpl(playerProvider).signIn(
            UserEntity(username: savedUsername, password: savedPassword),
            context,
            true,
            true);
      } else {
        Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 44, 44, 44),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            width: 239,
            height: 117,
            fit: BoxFit.fill,
            'assets/icons/Logo.svg',
          ),
        ),
      ),
    );
  }
}
