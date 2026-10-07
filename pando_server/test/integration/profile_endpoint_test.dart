import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the profile endpoint', (sessionBuilder, endpoints) {
    final alice = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '550e8400-e29b-41d4-a716-446655440000',
        {},
      ),
    );
    final bob = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        {},
      ),
    );

    test('when nothing is saved yet then get returns null', () async {
      expect(await endpoints.profile.get(alice), isNull);
    });

    test('when height is saved then get returns it', () async {
      await endpoints.profile.saveHeight(alice, 1.70);
      final profile = await endpoints.profile.get(alice);
      expect(profile?.heightM, 1.70);
    });

    test(
      'when height is saved twice then the profile is updated, not duplicated',
      () async {
        final first = await endpoints.profile.saveHeight(alice, 1.70);
        final second = await endpoints.profile.saveHeight(alice, 1.82);
        expect(second.id, first.id);
        expect((await endpoints.profile.get(alice))?.heightM, 1.82);
      },
    );

    test(
      'when another user saves then each sees only their own profile',
      () async {
        await endpoints.profile.saveHeight(alice, 1.70);
        await endpoints.profile.saveHeight(bob, 1.60);
        expect((await endpoints.profile.get(alice))?.heightM, 1.70);
        expect((await endpoints.profile.get(bob))?.heightM, 1.60);
      },
    );

    test('when an impossible height is sent then it is rejected', () async {
      await expectLater(
        endpoints.profile.saveHeight(alice, 9.0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('when signed out then get is refused', () async {
      final anonymous = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectLater(
        endpoints.profile.get(anonymous),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
