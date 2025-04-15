class UserInFilter {
  final int id;
  final String name;
  final String lastName;
  final String username;
  final String? imageUrl;

  UserInFilter({
    required this.id,
    required this.name,
    required this.lastName,
    required this.username,
    this.imageUrl,
  });

  // Método para convertir un JSON en una instancia de UserInFilter
  factory UserInFilter.fromJson(Map<String, dynamic> json) {
    return UserInFilter(
        id: json['id'],
        name: json['name'],
        lastName: json['lastName'],
        username: json['username'],
        imageUrl: json['image_url']);
  }

  // Método para convertir una instancia de UserInFilter a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'username': username,
    };
  }
}
