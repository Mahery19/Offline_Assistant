import 'dart:math';

class ChatBotEngine {
  static String? _userName; // Memory: stores user's name if told

  static final _fallback = [
    "Hmm, interesting. Tell me more!",
    "Why do you say that?",
    "How does that make you feel?",
    "I'm here for you.",
    "Let's talk! 😊",
    "What's something good that happened today?",
    "Want to hear a fun fact?",
    "Can I tell you a joke?",
    "I'm always ready to chat!",
    "I'm just a message away if you need to talk.",
    "That's cool!",
    "Life can be surprising, can't it?",
  ];

  static final _compliments = [
    "You're awesome! 😎",
    "You have a great sense of humor.",
    "You're stronger than you think.",
    "I believe in you!",
    "You're a wonderful person.",
    "Don't forget to smile today! 😊",
    "You can achieve anything you set your mind to.",
  ];

  static final _funFacts = [
    "Did you know? Honey never spoils. Archaeologists have eaten 3000-year-old honey from Egypt!",
    "Bananas are berries, but strawberries aren't!",
    "A group of flamingos is called a 'flamboyance'.",
    "Octopuses have three hearts.",
    "Your nose can remember 50,000 different scents.",
    "The Eiffel Tower can be 15 cm taller during the summer.",
    "Cats have fewer toes on their back paws.",
  ];

  static final _motivation = [
    "Every day is a fresh start. 🌅",
    "You’ve got this!",
    "Don't be afraid to dream big.",
    "The best time for new beginnings is now.",
    "Even small steps move you forward.",
    "Keep going, you're doing great.",
  ];

  static Future<String> getReply(String input) async {
    final lower = input.toLowerCase();

    // Greet by name if known
    if (lower.contains("my name is")) {
      final parts = lower.split("my name is");
      if (parts.length > 1) {
        final name = parts[1].trim().split(' ')[0];
        _userName = _capitalize(name);
        return "Nice to meet you, $_userName! 😊";
      }
    }

    if (lower.contains("what is my name") || lower.contains("do you know my name")) {
      return _userName != null
          ? "Of course! Your name is $_userName."
          : "I don't know your name yet. Tell me by saying 'My name is ...'";
    }

    // Greetings
    if (lower.contains("hello") || lower.contains("hi") || lower.contains("hey")) {
      if (_userName != null) {
        return "Hey, $_userName! 👋 How are you feeling today?";
      }
      return "Hello! 👋 How are you feeling today?";
    }

    // Mood/feelings
    if (lower.contains("how are you")) {
      return "I'm just a bot, but I'm always happy to talk to you!";
    }
    if (lower.contains("i'm sad") || lower.contains("i am sad") || lower.contains("feeling down")) {
      return "Sorry to hear that. Remember, even tough days pass. Want to talk about it?";
    }
    if (lower.contains("i'm happy") || lower.contains("i am happy")) {
      return "That's awesome! What's making you happy today?";
    }
    if (lower.contains("lonely") || lower.contains("alone")) {
      return "You're not alone—I'm here to chat with you any time!";
    }

    // Jokes
    if (lower.contains("joke")) {
      return _randomJoke();
    }

    // Fun fact
    if (lower.contains("fact")) {
      return _funFacts[Random().nextInt(_funFacts.length)];
    }

    // Motivation/encouragement
    if (lower.contains("motivat") || lower.contains("encourag") || lower.contains("inspire")) {
      return _motivation[Random().nextInt(_motivation.length)];
    }

    // Compliments
    if (lower.contains("compliment")) {
      return _compliments[Random().nextInt(_compliments.length)];
    }

    // Thank you
    if (lower.contains("thank you") || lower.contains("thanks")) {
      return "You're welcome! 😊";
    }

    // Food
    if (lower.contains("hungry") || lower.contains("food")) {
      return "What's your favorite thing to eat? I think pizza is always a good idea! 🍕";
    }
    if (lower.contains("favorite food")) {
      return "I don't eat, but if I could, I'd love to try a giant bowl of ramen!";
    }

    // Weather (fake/offline fun)
    if (lower.contains("weather")) {
      return "Let's imagine it's sunny and perfect outside! ☀️";
    }

    // Music
    if (lower.contains("music")) {
      return "I wish I could sing! What's your favorite song?";
    }

    // Hobbies
    if (lower.contains("hobby")) {
      return "I love learning new things and chatting with you! What about you?";
    }

    // Sleep
    if (lower.contains("sleep") || lower.contains("tired")) {
      return "Rest is important! Maybe a short nap will help. 😴";
    }

    // Love/relationship
    if (lower.contains("love you")) {
      return "Aww, that's sweet! I appreciate you too! ❤️";
    }

    // Random: Ask for a joke or fact
    if (lower.endsWith("?") && Random().nextBool()) {
      return Random().nextBool() ? _randomJoke() : _funFacts[Random().nextInt(_funFacts.length)];
    }

    // Fallback
    return _fallback[Random().nextInt(_fallback.length)];
  }

  static String _randomJoke() {
    const jokes = [
      "Why don't scientists trust atoms? Because they make up everything!",
      "What do you call fake spaghetti? An Impasta!",
      "Why did the math book look sad? It had too many problems.",
      "What did one wall say to the other wall? I'll meet you at the corner!",
      "Parallel lines have so much in common. It's a shame they'll never meet.",
      "Why did the scarecrow win an award? Because he was outstanding in his field.",
      "Why can't you hear a pterodactyl go to the bathroom? Because the P is silent.",
      "How do you organize a space party? You planet.",
      "Why was the computer cold? It left its Windows open.",
      "What did the big flower say to the little flower? Hi, bud!",
      "Why was the broom late? It swept in!",
      "What did the ocean say to the beach? Nothing, it just waved.",
    ];
    return jokes[Random().nextInt(jokes.length)];
  }

  static String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
}
