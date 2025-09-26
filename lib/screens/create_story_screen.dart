import 'package:flutter/material.dart';
import 'story_preview_screen.dart';

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
  double aiIntervention = 0.5; // 0.0 = Less AI, 1.0 = More AI
  bool isGenerating = false;

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
              Expanded(child: _buildDropdown('Length', selectedLength, storyLengths, (value) {
                setState(() => selectedLength = value!);
              })),
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

  void _generateStory() {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a story idea first!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() {
      isGenerating = true;
    });

    // Simulate story generation
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isGenerating = false;
      });
      
      // Generate sample story pages
      final List<StoryPage> samplePages = _generateSampleStory();
      
      // Navigate to story preview
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryPreviewScreen(
            storyTitle: _titleController.text.isEmpty ? 'My Amazing Story' : _titleController.text,
            genre: selectedGenre,
            style: selectedStyle,
            pages: samplePages,
          ),
        ),
      );
    });
  }

  List<StoryPage> _generateSampleStory() {
    // Generate sample story based on user's prompt and settings
    final prompt = _promptController.text.isEmpty ? "A magical adventure" : _promptController.text;
    
    return [
      StoryPage(
        pageNumber: 1,
        text: "Once upon a time, in a land far, far away, there lived a young hero who was about to embark on the most incredible journey of their life. The sun was setting over the mystical forest, painting the sky in shades of purple and gold.",
        imagePrompt: "$prompt, $selectedStyle style, magical forest at sunset, warm golden light, mystical atmosphere, detailed illustration",
      ),
      StoryPage(
        pageNumber: 2,
        text: "As our hero stepped into the enchanted forest, strange and wonderful creatures began to appear from behind the ancient trees. Glowing butterflies danced in the air, and friendly forest spirits whispered secrets of hidden treasures.",
        imagePrompt: "$prompt, $selectedStyle style, enchanted forest creatures, glowing butterflies, forest spirits, magical lighting, whimsical scene",
      ),
      StoryPage(
        pageNumber: 3,
        text: "Deep in the heart of the forest, our hero discovered a magnificent crystal cave that sparkled with rainbow colors. Inside, a wise old dragon was waiting, ready to share ancient wisdom and grant a special gift.",
        imagePrompt: "$prompt, $selectedStyle style, crystal cave interior, rainbow crystals, wise dragon, magical glow, treasure chamber",
      ),
      StoryPage(
        pageNumber: 4,
        text: "With the dragon's blessing and a magical artifact in hand, our hero felt ready to face any challenge. As they emerged from the cave, a new world of possibilities opened up before them, filled with hope and endless adventure.",
        imagePrompt: "$prompt, $selectedStyle style, hero holding magical artifact, emerging from cave, bright sunlight, hopeful scene, adventure awaits",
      ),
      StoryPage(
        pageNumber: 5,
        text: "And so, our hero's journey continued, knowing that with courage, kindness, and a little bit of magic, any dream could come true. The end... or perhaps, just the beginning of an even greater adventure!",
        imagePrompt: "$prompt, $selectedStyle style, hero walking towards horizon, magical world landscape, bright future, inspiring ending scene",
      ),
    ];
  }

  @override
  void dispose() {
    _promptController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
