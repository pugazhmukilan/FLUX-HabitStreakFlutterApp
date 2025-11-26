import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/bloc/habit_bloc.dart';
import 'package:track/bloc/theme_bloc.dart';
import 'package:track/local_storage_repository.dart';
import 'package:track/screens/welcome.dart';
import 'package:track/theme/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageRepository().init();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeBloc()),
                  BlocProvider(create: (_)=> HabitBloc())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: state is ThemeDark ? AppTheme.darkTheme : AppTheme.lightTheme,

          home: welcomePage(),
        );
      },
    );
  }
}
