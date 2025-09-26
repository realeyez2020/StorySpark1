import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/create_story_screen.dart';
import 'widgets/modern_sidebar.dart';
import 'old_main.dart' as old_main; // Import old functionality

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Try to load .env file, but don't crash if it doesn't exist
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('No .env file found, continuing without environment variables');
  }
  
  runApp(const ModernStorySparkApp());
}

class ModernStorySparkApp extends StatelessWidget {
  const ModernStorySparkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StorySpark',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(0xFF6366F1, {
          50: const Color(0xFFF0F4FF),
          100: const Color(0xFFE0E7FF),
          200: const Color(0xFFD1D5FF),
          300: const Color(0xFFA5B4FC),
          400: const Color(0xFF818CF8),
          500: const Color(0xFF6366F1),
          600: const Color(0xFF4F46E5),
          700: const Color(0xFF4338CA),
          800: const Color(0xFF3730A3),
          900: const Color(0xFF312E81),
        }),
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        fontFamily: 'SF Pro Display',
      ),
      home: const MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String currentRoute = 'home';
  bool isSidebarCollapsed = false;

  void _handleNavigation(String route) {
    setState(() {
      currentRoute = route;
    });
  }

  void _toggleSidebar() {
    setState(() {
      isSidebarCollapsed = !isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Modern Sidebar
          ModernSidebar(
            onNavigate: _handleNavigation,
            currentRoute: currentRoute,
            isCollapsed: isSidebarCollapsed,
            onToggle: _toggleSidebar,
          ),
          // Main Content Area
          Expanded(
            child: _buildCurrentScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (currentRoute) {
      case 'home':
        return const HomeScreen();
      case 'login':
        return const AuthScreen();
      case 'library':
        return const LibraryScreen();
      case 'create':
        return const CreateStoryScreen();
      case 'favorites':
        return const FavoritesScreen();
      case 'purchases':
        return const PurchasesScreen();
      case 'illustrations':
        return const IllustrationsScreen();
      case 'videos':
        return const VideosScreen();
      case 'print':
        return const PrintBooksScreen();
      case 'editor':
        return const StoryEditorScreen();
      case 'tips':
        return const WritingTipsScreen();
      case 'premium':
        return const PremiumPlansScreen();
      case 'settings':
        return const SettingsScreen();
      case 'learn':
        return const LearnScreen();
      default:
        return const HomeScreen();
    }
  }
}

// Placeholder screens that we'll implement later
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Story Library Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}



class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'My Favorites Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'My Purchases Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class IllustrationsScreen extends StatelessWidget {
  const IllustrationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Story Illustrations Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Story Videos Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PrintBooksScreen extends StatelessWidget {
  const PrintBooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Print Books Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class StoryEditorScreen extends StatelessWidget {
  const StoryEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Story Editor Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WritingTipsScreen extends StatelessWidget {
  const WritingTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Writing Tips Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PremiumPlansScreen extends StatelessWidget {
  const PremiumPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Premium Plans Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Settings Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F23),
      child: const Center(
        child: Text(
          'Learning Resources Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
