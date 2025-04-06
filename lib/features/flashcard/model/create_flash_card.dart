class CreateFlashcardRequest {
  String title;
  String visibility;
  String categoryId;
  List<FlashcardItemRequest> items;

  CreateFlashcardRequest({
    required this.title,
    required this.visibility,
    required this.categoryId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'visibility': visibility,
      'categoryId': categoryId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class FlashcardItemRequest {
  String term;
  String answer;

  FlashcardItemRequest({
    required this.term,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'answer': answer,
    };
  }
}
