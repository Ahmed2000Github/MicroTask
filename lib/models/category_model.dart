class Category {
  int? numberTask;
  int? numberTaskDone;
  String? title;
  String? description;

  Category(
      {this.numberTask, this.title, this.description, this.numberTaskDone});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
