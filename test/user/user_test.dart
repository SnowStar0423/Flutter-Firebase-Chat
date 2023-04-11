void main() async {
  // late AuthService authService;
  // late UserCredential userCred;
  // late AuthViewModel authViewModel;
  // late UserService userService;
  // late FakeFirebaseFirestore fakeFirebaseFirestore;

  // setUpAll(() async {
  //   final user = MockUser(
  //       isAnonymous: false,
  //       uid: 'someuid',
  //       email: 'vannygigo@gmail.com',
  //       displayName: 'Go',
  //       photoURL: null);
  //   final auth = MockFirebaseAuth(mockUser: user);
  //   authService = AuthService(firebaseAuth: auth);
  //   userCred = await auth.signInWithEmailAndPassword(
  //       email: 'vannygigo@gmail.com', password: '123456');

  //   fakeFirebaseFirestore = FakeFirebaseFirestore();
  //   fakeFirebaseFirestore.collection(FireStoreConstant.userCollectionPath);
  //   userService = UserService(firebaseFirestore: FirebaseFirestore.instance);
  //   authViewModel =
  //       AuthViewModel(authService: authService, userService: userService);
  // });
  // test('test login', () async {
  //   when(authService.signInWithEmailPassword(
  //           email: 'vannygigo@gmail.com', password: '123456'))
  //       .thenAnswer((_) async => userCred);
  //   final signIn = await authViewModel.signInWithEmailPassword(
  //       email: 'vannygigo@gmail.com', password: '123456');
  //   expect(signIn, true);
  // });
}
