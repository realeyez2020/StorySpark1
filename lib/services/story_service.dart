import '../models/story_model.dart';

class StoryService {
  // Sample featured stories
  static List<StoryModel> getFreeStories() {
    return [
      StoryModel(
        id: 'free1',
        title: 'The Friendly Robot Helper',
        summary: 'A cute robot learns to help children with their daily tasks and homework.',
        content: '''BEEP! BEEP! That was the sound Helper-Bot made every morning when he woke up, ready to help everyone in the neighborhood.

Helper-Bot was a small, round robot with big blue eyes and extending arms that could reach high shelves and carry heavy books. His favorite thing was helping children with their homework and chores.

One day, little Mia was struggling with her math homework. Helper-Bot rolled over with his screen displaying fun number games that made learning addition and subtraction as easy as playing.

When Tommy couldn't reach his favorite book on the top shelf, Helper-Bot extended his telescoping arm and gently handed it down with a cheerful "BEEP! Happy to help!"

By the end of the day, Helper-Bot had helped organize toy rooms, explained science projects, and even helped bake cookies with careful measurements. All the children learned that asking for help was wonderful, and helping others felt even better.''',
        author: 'StorySpark Team',
        category: 'Free',
        imageUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400',
        rating: 4.9,
        views: 3200,
        price: 0.00,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['robots', 'helping', 'friendship', 'free'],
      ),
      StoryModel(
        id: 'free2',
        title: 'The Magic Paintbrush',
        summary: 'A young artist discovers a paintbrush that brings drawings to life.',
        content: '''Lily loved to paint, but she always felt like something was missing from her artwork. One day, while cleaning her grandmother's attic, she found an old paintbrush that shimmered with rainbow colors.

When Lily dipped the brush in regular paint and made a stroke on paper, something incredible happened - a tiny blue bird flew right off the page!

Excited by this discovery, Lily painted flowers that bloomed with real petals, butterflies that danced around her room, and a small puppy that wagged its tail and licked her face with a pink tongue.

But Lily soon learned that with great power comes great responsibility. When she painted a thundercloud during a moment of frustration, real rain started falling in her bedroom!

With the help of her magical paintbrush, Lily learned to paint with intention and kindness, creating beautiful living artworks that brought joy to everyone who saw them.''',
        author: 'StorySpark Team',
        category: 'Free',
        imageUrl: 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400',
        rating: 4.7,
        views: 2800,
        price: 0.00,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        tags: ['art', 'magic', 'creativity', 'free'],
      ),
    ];
  }

  static List<StoryModel> getFeaturedStories() {
    return [
      StoryModel(
        id: '1',
        title: 'The Magic Library',
        summary: 'Emma discovers a library where books come to life and adventures await.',
        content: '''Once upon a time, in a small town lived a curious girl named Emma who loved to read. One rainy afternoon, she discovered an old library she had never seen before...

The moment Emma opened the first book, something magical happened. The characters began to move on the pages, and before she knew it, she was pulled into their world of adventure.

She found herself in a enchanted forest where talking animals needed her help to save their kingdom from an evil wizard who had stolen all the colors from their world.

With courage and kindness, Emma helped the animals gather magical crystals that restored color and joy to their land. When she returned to the library, she realized that every book held a new adventure waiting for her.

From that day on, Emma visited the magic library every week, knowing that incredible journeys were just a page turn away.''',
        author: 'Sarah Kim',
        category: 'Fantasy',
        imageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
        rating: 4.8,
        views: 1240,
        price: 12.99,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['magic', 'books', 'adventure'],
      ),
      StoryModel(
        id: '2',
        title: 'Captain Luna\'s Space Adventure',
        summary: 'A brave young captain explores distant planets and makes alien friends.',
        content: '''Captain Luna adjusted her shiny helmet and looked out at the stars from her spaceship. Today was going to be her biggest adventure yet!

Her mission was to explore the colorful planet Zephyr, where it was said that crystal flowers grew that could sing the most beautiful songs in the universe.

When Luna landed on Zephyr, she met Zippy, a friendly alien who looked like a purple jellyfish with sparkly tentacles. Zippy was sad because the singing flowers had stopped singing.

Together, Luna and Zippy discovered that the flowers needed moonlight from Luna's home planet to sing. Using her special space mirror, Luna reflected moonbeams onto the crystal flowers.

The flowers began to sing the most amazing melodies, and all the aliens on Zephyr celebrated. Luna had made a new friend and saved the musical flowers of an entire planet!''',
        author: 'Alex Rivera',
        category: 'Space',
        imageUrl: 'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400',
        rating: 4.9,
        views: 2100,
        price: 11.99,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['space', 'aliens', 'friendship'],
      ),
      StoryModel(
        id: '3',
        title: 'The Secret of Whispering Woods',
        summary: 'Two friends discover a mysterious secret hidden in the ancient forest.',
        content: '''Maya and Jake had been best friends since they could walk, and they loved exploring the woods behind their neighborhood. But there was one part of the forest they had never visited - the Whispering Woods.

Legend said that the trees in this part of the forest could whisper secrets to those brave enough to listen. One sunny Saturday, the two friends decided it was time to discover the truth.

As they entered the Whispering Woods, they noticed something magical. The leaves seemed to shimmer with a golden light, and they could hear soft whispers carried by the wind.

Following the whispers, they found a clearing where an ancient oak tree stood. The tree spoke to them, revealing that it was the guardian of all the forest animals and needed their help.

The old tree explained that a magical spring that gave life to the forest was drying up. Maya and Jake worked together to clear the blocked spring, and as the water flowed freely again, the entire forest came alive with grateful animals and singing birds.

The Whispering Woods had shared its greatest secret - that friendship and kindness could heal even the oldest magic.''',
        author: 'Emma Thompson',
        category: 'Adventure',
        imageUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400',
        rating: 4.7,
        views: 890,
        price: 10.99,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['forest', 'friendship', 'magic'],
      ),
      StoryModel(
        id: '4',
        title: 'The Little Dragon Who Couldn\'t Fly',
        summary: 'A determined little dragon learns that being different makes you special.',
        content: '''In the mountains of Dragonia lived a little dragon named Ember who had a big problem - he couldn't fly like the other dragons. While his brothers and sisters soared through the clouds, Ember could only hop and glide short distances.

The other dragons didn't mean to be unkind, but Ember felt left out when they played flying games high in the sky. He spent most of his time alone, practicing his hopping and wishing his wings were stronger.

One day, a terrible storm hit Dragonia. The flying dragons were all caught in the strong winds and couldn't navigate safely. But Ember, who had learned to be an expert at hopping from rock to rock, could travel safely along the mountain paths.

He hopped from cave to cave, leading lost hikers to safety and helping other creatures find shelter from the storm. By the time the storm ended, everyone realized that Ember's unique way of moving had made him the hero of Dragonia.

From that day on, Ember was proud of his hopping skills, and he taught other dragons that being different wasn't something to hide - it was something that made you special and valuable in your own wonderful way.''',
        author: 'Marcus Chen',
        category: 'Friendship',
        imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        rating: 4.6,
        views: 1560,
        price: 11.99,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['dragons', 'self-acceptance', 'courage'],
      ),
    ];
  }

  static List<StoryModel> getCommunityStories() {
    return [
      StoryModel(
        id: '5',
        title: 'The Robot Who Learned to Laugh',
        summary: 'A serious robot discovers the joy of humor and friendship.',
        content: '''In the year 3025, there lived a very serious robot named ALEX-7 who was designed to do important work in the city. ALEX-7 was very good at his job, but he didn't understand why humans laughed and told jokes.

One day, ALEX-7 met a little girl named Zoe who was always giggling and telling funny stories. She tried to tell ALEX-7 a joke, but he just computed it logically and said, "That statement is factually incorrect."

Zoe didn't give up. Every day, she would find ALEX-7 and share new jokes, funny stories, and silly games. Slowly, ALEX-7 started to understand that jokes weren't about being correct - they were about having fun and connecting with others.

The first time ALEX-7 laughed, his circuits lit up with colors he had never seen before. It felt wonderful! He realized that humor was not a malfunction - it was a feature that made life more enjoyable.

Soon, ALEX-7 became known as the funniest robot in the city, telling jokes and making everyone smile. He learned that sometimes the most important job of all is simply making others happy.''',
        author: 'Community User: TechTales',
        category: 'Friendship',
        imageUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400',
        rating: 4.4,
        views: 756,
        price: 8.99,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['robots', 'humor', 'technology'],
      ),
      StoryModel(
        id: '6',
        title: 'The Magical Art Contest',
        summary: 'Young artists compete in a contest where their drawings come to life.',
        content: '''Every year, the town of Colorville held a magical art contest where children could showcase their creativity. This year was special because the winner's artwork would be displayed in the enchanted museum, where paintings came to life.

Ten-year-old Mia loved to draw, but she was nervous about the contest. Her drawings were different from everyone else's - instead of perfect flowers or realistic animals, she drew imaginative creatures and rainbow landscapes.

On the day of the contest, children from all over town brought their best artwork. There were beautiful portraits, stunning landscapes, and detailed drawings of cars and houses. When it was Mia's turn, she hesitantly showed her drawing of a friendly dragon playing with unicorns in a field of singing flowers.

The judges looked at all the artwork carefully. While many pieces were technically perfect, they were drawn to Mia's imaginative world. When they announced her as the winner, something magical happened - her drawing began to shimmer and glow.

As Mia's artwork was placed in the enchanted museum, the dragon and unicorns came to life, dancing and playing just as she had imagined. The judges explained that the magic responded not to perfection, but to pure imagination and joy.

Mia learned that her unique way of seeing the world was not something to hide, but something to celebrate and share with others.''',
        author: 'Community User: ArtisticDreams',
        category: 'Fantasy',
        imageUrl: 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400',
        rating: 4.5,
        views: 632,
        price: 9.99,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        tags: ['art', 'creativity', 'magic'],
      ),
    ];
  }

  static List<StoryModel> searchStories(String query, String? category) {
    final allStories = [...getFeaturedStories(), ...getCommunityStories()];
    
    return allStories.where((story) {
      final matchesQuery = query.isEmpty || 
          story.title.toLowerCase().contains(query.toLowerCase()) ||
          story.summary.toLowerCase().contains(query.toLowerCase()) ||
          story.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
          
      final matchesCategory = category == null || 
          category.isEmpty || 
          category == 'All' ||
          story.category.toLowerCase() == category.toLowerCase();
          
      return matchesQuery && matchesCategory;
    }).toList();
  }
}
