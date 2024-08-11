import 'package:data_migration/data_migration.dart';

/// Apply a list of [DataMigration]
///
/// ```dart
/// manager = const DataMigrationManager([
///    CounterV1DataMigration(),
///    CounterV2DataMigration(),
///    CounterV3DataMigration(),
/// ]);
///
/// final migratedData = await manager.migrateIfNeeded(3, fromVersion: 1);
/// ```
class DataMigrationManager {
  /// create a [DataMigrationManager] with a list of [DataMigration]
  const DataMigrationManager(
    this._migrations,
  );

  final List<DataMigration> _migrations;

  /// take [data] and an initial version [fromVersion]
  ///
  /// iterate over [DataMigration]s and apply it
  Future<dynamic> migrateIfNeeded(
    dynamic data, {
    required int fromVersion,
  }) async {
    var migratedData = data;

    await Future.forEach<DataMigration>(_migrations, (migration) async {
      // ignore migration
      if (migration.fromVersion != fromVersion) {
        return;
      }

      // apply migration
      try {
        migratedData = await migration.migrate(migratedData);
        fromVersion = migration.toVersion;
      } catch (error) {
        throw DataMigrationException(error);
      }
    });

    return migratedData;
  }
}
