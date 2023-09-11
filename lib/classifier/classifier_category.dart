class ClassifierCategory {
  final String label;
  final double score;

  ClassifierCategory(this.label, this.score);

  @override
  String toString() {
    return 'Category{label: $label, score: $score}';
  }
}
