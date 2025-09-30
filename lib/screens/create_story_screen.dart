import 'package:flutter/material.dart';
import 'story_preview_screen.dart';
import '../services/ai_client.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String selectedGenre = 'Fantasy 🧙‍♀️';
  String selectedAgeGroup = '5-8 years';
  String selectedLength = 'Short (5-10 pages)';
  String selectedStyle = 'Classic Storybook 📚';
  String selectedBookFormat = 'picture-book';
  double aiIntervention = 0.5; // 0.0 = Less AI, 1.0 = More AI
  bool isGenerating = false;

  // AI Client - using mock for now, replace with real backend URL
  late final AiClient aiClient;

  final List<String> genres = [
    'Fantasy 🧙‍♀️',
    'Adventure 🗺️', 
    'Space 🚀',
    'Friendship 🤝',
    'Animals 🐾',
    'Mystery 🕵️',
    'Educational 📖',
    'Bedtime 🌙',
  ];

  final List<String> ageGroups = [
    '3-5 years',
    '5-8 years', 
    '8-12 years',
    '12+ years',
  ];

  final List<String> storyLengths = [
    'Short (5-10 pages)',
    'Medium (10-20 pages)',
    'Long (20+ pages)',
  ];

  final List<String> storyStyles = [
    'Classic Storybook 📚',
    'Comic Book 💥',
    'Disney Style 🏰',
    'Anime Style 🎌',
    'Pixar 3D 🎭',
    'Watercolor Art 🎨',
    'Cartoon Style 🎪',
    'Manga Style 📖',
    'Fairy Tale 🧚‍♀️',
    'Modern Minimalist ✨',
    'Pop Art 🌈',
    'Vintage Illustration 📰',
  ];

  final Map<String, String> bookFormats = {
    'picture-book': 'Picture Book (8.5×11) 📖',
    'square-book': 'Square Book (8×8) ⬜',
    'board-book': 'Board Book (6×6) 🧸',
    'chapter-book': 'Chapter Book (6×8) 📚',
  };

  @override
  void initState() {
    super.initState();
    // Using new Stories Proxy backend
    aiClient = AiClient('http://localhost:3001/api');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 40),
            
            // Main Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side - Story Creation Form
                Expanded(
                  flex: 2,
                  child: _buildStoryForm(),
                ),
                const SizedBox(width: 40),
                
                // Right Side - Tips & Preview
                Expanded(
                  flex: 1,
                  child: _buildTipsAndPreview(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✨',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Spark a Story',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Let AI help you create magical stories. Just describe your idea and watch it come to life!',
          style: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2D4A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Story Title
          _buildFormSection(
            'Story Title',
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter your story title...',
                hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                filled: true,
                fillColor: const Color(0xFF252542),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3D3D5C)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3D3D5C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 24),

          // Story Prompt
          _buildFormSection(
            'Story Idea',
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your story idea... What should happen? Who are the characters? What\'s the adventure?',
                hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                filled: true,
                fillColor: const Color(0xFF252542),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3D3D5C)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3D3D5C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 32),

          // Settings Rows
          Row(
            children: [
              Expanded(child: _buildDropdown('Genre', selectedGenre, genres, (value) {
                setState(() => selectedGenre = value!);
              })),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown('Age Group', selectedAgeGroup, ageGroups, (value) {
                setState(() => selectedAgeGroup = value!);
              })),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _buildBookFormatDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown('Style', selectedStyle, storyStyles, (value) {
                setState(() => selectedStyle = value!);
              })),
            ],
          ),

          const SizedBox(height: 32),

          // Magic AI Intervention Slider
          _buildAIInterventionSlider(),

          const SizedBox(height: 40),

          // Generate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isGenerating ? null : _generateStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isGenerating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Creating your story...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    )
                  : const Text('✨ Spark My Story', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF252542),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D3D5C)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF252542),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookFormatDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Book Format',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF252542),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D3D5C)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBookFormat,
              isExpanded: true,
              dropdownColor: const Color(0xFF252542),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items: bookFormats.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(bookFormats[key]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedBookFormat = value!);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIInterventionSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '🪄',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI Magic Level',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              _getAILevelText(),
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF252542),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D3D5C)),
          ),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  activeTrackColor: const Color(0xFF6366F1),
                  inactiveTrackColor: const Color(0xFF3D3D5C),
                  thumbColor: const Color(0xFF8B5CF6),
                  overlayColor: Color(0xFF8B5CF6).withOpacity(0.2),
                ),
                child: Slider(
                  value: aiIntervention,
                  min: 0.0,
                  max: 1.0,
                  divisions: 4,
                  onChanged: (value) {
                    setState(() {
                      aiIntervention = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Let me write',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'AI takes over',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getAILevelText() {
    if (aiIntervention <= 0.2) return 'Minimal AI';
    if (aiIntervention <= 0.4) return 'Light Touch';
    if (aiIntervention <= 0.6) return 'Balanced';
    if (aiIntervention <= 0.8) return 'AI Enhanced';
    return 'Full AI Magic';
  }

  Widget _buildTipsAndPreview() {
    return Column(
      children: [
        // Writing Tips
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2D2D4A), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  const Text(
                    'Writing Tips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._buildTipsList(),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Quick Ideas
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2D2D4A), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🎲', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  const Text(
                    'Quick Ideas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._buildQuickIdeas(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTipsList() {
    final tips = [
      'Be specific about characters and settings',
      'Include emotions and conflicts',
      'Think about the lesson or message',
      'Add sensory details (sounds, colors, feelings)',
      'Keep the age group in mind',
    ];

    return tips.map((tip) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(color: Color(0xFF6366F1), fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
          ),
        ],
      ),
    )).toList();
  }

  List<Widget> _buildQuickIdeas() {
    final ideas = [
      'A dragon who\'s afraid of flying',
      'A robot learning to be human', 
      'Animals starting their own school',
      'A magic paintbrush adventure',
      'Time travel to help dinosaurs',
    ];

    return ideas.map((idea) => GestureDetector(
      onTap: () => _useQuickIdea(idea),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF252542),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF3D3D5C)),
        ),
        child: Text(
          idea,
          style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
      ),
    )).toList();
  }

  void _useQuickIdea(String idea) {
    setState(() {
      _promptController.text = idea;
    });
  }

  Future<Map<String, String>> _generateCharacterName(String genre) async {
    // Generate appropriate character based on genre
    final isGirl = DateTime.now().millisecond % 2 == 0; // Random gender
    
    Map<String, List<String>> namesByGenre = {
      'Fantasy': isGirl 
        ? ['Luna', 'Aria', 'Sage', 'Nova', 'Ivy', 'Ember', 'Wren', 'Skye']
        : ['Finn', 'Kai', 'Orion', 'Sage', 'River', 'Atlas', 'Nova', 'Leo'],
      'Adventure': isGirl
        ? ['Zoe', 'Maya', 'Lily', 'Emma', 'Sophie', 'Chloe', 'Mia', 'Ava'] 
        : ['Max', 'Leo', 'Sam', 'Jake', 'Ben', 'Cole', 'Drew', 'Ryan'],
      'Mystery': isGirl
        ? ['Violet', 'Ruby', 'Hazel', 'Iris', 'Pearl', 'Rose', 'Grace', 'Belle']
        : ['Oliver', 'Henry', 'Arthur', 'Felix', 'Oscar', 'Hugo', 'Theo', 'Miles'],
      'Science Fiction': isGirl
        ? ['Nova', 'Luna', 'Vera', 'Ada', 'Zara', 'Sky', 'Nora', 'Iris']
        : ['Parker', 'Quinn', 'Atlas', 'Neo', 'Zach', 'Kai', 'Ravi', 'Sage'],
    };
    
    final names = namesByGenre[genre] ?? (isGirl ? ['Luna', 'Maya', 'Zoe'] : ['Sam', 'Max', 'Leo']);
    final selectedName = names[DateTime.now().microsecond % names.length];
    
    final hairColors = ['brown', 'blonde', 'black', 'auburn'];
    final hairStyle = hairColors[DateTime.now().second % hairColors.length];
    
    final outfits = isGirl 
      ? ['purple dress and sneakers', 'pink hoodie and jeans', 'blue sweater and skirt', 'green jacket and pants']
      : ['blue hoodie and jeans', 'red t-shirt and shorts', 'green sweater and pants', 'gray jacket and khakis'];
    final selectedOutfit = outfits[DateTime.now().minute % outfits.length];
    
    return {
      'name': selectedName,
      'gender': isGirl ? 'girl' : 'boy', 
      'hair': hairStyle,
      'outfit': selectedOutfit,
    };
  }

  void _generateStory() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a story idea first!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        isGenerating = true;
      });
    }

    // Generate story using AI
    try {
      final result = await _generateAIStory();
      final List<StoryPage> aiPages = result['pages'] as List<StoryPage>;
      final String? bookId = result['bookId'] as String?;
      
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
      
      // Navigate to story preview
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryPreviewScreen(
            storyTitle: _titleController.text.isEmpty ? 'My Amazing Story' : _titleController.text,
            genre: selectedGenre,
            style: selectedStyle,
            pages: aiPages,
            bookId: bookId,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Error generating story: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _generateAIStory() async {
    final prompt = _promptController.text.isEmpty ? "A magical adventure" : _promptController.text;
    
    try {
      // Step 1: Initialize a new book session with locked character roster
      final bookSession = await aiClient.initBook(
        pitch: prompt,
        styleLabel: selectedStyle,
        genreLabel: selectedGenre,
        ageBand: selectedAgeGroup.toLowerCase(),
        allowAiNames: true,
        forceRhyme: false,
        bookSize: selectedBookFormat,
      );
      
      final bookId = bookSession['book_id'] as String;
      final storyBible = bookSession['story_bible'] as Map<String, dynamic>;
      final artBible = bookSession['art_bible'] as Map<String, dynamic>;
      final characterName = storyBible['characters'][0]['display_name'] as String;
      
      print('✅ Book session created: $bookId with character: $characterName');
      
      // Step 2: Generate all pages using the book session
      final List<StoryPage> pages = [];
      
      for (int i = 1; i <= 5; i++) {
        final pageResult = await aiClient.writePage(
          bookId: bookId,
          page: i,
          idea: prompt,
        );
        
        final page = StoryPage(
          pageNumber: i,
          text: (pageResult['lines'] as List<dynamic>).join('\n'),
          imagePrompt: pageResult['scene_hint'] ?? "Children's book illustration with $characterName",
        );
        
        pages.add(page);
      }
      
      return {'pages': pages, 'bookId': bookId};
    } catch (e) {
      print('❌ Book session generation failed: $e');
      // Fallback to old method if new system fails
      final fallbackPages = await _generateFallbackStory();
      return {'pages': fallbackPages, 'bookId': null};
    }
  }
  
  Future<List<StoryPage>> _generateFallbackStory() async {
    final prompt = _promptController.text.isEmpty ? "A magical adventure" : _promptController.text;
    
    // Generate random character name and gender  
    final characterNames = await _generateCharacterName(selectedGenre);
    
    // Create story and art bibles based on user selections
    final storyBible = {
      "characters": [
        {
          "id": "main", 
          "name": characterNames['name'], 
          "gender": characterNames['gender'],
          "description": "curious 8-year-old with ${characterNames['hair']} hair", 
          "outfit": characterNames['outfit']
        },
      ],
      "setting": "magical fantasy world",
      "theme": prompt,
      "age_group": selectedAgeGroup,
      "genre": selectedGenre,
      "anti_cliche": "NEVER start with 'Once upon a time', 'In a land far away', 'Long ago', or 'There once was'",
    };

    // This is only used for fallback - the main method uses book sessions above
    final List<StoryPage> pages = [];
    
    for (int i = 1; i <= 5; i++) {
      try {
        final aiText = await aiClient.generatePageText(
          page: i,
          idea: prompt,
          category: selectedGenre,
          storyBible: storyBible,
        );

        final page = StoryPage(
          pageNumber: i,
          text: aiText.lines.join('\n'),
          imagePrompt: aiText.sceneHint ?? "Children's book illustration with ${characterNames['name']}",
        );
        
        pages.add(page);
      } catch (e) {
        final fallbackPage = _getFallbackPage(i, prompt);
        pages.add(fallbackPage);
      }
    }
    
    return pages;
  }

  String _getSceneForPage(int pageNumber, String prompt) {
    switch (pageNumber) {
      case 1:
        return "Opening scene: $prompt begins, magical setting introduction, warm inviting atmosphere";
      case 2:
        return "Adventure starts: characters meet challenges, mystical creatures appear, enchanted environment";
      case 3:
        return "Climax moment: $prompt reaches peak, dramatic magical scene, important discovery";
      case 4:
        return "Resolution: challenges overcome, wisdom gained, triumphant scene with bright lighting";
      case 5:
        return "Happy ending: $prompt concludes, peaceful magical landscape, hope and joy";
      default:
        return "$prompt, magical scene, children's book illustration";
    }
  }

  StoryPage _getFallbackPage(int pageNumber, String prompt) {
    final fallbackTexts = [
      "Once upon a time, a wonderful adventure was about to begin. The magic of $prompt filled the air with excitement and wonder.",
      "Our story continues as new discoveries await. Every step forward brings more magical surprises and delightful encounters.",
      "The heart of our adventure reveals itself. Here, the true magic of $prompt shines brightest and most beautifully.",
      "With wisdom and courage, our journey reaches its most important moment. The power of $prompt guides us forward.",
      "And so our magical story comes to a wonderful end. The adventure of $prompt will be remembered forever and always."
    ];

    return StoryPage(
      pageNumber: pageNumber,
      text: fallbackTexts[pageNumber - 1],
      imagePrompt: "${_getSceneForPage(pageNumber, prompt)}, $selectedStyle style, detailed illustration",
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
