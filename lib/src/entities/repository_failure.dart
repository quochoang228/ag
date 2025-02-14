abstract class RepositoryFailure implements Exception {
  const RepositoryFailure(this.error);

  final Object error;
}