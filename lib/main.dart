import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:track/Models/habithive.dart';
import 'package:track/bloc/habit_bloc.dart';
import 'package:track/bloc/theme_bloc.dart';
import 'package:track/local_storage_repository.dart';
import 'package:track/screens/home.dart';
import 'package:track/screens/welcome.dart';
import 'package:track/theme/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageRepository().init();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());


  await Hive.openBox<Habit>('habits');
  await Hive.openBox<int>("heatmap");
  await Hive.openBox('settings');


  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeBloc()),
                  BlocProvider(create: (_)=> HabitBloc())],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final bool? newuser =  LocalStorageRepository.getBool("newuser") ?? true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: state is ThemeDark ? AppTheme.darkTheme : AppTheme.lightTheme,

          home: newuser!? welcomePage(): Home(),
        );
      },
    );
  }
}
