class FirestoreFailure implements Exception {
  const FirestoreFailure([this.message = "An unexpected error occurred."]);

  factory FirestoreFailure.fromCode(String code) {
    switch (code) {
      case 'code':
      default:
        return FirestoreFailure();
    }
  }

  final String message;
}
