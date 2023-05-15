/// A placeholder class that represents an entity or model.
abstract class FitnessItem {
  const FitnessItem({
    required this.id,
    this.name,
    this.description,
    this.group,
    this.group2,
  });

  final int id;
  final String? name;
  final String? description;
  final String? group;
  final String? group2;
}

class FoodItem extends FitnessItem {
  const FoodItem({
    required super.id,
    super.name,
    super.description,
    super.group,
    super.group2,
  });
}

class ExerciseItem extends FitnessItem {
  const ExerciseItem({
    required super.id,
    super.name,
    super.description,
    super.group,
    super.group2,
    this.muscleGroup,
    this.bodyPart,
  });
  final String? muscleGroup;
  final String? bodyPart;
}
