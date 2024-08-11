# Data Migration

[![ci][ci_badge]][ci_link]
[![License: MIT][license_badge]][license_link]
[![coverage][coverage_badge]][coverage_badge]

A library for applying a series of migrations to update old versions of data structures to the most
recent one.

## Installation

```yaml
dependencies:
  data_migration:
```

## How to use

1. Create your set of migration

   ```dart
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

   final migrator = DataMigrationManager(
     [
       CounterV1DataMigration(),
     ],
   );
   ```

2. Apply migration on data
   ```dart
     final migrated1 = await _migrator.migrateIfNeeded(
        3,
        fromVersion: 1,
     );
   ```

## Examples

In the [example](./example/main.dart) and [tests](./test/src/data_migration_test.dart),
there are some examples of "data migration."

[ci_badge]: https://github.com/VeryGoodOpenSource/very_good_workflows/actions/workflows/ci.yml/badge.svg
[ci_link]: https://github.com/MattiaPispisa/data_migration/actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[coverage_badge]: https://img.shields.io/badge/coverage-100%25-green
