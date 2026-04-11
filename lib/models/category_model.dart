class CategoryModel {
  final String id;
  final String name;
  final String colorHex;
  final String icon;
  final String userId;

  CategoryModel({
    required this.id,
    required this.name,
    this.colorHex = '#FF5A5F',
    this.icon = 'label',
    required this.userId,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      colorHex: map['colorHex'] ?? '#FF5A5F',
      icon: map['icon'] ?? 'label',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'icon': icon,
      'userId': userId,
    };
  }

  static List<CategoryModel> get defaults => [
    CategoryModel(id: 'work', name: 'Work', colorHex: '#4299E1', icon: 'work', userId: ''),
    CategoryModel(id: 'personal', name: 'Personal', colorHex: '#9F7AEA', icon: 'person', userId: ''),
    CategoryModel(id: 'health', name: 'Health', colorHex: '#48BB78', icon: 'favorite', userId: ''),
    CategoryModel(id: 'learning', name: 'Learning', colorHex: '#ED8936', icon: 'school', userId: ''),
    CategoryModel(id: 'finance', name: 'Finance', colorHex: '#38B2AC', icon: 'account_balance', userId: ''),
  ];
}
