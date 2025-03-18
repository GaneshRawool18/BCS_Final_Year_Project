class ShowModelClass {
  String id; // Unique ID for Firebase
  String title;
  String description;
  String date;

  ShowModelClass({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  // Method to create a copy with new values
  ShowModelClass copyWith({String? id, String? title, String? description, String? date}) {
    return ShowModelClass(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
