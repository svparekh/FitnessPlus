class ExerciseAPICaller {
  ExerciseAPICaller();

  static const String apiBaseURL = '';

  // no internet error?

  getData() {}
}

class FoodAPICaller {
  FoodAPICaller();

  static const String apiBaseURL = '';
  // no internet error?
  getData() {}
}


// We have API for exercise database
// We have API for food database

// We make our own API for metric calculations
// We use our API for workout building
// We use our API for food metric calculation



/**
 * 
 * 
 * 
 * App features:
 *  - View exercise database w/ filtering by muscle group, equipment, exerpience, body part
 *  - View individual exercises
 *  - Select one or more exercises to be added to a workout
 *  - A plan can be created for a week (default) or a month or custom (month view calander)
 *  - Each day can have one or more different workouts
 *  - The workouts act as documents
 *  - The plan now contains the workouts
 * 
 * 
 * Pages:
 *  - Zone (Workout + Tracker)
 *  - Exercise Bank
 *  - Workout Plan
 *  - Calory Tracker (WIP)
 *  - Calculators:
 *     - TDEE
 *     - BMI
 *     - BFP
 *     - Other...
 * 
 * 
 * 
 *  */ 