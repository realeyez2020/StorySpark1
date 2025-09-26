import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';
import '../widgets/story_card.dart';
import '../widgets/story_hero.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 1, 16, 26),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            // Category Filter (now dropdown)
            _buildCategoryDropdown(),
            // Main Content
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: StoryHero(
        bgUrl: "assets/background.jpg", // Your local background image
        title: "",
        subtitle: "Discover magical stories crafted by AI and our community. Read, purchase print copies, and create your own adventures.",
        ctaLabel: "Spark a Story",
        onCta: () {
          // Navigate to story creation
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 9),
      child: Row(
        children: [
          const Text(
            'Community Creations',
            style: TextStyle(
              color: Color.fromARGB(255, 214, 53, 12),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 24),
          // Category Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFF252542),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory,
                dropdownColor: const Color(0xFF252542),
                style: const TextStyle(color: Colors.white),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                items: [
                  'Trending 🔥',
                  'All 📚',
                  'Free 💝',
                  'Fantasy 🧙‍♀️',
                  'Adventure 🗺️',
                  'Space 🚀',
                  'Friendship 🤝',
                  'Animals 🐾',
                  'Mystery 🕵️',
                ].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category.split(' ')[0],
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue ?? 'All';
                  });
                },
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${StoryService.getFeaturedStories().length + StoryService.getCommunityStories().length} stories available',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildMainContent() {
    final freeStories = StoryService.getFreeStories();
    final featuredStories = StoryService.getFeaturedStories();
    final communityStories = StoryService.getCommunityStories();
    final filteredStories = StoryService.searchStories(
      searchQuery,
      selectedCategory == 'All' ? null : selectedCategory,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stories Row - Free Content First
          const SizedBox(height: 8),
          Container(
            height: 420,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: searchQuery.isNotEmpty
                  ? filteredStories.length
                  : (freeStories.length + featuredStories.length + communityStories.length),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final stories = searchQuery.isNotEmpty
                    ? filteredStories
                    : [...freeStories, ...featuredStories, ...communityStories];
                
                return SizedBox(
                  width: 280,
                  child: StoryCard(
                    story: stories[index],
                    onTap: () => _showStoryDetails(stories[index]),
                    onPurchase: () => _purchaseStory(stories[index]),
                  ),
                );
              },
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showStoryDetails(StoryModel story) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF252542),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'by ${story.author}',
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                story.content,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                  height: 1.6,
                ),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${story.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _purchaseStory(story),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Purchase Print Copy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _purchaseStory(StoryModel story) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchasing "${story.title}" for \$${story.price}...'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    
    // Here you would integrate with a payment processor
    // like Stripe, PayPal, etc.
  }
}
