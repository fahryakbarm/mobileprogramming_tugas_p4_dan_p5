import 'package:flutter/material.dart';
import 'package:flutter_pertemuan_4/page/beranda_page.dart';
import 'package:flutter_pertemuan_4/page/profile_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class SharedData {
  static String summary = "";
  // Variabel baru dengan nilai default
  static String location = "Jakarta, Indonesia";
  static String email = "fahry@example.com";
  static String phone = "0812-xxxx-xxxx";
  
  static List<Map<String, String>> experiences = [];
  static List<Map<String, String>> educations = [];
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage = 0;

  Widget _getPage(int index) {
    if (index == 0) return const BerandaPage();
    if (index == 1) return const ProfilePage();
    return const BerandaPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),
      home: Scaffold(
        body: _getPage(currentPage),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentPage,
          onTap: (i) => setState(() => currentPage = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.note_alt_outlined),
              title: const Text("Edit CV"),
              selectedColor: Colors.blueAccent,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_pin_outlined),
              title: const Text("Profile"),
              selectedColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}