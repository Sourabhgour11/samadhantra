import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/constant/app_color.dart';
import 'app/data/services/shared_pref_service.dart';
import 'app/global_routes/app_pages.dart';
import 'app/global_routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return GetMaterialApp(
          title: 'Samadhantra',
          debugShowCheckedModeBanner: false,

          // ✅ Decide route ONCE at startup
          initialRoute: PrefService.isFirstTime
              ? AppRoutes.onboardingScreen
              : AppRoutes.splash,

          getPages: AppPages.routes,

          theme: ThemeData(useMaterial3: false,
            primaryColor: AppColors.appColor,
            scaffoldBackgroundColor: AppColors.background,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
        );
      },
    );
  }
}
