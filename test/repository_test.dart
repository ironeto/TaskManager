import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/repositories/tasks_repository.dart';

import 'firebase_auth_mock.dart';

// Create a mock for FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Create a mock for FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async => await Firebase.initializeApp());

  late TasksRepository repository;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockCollectionReference mockCollectionReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockCollectionReference = MockCollectionReference();

    repository = TasksRepository();
    repository.dbFireStore = mockFirestore;
  });

  group('TasksRepository', () {
    test('Test list() method', () async {
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockCollectionReference = MockCollectionReference();
      when(() => mockFirestore.collection(any()))
          .thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);

      final result = await repository.list();

      expect(result, equals(mockQuerySnapshot));
      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockCollectionReference.get()).called(1);
    });

    test('Test insert() method', () async {
      final mockDocumentReference = MockDocumentReference();
      final mockCollectionReference = MockCollectionReference();
      when(() => mockFirestore.collection(any()))
          .thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async => null);

      final result = await repository.insert('document_id', {'data': 'example'});

      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockCollectionReference.doc('document_id')).called(1);
      verify(() => mockDocumentReference.set({'data': 'example'})).called(1);
    });

    test('Test show() method', () async {
      final mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      final mockDocumentReference = MockDocumentReference();
      final mockCollectionReference = MockCollectionReference();
      when(() => mockFirestore.collection(any()))
          .thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);

      final result = await repository.show('document_id');

      expect(result, equals(mockDocumentSnapshot));
      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockCollectionReference.doc('document_id')).called(1);
      verify(() => mockDocumentReference.get()).called(1);
    });

    test('Test update() method', () async {
      final mockDocumentReference = MockDocumentReference();
      final mockCollectionReference = MockCollectionReference();
      when(() => mockFirestore.collection(any()))
          .thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async => null);

      final result = await repository.update('document_id', {'data': 'example'});

      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockCollectionReference.doc('document_id')).called(1);
      verify(() => mockDocumentReference.set({'data': 'example'})).called(1);
    });

    test('Test delete() method', () async {
      final mockDocumentReference = MockDocumentReference();
      final mockCollectionReference = MockCollectionReference();
      when(() => mockFirestore.collection(any()))
          .thenReturn(mockCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.delete()).thenAnswer((_) async => null);

      final result = await repository.delete('document_id');

      verify(() => mockFirestore.collection('tasks')).called(1);
      verify(() => mockCollectionReference.doc('document_id')).called(1);
      verify(() => mockDocumentReference.delete()).called(1);
    });
  });
}

class MockQuerySnapshot<T extends Object> extends Mock implements QuerySnapshot<T> {}

class MockDocumentSnapshot<T extends Object> extends Mock implements DocumentSnapshot<T> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
