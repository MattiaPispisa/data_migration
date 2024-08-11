import 'package:data_migration/data_migration.dart';

main() async {
  // The first time, I thought a single `int` would be enough to represent
  // my data structure.
  //
  // Later on, I persisted the data using the `SimpleCounter` structure,
  // and after that, I moved to `Counters`.
  //
  // I apply a `DataMigration` to preserve the data
  // saved in previous versions of the application.

  final _migrator = DataMigrationManager(
    [
      CounterV1DataMigration(),
      CounterV2DataMigration(),
    ],
  );

  final migrated1 = await _migrator.migrateIfNeeded(3, fromVersion: 1);
  print(Counters.fromJson(migrated1));

  final migrated2 = await _migrator.migrateIfNeeded(
    SimpleCounter(2).toJson(),
    fromVersion: 2,
  );
  print(Counters.fromJson(migrated2));
}

class Counters {
  const Counters(this.counts);

  factory Counters.fromJson(dynamic data) {
    return Counters((data as Map<String, dynamic>)['counts'] as List<int>);
  }

  final List<int> counts;

  Map<String, dynamic> toJson() {
    return {'counts': counts};
  }

  @override
  String toString() {
    return 'counts: $counts';
  }
}

class SimpleCounter {
  const SimpleCounter(this.count);

  factory SimpleCounter.fromJson(dynamic data) {
    return SimpleCounter((data as Map<String, dynamic>)['count'] as int);
  }

  final int count;

  Map<String, dynamic> toJson() {
    return {'count': count};
  }
}

class CounterV1DataMigration implements DataMigration {
  const CounterV1DataMigration();

  @override
  int get fromVersion => 1;

  @override
  int get toVersion => 2;

  @override
  Future<dynamic> migrate(dynamic data) async {
    final counter = SimpleCounter(data as int);
    return counter.toJson();
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
    final counter = SimpleCounter.fromJson(data);
    return Counters([counter.count]).toJson();
  }
}
