class AssetGroup {
  const AssetGroup({required this.id, required this.name});

  factory AssetGroup.fromJson(Map<String, dynamic> json) => AssetGroup(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  final String id;
  final String name;
}
