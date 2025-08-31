// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idle_dao.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIdleStateEntityCollection on Isar {
  IsarCollection<IdleStateEntity> get idleStateEntitys => this.collection();
}

const IdleStateEntitySchema = CollectionSchema(
  name: r'IdleStateEntity',
  id: 2642131161620955209,
  properties: {
    r'lastSeen': PropertySchema(
      id: 0,
      name: r'lastSeen',
      type: IsarType.dateTime,
    ),
    r'totalRatePerSec': PropertySchema(
      id: 1,
      name: r'totalRatePerSec',
      type: IsarType.double,
    )
  },
  estimateSize: _idleStateEntityEstimateSize,
  serialize: _idleStateEntitySerialize,
  deserialize: _idleStateEntityDeserialize,
  deserializeProp: _idleStateEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _idleStateEntityGetId,
  getLinks: _idleStateEntityGetLinks,
  attach: _idleStateEntityAttach,
  version: '3.1.0+1',
);

int _idleStateEntityEstimateSize(
  IdleStateEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _idleStateEntitySerialize(
  IdleStateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastSeen);
  writer.writeDouble(offsets[1], object.totalRatePerSec);
}

IdleStateEntity _idleStateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IdleStateEntity(
    lastSeen: reader.readDateTimeOrNull(offsets[0]),
    totalRatePerSec: reader.readDoubleOrNull(offsets[1]) ?? 0,
  );
  object.id = id;
  return object;
}

P _idleStateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _idleStateEntityGetId(IdleStateEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _idleStateEntityGetLinks(IdleStateEntity object) {
  return [];
}

void _idleStateEntityAttach(
    IsarCollection<dynamic> col, Id id, IdleStateEntity object) {
  object.id = id;
}

extension IdleStateEntityQueryWhereSort
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QWhere> {
  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IdleStateEntityQueryWhere
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QWhereClause> {
  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterWhereClause> idBetween(
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

extension IdleStateEntityQueryFilter
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QFilterCondition> {
  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      lastSeenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSeen',
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      lastSeenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSeen',
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      lastSeenEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      lastSeenGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      lastSeenLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      lastSeenBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      totalRatePerSecEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      totalRatePerSecGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      totalRatePerSecLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterFilterCondition>
      totalRatePerSecBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRatePerSec',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension IdleStateEntityQueryObject
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QFilterCondition> {}

extension IdleStateEntityQueryLinks
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QFilterCondition> {}

extension IdleStateEntityQuerySortBy
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QSortBy> {
  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      sortByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      sortByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      sortByTotalRatePerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRatePerSec', Sort.asc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      sortByTotalRatePerSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRatePerSec', Sort.desc);
    });
  }
}

extension IdleStateEntityQuerySortThenBy
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QSortThenBy> {
  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      thenByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      thenByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      thenByTotalRatePerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRatePerSec', Sort.asc);
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QAfterSortBy>
      thenByTotalRatePerSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRatePerSec', Sort.desc);
    });
  }
}

extension IdleStateEntityQueryWhereDistinct
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QDistinct> {
  QueryBuilder<IdleStateEntity, IdleStateEntity, QDistinct>
      distinctByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeen');
    });
  }

  QueryBuilder<IdleStateEntity, IdleStateEntity, QDistinct>
      distinctByTotalRatePerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRatePerSec');
    });
  }
}

extension IdleStateEntityQueryProperty
    on QueryBuilder<IdleStateEntity, IdleStateEntity, QQueryProperty> {
  QueryBuilder<IdleStateEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IdleStateEntity, DateTime?, QQueryOperations>
      lastSeenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeen');
    });
  }

  QueryBuilder<IdleStateEntity, double, QQueryOperations>
      totalRatePerSecProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRatePerSec');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GeneratorEntitySchema = Schema(
  name: r'GeneratorEntity',
  id: 4565007918275503832,
  properties: {
    r'baseRatePerSec': PropertySchema(
      id: 0,
      name: r'baseRatePerSec',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'level': PropertySchema(
      id: 2,
      name: r'level',
      type: IsarType.long,
    ),
    r'multiplier': PropertySchema(
      id: 3,
      name: r'multiplier',
      type: IsarType.double,
    ),
    r'unlocked': PropertySchema(
      id: 4,
      name: r'unlocked',
      type: IsarType.bool,
    )
  },
  estimateSize: _generatorEntityEstimateSize,
  serialize: _generatorEntitySerialize,
  deserialize: _generatorEntityDeserialize,
  deserializeProp: _generatorEntityDeserializeProp,
);

int _generatorEntityEstimateSize(
  GeneratorEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _generatorEntitySerialize(
  GeneratorEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.baseRatePerSec);
  writer.writeString(offsets[1], object.id);
  writer.writeLong(offsets[2], object.level);
  writer.writeDouble(offsets[3], object.multiplier);
  writer.writeBool(offsets[4], object.unlocked);
}

GeneratorEntity _generatorEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GeneratorEntity(
    baseRatePerSec: reader.readDoubleOrNull(offsets[0]) ?? 0,
    id: reader.readStringOrNull(offsets[1]) ?? '',
    level: reader.readLongOrNull(offsets[2]) ?? 0,
    multiplier: reader.readDoubleOrNull(offsets[3]) ?? 1,
    unlocked: reader.readBoolOrNull(offsets[4]) ?? false,
  );
  return object;
}

P _generatorEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 1) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GeneratorEntityQueryFilter
    on QueryBuilder<GeneratorEntity, GeneratorEntity, QFilterCondition> {
  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      baseRatePerSecEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      baseRatePerSecGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      baseRatePerSecLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      baseRatePerSecBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseRatePerSec',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      levelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      multiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      multiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      multiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      multiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'multiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GeneratorEntity, GeneratorEntity, QAfterFilterCondition>
      unlockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlocked',
        value: value,
      ));
    });
  }
}

extension GeneratorEntityQueryObject
    on QueryBuilder<GeneratorEntity, GeneratorEntity, QFilterCondition> {}
