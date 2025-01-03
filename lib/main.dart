import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dash_board.dart';
import 'dynamic_ui_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final provider = DynamicUIProvider();
  await provider.loadConfig('assets/config.json');

  runApp(MyApp(provider: provider));
}

class MyApp extends StatelessWidget {
  final DynamicUIProvider provider;

  const MyApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => provider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DynamicUIProvider>(
        builder: (context, provider, _) {
          final uiData = provider.uiData;
          return uiData.isNotEmpty
              ? LayoutBuilder(
            builder: (context, constraints) {
              // Adapt layout based on screen size
              if (constraints.maxWidth > 600) {
                return Dashboard(uiData: uiData);
              } else {
                return Dashboard(uiData: uiData);
              }
            },
          )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}