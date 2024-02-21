class ClassifierCategory {
  late String label;
  late double score;

  ClassifierCategory({required this.label, required this.score});

  getLabel() {
    return label;
  }
}
