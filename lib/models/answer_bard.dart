class AnswerBard {
  final String answer;

  AnswerBard(this.answer);

  AnswerBard.fromJson(Map<String, dynamic> json) : answer = json['answer'];

  Map<String, dynamic> toJson() {
    return {'answer': answer};
  }
}
