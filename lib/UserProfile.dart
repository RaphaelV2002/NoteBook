class UserProfile {
  final String uid; // Уникальный идентификатор пользователя
  final String displayName; // Имя пользователя
  final String email; // Адрес электронной почты
  final String avatarUrl; // URL аватара пользователя

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.avatarUrl,
  });
}
