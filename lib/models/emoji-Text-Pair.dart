class EmojiTextPair {
  String _emoji;
  String _text;

  // Constructor to initialize values
  EmojiTextPair({required String emoji, required String text})
      : _emoji = emoji,
        _text = text;

  // Getter for emoji
  String get emoji => _emoji;

  // Setter for emoji
  set emoji(String newEmoji) {
    _emoji = newEmoji;
  }

  // Getter for text
  String get text => _text;

  // Setter for text
  set text(String newText) {
    _text = newText;
  }
}
