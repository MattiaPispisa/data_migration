import 'dart:convert';

import 'package:data_migration/data_migration.dart';
import 'package:test/test.dart';

void main() {
  group('DataMigration', () {
    late DataMigrationManager manager;

    test('can be instantiated', () {
      manager = const DataMigrationManager([]);
    });

    test('should apply migration', () async {
      manager = const DataMigrationManager([
        CounterV1DataMigration(),
        CounterV2DataMigration(),
        CounterV3DataMigration(),
      ]);

      const count = 3;
      final migratedData = await manager.migrateIfNeeded(count, fromVersion: 1);
      // apply 1 --> 2, 2 --> 3, 3 --> 4
      final decodedMigratedData = jsonDecode(migratedData as String);
      expect(
        decodedMigratedData,
        isA<Map<String, dynamic>>().having(
          (data) => data['counters'],
          'counters',
          [3],
        ),
      );
    });

    test('should apply migration from v2', () async {
      manager = const DataMigrationManager([
        CounterV1DataMigration(),
        CounterV2DataMigration(),
        CounterV3DataMigration(),
      ]);

      const count = 3;
      final migratedData = await manager
          .migrateIfNeeded(jsonEncode({'count': count}), fromVersion: 2);
      // does not apply 1 --> 2 migration
      final decodedMigratedData = jsonDecode(migratedData as String);
      expect(
        decodedMigratedData,
        isA<Map<String, dynamic>>().having(
          (data) => data['counters'],
          'counters',
          [3],
        ),
      );
    });

    test('should throw exception on migration fail', () async {
      manager = const DataMigrationManager([
        CounterV1DataMigration(),
        BadCounterDataMigration(),
        CounterV3DataMigration(),
      ]);

      await expectLater(
        () => manager.migrateIfNeeded(3, fromVersion: 1),
        throwsA(
          isA<DataMigrationException>().having(
            (exception) => exception.toString().contains('DataMigration: '),
            'toString',
            true,
          ),
        ),
      );
    });
  });
}

class CounterV1DataMigration implements DataMigration {
  const CounterV1DataMigration();

  @override
  int get fromVersion => 1;

  @override
  int get toVersion => 2;

  @override
  Future<dynamic> migrate(dynamic data) async {
    // convert to object
    return jsonEncode({'count': data as int});
  }
}

class CounterV2DataMigration implements DataMigration {
  const CounterV2DataMigration();

  @override
  int get fromVersion => 2;

  @override
  int get toVersion => 3;

  @override
  Future<dynamic> migrate(dynamic data) async {
    final decodedData = jsonDecode(data as String) as Map<String, dynamic>;
    final count = decodedData['count'] as int;

    // change key
    return jsonEncode({'enhancedCount': count});
  }
}

class CounterV3DataMigration implements DataMigration {
  const CounterV3DataMigration();

  @override
  int get fromVersion => 3;

  @override
  int get toVersion => 4;

  @override
  Future<dynamic> migrate(dynamic data) async {
    final decodedData = jsonDecode(data as String) as Map<String, dynamic>;
    final count = decodedData['enhancedCount'] as int;

    // move to array
    return jsonEncode({
      'counters': [count],
    });
  }
}

class BadCounterDataMigration implements DataMigration {
  const BadCounterDataMigration();

  @override
  int get fromVersion => 2;

  @override
  int get toVersion => 3;

  @override
  Future<dynamic> migrate(dynamic data) async {
    final decodedData = jsonDecode(data as String) as Map<String, dynamic>;
    // wrong assertion
    final count = decodedData['count'] as String;

    // change key
    return jsonEncode({'enhancedCount': count});
  }
}
