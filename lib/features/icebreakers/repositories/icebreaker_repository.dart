import '../models/icebreaker.dart';

class IcebreakerRepository {
  // This will be replaced with Firebase later
  Future<List<Icebreaker>> getIcebreakers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data - will be replaced with Firebase query
    return [
      Icebreaker(
        id: '1',
        question: 'What\'s one thing you\'re passionate about that most people don\'t know?',
        category: 'Personal',
        difficulty: 2,
        isPersonal: true,
        tags: ['passion', 'interests'],
      ),
      Icebreaker(
        id: '2',
        question: 'If you could travel anywhere tomorrow, where would you go?',
        category: 'Travel',
        difficulty: 1,
        isPersonal: false,
        tags: ['travel', 'adventure'],
      ),
      Icebreaker(
        id: '3',
        question: 'What\'s your favorite way to spend a weekend?',
        category: 'Lifestyle',
        difficulty: 1,
        isPersonal: false,
        tags: ['lifestyle', 'hobbies'],
      ),
      Icebreaker(
        id: '4',
        question: 'What was the last book or show that made you laugh out loud?',
        category: 'Entertainment',
        difficulty: 1,
        isPersonal: false,
        tags: ['entertainment', 'humor'],
      ),
      Icebreaker(
        id: '5',
        question: 'If you could have dinner with anyone, living or dead, who would it be?',
        category: 'Hypothetical',
        difficulty: 2,
        isPersonal: false,
        tags: ['hypothetical', 'dinner'],
      ),
    ];
  }

  Future<Map<String, List<IcebreakerAnswer>>> getUserAnswers({String? userId}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - will be replaced with Firebase query
    final currentUserId = userId ?? 'current_user';
    
    return {
      '1': [
        IcebreakerAnswer(
          id: 'a1',
          icebreakerID: '1',
          userId: currentUserId,
          answer: 'I\'m secretly passionate about astronomy and spend nights stargazing whenever I can.',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
      '3': [
        IcebreakerAnswer(
          id: 'a2',
          icebreakerID: '3',
          userId: currentUserId,
          answer: 'My perfect weekend involves hiking in the morning and trying a new restaurant in the evening.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    };
  }

  Future<void> saveAnswer(String icebreakerID, String answer, {String? userId, bool isPublic = true}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // This is where you'd save to Firebase
    final currentUserId = userId ?? 'current_user';
    
    final newAnswer = IcebreakerAnswer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      icebreakerID: icebreakerID,
      userId: currentUserId,
      answer: answer,
      createdAt: DateTime.now(),
      isPublic: isPublic,
    );
    
    // In a real implementation, you would save this to Firebase
    print('Saved answer: ${newAnswer.toMap()}');
  }

  Future<List<IcebreakerAnswer>> getMatchAnswers(String matchId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - will be replaced with Firebase query
    return [
      IcebreakerAnswer(
        id: 'ma1',
        icebreakerID: '2',
        userId: matchId,
        answer: 'I would go to Japan to see the cherry blossoms and experience the culture.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      IcebreakerAnswer(
        id: 'ma2',
        icebreakerID: '4',
        userId: matchId,
        answer: 'The last show that made me laugh was "Ted Lasso" - it\'s so wholesome and funny!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<Icebreaker?> getSuggestedIcebreaker(String matchId) async {
    // This would use an algorithm to suggest an icebreaker based on:
    // 1. Questions the match has already answered
    // 2. Questions the user hasn't asked yet
    // 3. Common interests between the user and match
    
    // For now, just return a random icebreaker
    final icebreakers = await getIcebreakers();
    icebreakers.shuffle();
    return icebreakers.isNotEmpty ? icebreakers.first : null;
  }
}
