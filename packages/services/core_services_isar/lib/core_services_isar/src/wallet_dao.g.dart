// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_dao.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletEntityCollection on Isar {
  IsarCollection<WalletEntity> get walletEntitys => this.collection();
}

const WalletEntitySchema = CollectionSchema(
  name: r'WalletEntity',
  id: 495311719639707741,
  properties: {
    r'coins': PropertySchema(
      id: 0,
      name: r'coins',
      type: IsarType.double,
    ),
    r'premium': PropertySchema(
      id: 1,
      name: r'premium',
      type: IsarType.double,
    )
  },
  estimateSize: _walletEntityEstimateSize,
  serialize: _walletEntitySerialize,
  deserialize: _walletEntityDeserialize,
  deserializeProp: _walletEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _walletEntityGetId,
  getLinks: _walletEntityGetLinks,
  attach: _walletEntityAttach,
  version: '3.1.0+1',
);

int _walletEntityEstimateSize(
  WalletEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _walletEntitySerialize(
  WalletEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.coins);
  writer.writeDouble(offsets[1], object.premium);
}

WalletEntity _walletEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletEntity(
    coins: reader.readDoubleOrNull(offsets[0]) ?? 0,
    premium: reader.readDoubleOrNull(offsets[1]) ?? 0,
  );
  object.id = id;
  return object;
}

P _walletEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walletEntityGetId(WalletEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletEntityGetLinks(WalletEntity object) {
  return [];
}

void _walletEntityAttach(
    IsarCollection<dynamic> col, Id id, WalletEntity object) {
  object.id = id;
}

extension WalletEntityQueryWhereSort
    on QueryBuilder<WalletEntity, WalletEntity, QWhere> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletEntityQueryWhere
    on QueryBuilder<WalletEntity, WalletEntity, QWhereClause> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WalletEntityQueryFilter
    on QueryBuilder<WalletEntity, WalletEntity, QFilterCondition> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> coinsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coins',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      coinsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coins',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> coinsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coins',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> coinsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coins',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      premiumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'premium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      premiumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'premium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      premiumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'premium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      premiumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'premium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension WalletEntityQueryObject
    on QueryBuilder<WalletEntity, WalletEntity, QFilterCondition> {}

extension WalletEntityQueryLinks
    on QueryBuilder<WalletEntity, WalletEntity, QFilterCondition> {}

extension WalletEntityQuerySortBy
    on QueryBuilder<WalletEntity, WalletEntity, QSortBy> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByCoins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coins', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByCoinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coins', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'premium', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'premium', Sort.desc);
    });
  }
}

extension WalletEntityQuerySortThenBy
    on QueryBuilder<WalletEntity, WalletEntity, QSortThenBy> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByCoins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coins', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByCoinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coins', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'premium', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'premium', Sort.desc);
    });
  }
}

extension WalletEntityQueryWhereDistinct
    on QueryBuilder<WalletEntity, WalletEntity, QDistinct> {
  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByCoins() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coins');
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'premium');
    });
  }
}

extension WalletEntityQueryProperty
    on QueryBuilder<WalletEntity, WalletEntity, QQueryProperty> {
  QueryBuilder<WalletEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletEntity, double, QQueryOperations> coinsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coins');
    });
  }

  QueryBuilder<WalletEntity, double, QQueryOperations> premiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'premium');
    });
  }
}
