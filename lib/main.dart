import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/routes/route_paths.dart';
import 'package:task_manager/screens/create_task_screen.dart';
import 'package:task_manager/screens/sign_in_screen.dart';
import 'package:task_manager/screens/task_show_screen.dart';
import 'package:task_manager/screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_pk/IGenericOverviewCard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TasksProvider>(
          create: (context) => TasksProvider(),
        ),
        ChangeNotifierProvider<IGenericOverviewCard>(
          create: (context) => Provider.of<TasksProvider>(context, listen: false),
        ),
      ],
      child: MaterialApp(
        title: 'Your App',
        initialRoute: RoutePaths.SIGN_IN_SCREEN,
        routes: {
          RoutePaths.SIGN_IN_SCREEN: (context) => SignInScreen(),
          RoutePaths.TASKS_LIST_SCREEN: (context) => TaskListScreen(),
          RoutePaths.TaskSHOWSCREEN: (context) => TaskShowScreen(),
          RoutePaths.CREATE_TASK: (context) => CreateTaskScreen(),
        },
      ),
    );
  }
}
