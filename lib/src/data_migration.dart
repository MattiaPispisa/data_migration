/// Interface for migrating data from [fromVersion]
/// to [toVersion].
///
/// ```dart
/// class CounterV1DataMigration extends DataMigration {
///   @override
///   int get fromVersion => 1;
///
///   @override
///   int get toVersion => 2;
///
///   @override
///   Future<dynamic> migrate(dynamic data) async {
///     return '{count: $data}';
///   }
/// }
/// ```
abstract class DataMigration {
  /// The version of the data to be migrated.
  int get fromVersion;

  /// The version of the data once the migration has been completed.
  int get toVersion;

  /// apply migration from [fromVersion] to [toVersion]
  Future<dynamic> migrate(dynamic data);
}
