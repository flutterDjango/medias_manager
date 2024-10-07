import 'package:flutter/material.dart';
import 'package:medias_manager/screens/screens.dart';

// class ContactsManagerApp extends ConsumerWidget {
//   const ContactsManagerApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final routeConfig = ref.watch(routesProvider);
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.light,
//       routerConfig: routeConfig,
//     );
//   }
// }
class MediasManager extends StatelessWidget {
  const MediasManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 78, 13, 151),
                  Color.fromARGB(255, 107, 15, 168)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const StartScreen()),
      ),
    );
  }
}
