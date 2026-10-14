class Category {
  final int? id;
  final String nameEn;
  final String nameSi;
  final String icon;   // icon key, mapped to an IconData in the UI
  final int color;     // ARGB int

  const Category({
    this.id,
    required this.nameEn,
    required this.nameSi,
    required this.icon,
    required this.color,
  });

  factory Category.fromMap(Map<String, dynamic> m) => Category(
        id: m['id'] as int?,
        nameEn: m['name_en'] as String,
        nameSi: m['name_si'] as String,
        icon: m['icon'] as String,
        color: m['color'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name_en': nameEn,
        'name_si': nameSi,
        'icon': icon,
        'color': color,
      };
}