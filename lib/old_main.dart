import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'ai_service.dart';

// Global list to store saved stories (temporary solution for demo purposes)
List<String> savedStories = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const StorySparkApp());
}

class StorySparkApp extends StatelessWidget {
  const StorySparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StorySpark',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showStorySelectionDialog(BuildContext context) {
    if (savedStories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No stories saved yet!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Story to Publish'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: savedStories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    savedStories[index].substring(0, 30) + '...',
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublishScreen(story: savedStories[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                print('Sign Up clicked');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Reduced horizontal padding
                child: Image.asset(
                  'assets/signup_button.png',
                  width: 500,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Sign Up Button Missing',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Log In clicked');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Reduced horizontal padding
                child: Image.asset(
                  'assets/login_button.png',
                  width: 500, // Increased size to match "SIGN UP"
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Log In Button Missing',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.purple,
                  child: const Center(
                    child: Text(
                      'Background Missing',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ),
          // Main content (cloud buttons and static image)
          Column( // Kept as Column to prevent scrolling
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              // Buttons (using custom images with uniform size)
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StoryCreationScreen()),
                        );
                        print('Start a New Story clicked');
                      },
                      child: SizedBox(
                        width: 450,
                        height: 300,
                        child: Image.asset(
                          'assets/spark_a_story_button.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'Spark a Story Button Missing',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 0),
                    Transform.translate(
                      offset: const Offset(-15, -45),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StoryVaultScreen()),
                          );
                          print('My Story Vault clicked');
                        },
                        child: SizedBox(
                          width: 295,
                          height: 90,
                          child: Image.asset(
                            'assets/my_vault_button.png', // <-- FIXED LINE
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'My Vault Button Missing',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 0),
                    Transform.translate(
                      offset: const Offset(-25, -110),
                      child: GestureDetector(
                        onTap: () => _showStorySelectionDialog(context),
                        child: SizedBox(
                          width: 325,
                          height: 250,
                          child: Image.asset(
                            'assets/publish_button.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'Publish Button Missing',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Space before the static image
              // Static image of the scroll with "How To" description
              SizedBox(
                width: 300, // Adjust width to fit the green rectangle area
                height: 200, // Adjust height to fit the green rectangle area
                child: Image.asset(
                  'assets/how_to_scroll.png', // Static image with description
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'How To Image Missing',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Space at the bottom
            ],
          ),
          // Logo (positioned on top)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Logo Missing',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryCreationScreen extends StatefulWidget {
  const StoryCreationScreen({super.key});

  @override
  _StoryCreationScreenState createState() => _StoryCreationScreenState();
}

class _StoryCreationScreenState extends State<StoryCreationScreen> {
  final TextEditingController _promptController = TextEditingController();
  double _storyAI = 50.0;
  double _imageAI = 50.0;
  String _generatedStory = '';
  bool _isGenerating = false;

  Future<void> _generateStory() async {
    String prompt = _promptController.text.isEmpty
        ? 'A magical adventure'
        : _promptController.text;
    
    setState(() {
      _isGenerating = true;
      _generatedStory = 'Generating your story...';
    });

    try {
      String story;
      
      // Try OpenAI first, then Gemini if OpenAI fails
      if (AIService.hasOpenAIKey) {
        story = await AIService.generateStoryWithOpenAI(
          prompt: prompt,
          storyAILevel: _storyAI.round(),
          imageAILevel: _imageAI.round(),
        );
      } else if (AIService.hasGeminiKey) {
        story = await AIService.generateStoryWithGemini(
          prompt: prompt,
          storyAILevel: _storyAI.round(),
          imageAILevel: _imageAI.round(),
        );
      } else {
        story = '''No AI service configured! 

To enable AI story generation:
1. Get an API key from OpenAI (https://openai.com/api/) or Google Gemini
2. Add it to your .env file:
   OPENAI_API_KEY=your_key_here
   OR
   GEMINI_API_KEY=your_key_here
3. Restart the app

For now, here's a sample story about: "$prompt"
Once upon a time, a brave young hero embarked on an incredible adventure filled with wonder and magic...''';
      }
      
      setState(() {
        _generatedStory = story;
      });
    } catch (e) {
      setState(() {
        _generatedStory = 'Error generating story: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _saveStory() {
    if (_generatedStory.isNotEmpty) {
      setState(() {
        savedStories.add(_generatedStory);
        print('Saved Story: $_generatedStory');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story saved to My Story Vault!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Story'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your story idea:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'e.g., A brave puppy explores a forest',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              'AI Involvement:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _storyAI,
              min: 1,
              max: 100,
              divisions: 99,
              label: 'Story AI: ${_storyAI.round()}%',
              activeColor: Colors.purple,
              onChanged: (value) {
                setState(() {
                  _storyAI = value;
                });
              },
            ),
            Slider(
              value: _imageAI,
              min: 1,
              max: 100,
              divisions: 99,
              label: 'Image AI: ${_storyAI.round()}%',
              activeColor: Colors.purple,
              onChanged: (value) {
                setState(() {
                  _imageAI = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ElevatedButton(
            onPressed: _isGenerating ? null : _generateStory,
            style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, 50),
            ),
            child: _isGenerating 
                ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Generate'),
                  ),
                ElevatedButton(
                  onPressed: _saveStory,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Generated Story:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(_generatedStory),
            const SizedBox(height: 20),
            const Text(
              'Generated Image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/placeholder_image.jpg',
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Placeholder Image Missing',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StoryVaultScreen extends StatelessWidget {
  const StoryVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Story Vault'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: savedStories.isEmpty
          ? const Center(
              child: Text(
                'No stories saved yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: savedStories.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      savedStories[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PublishScreen extends StatelessWidget {
  final String story;

  const PublishScreen({super.key, required this.story});

  Future<void> _exportAsText(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/story_${DateTime.now().millisecondsSinceEpoch}.txt';
        final file = File(filePath);
        await file.writeAsString(story);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Story exported to $filePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export story: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publish Story'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Story:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  story,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _exportAsText(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Export as Text'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}