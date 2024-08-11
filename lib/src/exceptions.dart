/// base class for data migration exceptions
class DataMigrationException implements Exception {
  /// constructor
  const DataMigrationException([this.message]);

  /// message
  final Object? message;

  @override
  String toString() {
    return 'DataMigration: $message';
  }
}
