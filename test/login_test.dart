import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/screens/sign_in_screen.dart';

import 'firebase_auth_mock.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Create a UserCredential with the provided email and password
    final userCredential = MockUserCredential(email: email, password: password);
    return Future.value(userCredential);
  }
}

class MockFirebaseFailAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw FirebaseAuthException(
      code: 'invalid-credentials',
      message: 'Invalid credentials',
    );
  }
}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async => await Firebase.initializeApp());
  bool didSignIn = false;
  late MockFirebaseAuth mockFirebaseAuth;
  late SignInScreen signInScreen;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
  });

  group('Login Tests', () {
    testWidgets('Test successful login', (WidgetTester tester) async {
      signInScreen = SignInScreen(onSignedIn: () => didSignIn = true, auth: MockFirebaseAuth());

      // Pump the SignInScreen widget
      await tester.pumpWidget(
        MaterialApp(
          home: signInScreen,
        ),
      );

      // Enter text in email and password fields
      await tester.enterText(find.byKey(const Key('emailField')), 'ironeto@hotmail.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'teste@12');

      didSignIn = false;

      // Tap the login button
      await tester.tap(find.byKey(const Key('loginButton')));

      expect(didSignIn, true);
    });

    testWidgets('Test login failure', (WidgetTester tester) async {
      signInScreen = SignInScreen(onSignedIn: () => didSignIn = true, auth: MockFirebaseFailAuth());

      // Pump the SignInScreen widget
      await tester.pumpWidget(
        MaterialApp(
          home: signInScreen,
        ),
      );

      // Enter text in email and password fields
      await tester.enterText(find.byKey(const Key('emailField')), 'ironeto@hotmail.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'teste@12');

      didSignIn = false;

      // Tap the login button
      await tester.tap(find.byKey(const Key('loginButton')));

      expect(didSignIn, false);
    });
  });
}

class MockUserCredential extends Mock implements UserCredential {
  late MockUser _user;
  late MockAuthCredential _credential;

  MockUserCredential({required String email, required String password}) {
    _user = MockUser(email: email);
    _credential = MockAuthCredential(password: password);
  }

  @override
  User get user => _user;

  @override
  AuthCredential get credential => _credential;
}

class MockUser extends Mock implements User {
  String _email = '';

  MockUser({required String email}) {
    _email = email;
  }

  @override
  String get email => _email;

  @override
  set email(String? value) {
    _email = value ?? '';
  }
}

class MockAuthCredential extends Mock implements AuthCredential {
  String _password = '';

  MockAuthCredential({required String password}) {
    _password = password;
  }

  @override
  String get password => _password;

  @override
  set password(String? value) {
    _password = value ?? '';
  }
}
