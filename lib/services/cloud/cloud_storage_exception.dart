import 'package:flutter/foundation.dart';

@immutable
class CloudStorageException implements Exception {}

class CouldNotCreateException extends CloudStorageException {}

class CouldNotGetAllNoteException extends CloudStorageException {}

class CouldNotUpdateException extends CloudStorageException {}

class CouldNotDeleteException extends CloudStorageException {}
