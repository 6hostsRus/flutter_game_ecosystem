class Stats {
  final int str;
  final int dex;
  final int intl;
  final int vit;

  const Stats({this.str = 1, this.dex = 1, this.intl = 1, this.vit = 1});

  Stats copyWith({int? str, int? dex, int? intl, int? vit}) => Stats(
        str: str ?? this.str,
        dex: dex ?? this.dex,
        intl: intl ?? this.intl,
        vit: vit ?? this.vit,
      );

  int get hp => vit * 10;
  int get mp => intl * 8;
  int get atk => (str * 2 + dex).clamp(0, 1 << 31);
  int get critChancePermille => (dex * 5).clamp(0, 1000);

  Map<String, Object?> toJson() => {
        'str': str,
        'dex': dex,
        'intl': intl,
        'vit': vit,
      };

  static Stats fromJson(Map<String, Object?> json) => Stats(
        str: (json['str'] as num?)?.toInt() ?? 1,
        dex: (json['dex'] as num?)?.toInt() ?? 1,
        intl: (json['intl'] as num?)?.toInt() ?? 1,
        vit: (json['vit'] as num?)?.toInt() ?? 1,
      );
}
