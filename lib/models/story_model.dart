class StoryModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String author;
  final String category;
  final String imageUrl;
  final double rating;
  final int views;
  final double price;
  final bool isPurchased;
  final DateTime createdAt;
  final List<String> tags;

  StoryModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.author,
    required this.category,
    required this.imageUrl,
    this.rating = 0.0,
    this.views = 0,
    this.price = 9.99,
    this.isPurchased = false,
    required this.createdAt,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'author': author,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'views': views,
      'price': price,
      'isPurchased': isPurchased,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
    };
  }

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      author: json['author'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble() ?? 0.0,
      views: json['views'] ?? 0,
      price: json['price']?.toDouble() ?? 9.99,
      isPurchased: json['isPurchased'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class StoryCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  StoryCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Sample story categories
final storyCategories = [
  StoryCategory(id: 'trending', name: 'Trending', icon: '🔥', color: '#FF6B6B'),
  StoryCategory(id: 'adventure', name: 'Adventure', icon: '🗺️', color: '#4ECDC4'),
  StoryCategory(id: 'fantasy', name: 'Fantasy', icon: '🧙‍♀️', color: '#A8E6CF'),
  StoryCategory(id: 'mystery', name: 'Mystery', icon: '🕵️', color: '#FFD93D'),
  StoryCategory(id: 'friendship', name: 'Friendship', icon: '🤝', color: '#6BCF7F'),
  StoryCategory(id: 'animals', name: 'Animals', icon: '🐾', color: '#FF8A80'),
  StoryCategory(id: 'space', name: 'Space', icon: '🚀', color: '#B19CD9'),
  StoryCategory(id: 'fairy-tale', name: 'Fairy Tale', icon: '🏰', color: '#FFB74D'),
];
