class Quote {
  late final String quote;

  Quote.fromJson(Map<String, dynamic> json) {
    quote = json['quote'];
  }
}
