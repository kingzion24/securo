double _toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

class GroupMember {
  const GroupMember({
    required this.id,
    required this.groupId,
    required this.name,
    this.email,
    this.isSelf = false,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
        id: json['id'] as String,
        groupId: json['group_id'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        isSelf: json['is_self'] as bool? ?? false,
      );

  final String id;
  final String groupId;
  final String name;
  final String? email;
  final bool isSelf;
}

class GroupBalanceLine {
  const GroupBalanceLine({
    required this.memberId,
    required this.currency,
    required this.amountInDefaultCurrency,
  });

  factory GroupBalanceLine.fromJson(Map<String, dynamic> json) => GroupBalanceLine(
        memberId: json['member_id'] as String,
        currency: json['currency'] as String,
        amountInDefaultCurrency: _toDouble(json['amount_in_default_currency']),
      );

  final String memberId;
  final String currency;

  /// Positive = this member owes the group owner. Negative = owner owes them.
  final double amountInDefaultCurrency;
}

class GroupBalances {
  const GroupBalances({required this.defaultCurrency, required this.lines});

  factory GroupBalances.fromJson(Map<String, dynamic> json) => GroupBalances(
        defaultCurrency: json['default_currency'] as String,
        lines: (json['lines'] as List<dynamic>)
            .map((e) => GroupBalanceLine.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String defaultCurrency;
  final List<GroupBalanceLine> lines;
}
