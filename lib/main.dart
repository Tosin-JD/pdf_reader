import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/domain/repositories/get_last_page.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository_impl.dart';
import 'package:pdf_reader/domain/repositories/save_last_page.dart';
import 'package:pdf_reader/domain/usecases/add_bookmark.dart';
import 'package:pdf_reader/domain/usecases/get_bookmarks.dart';
import 'package:pdf_reader/domain/usecases/pick_pdf_file.dart';
import 'package:pdf_reader/domain/usecases/share_pdf_file.dart';
import 'package:pdf_reader/presentation/bloc/orientation_cubit.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import 'package:pdf_reader/presentation/bloc/wakelock_cubit.dart';
import 'package:pdf_reader/presentation/screens/about_developer_screen.dart';
import 'package:pdf_reader/presentation/screens/home_screen.dart';
import 'package:pdf_reader/presentation/screens/settings_screen.dart';
import 'package:pdf_reader/core/navigation/navigation_service.dart';
import 'package:pdf_reader/presentation/screens/about_app_screen.dart';
import 'package:pdf_reader/presentation/bloc/theme_cubit.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

final NavigationService navigationService = NavigationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pdfRepo = PdfRepositoryImpl();

  final pickPdf = PickPdfFile(pdfRepo);
  final savePage = SaveLastPage(pdfRepo);
  final getLastPage = GetLastPage(pdfRepo);
  final addBookmark = AddBookmark(pdfRepo);
  final getBookmarks = GetBookmarks(pdfRepo);
  final sharePdf = SharePdfFile();

  final pdfCubit = PdfCubit(
    pdfRepo,
    pickPdf,
    savePage,
    getLastPage,
    addBookmark,
    getBookmarks,
    sharePdf,
  );

  // Listen to share intent
  ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) async {
    if (value.isNotEmpty && value.first.path.toLowerCase().endsWith(".pdf")) {
      await pdfCubit.loadPdfFromPath(value.first.path);  // <- make sure this method exists
    } else {
      await pdfCubit.loadLastOpenedFile();
    }
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => OrientationCubit()),
        BlocProvider(create: (_) => WakelockCubit()),
        BlocProvider(create: (_) => pdfCubit),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'PDF Reader',
          navigatorKey: navigationService.navigatorKey,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const HomeScreen(),
          routes: {
            '/settings': (_) => const SettingsScreen(),
            '/about-app': (_) => const AboutAppScreen(),
            '/about-developer': (_) => const AboutDeveloperScreen(),
          },
        );
      },
    );
  }
}
