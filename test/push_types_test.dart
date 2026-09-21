import 'package:flutter_novu/push/types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PushTokenRegistration.toJson matches POST /push/register body', () {
    const registration = PushTokenRegistration(
      subscriberId: 'user-123',
      token: 'fcm-token',
      platform: 'ios',
    );

    expect(registration.toJson(), {
      'subscriberId': 'user-123',
      'token': 'fcm-token',
      'platform': 'ios',
    });
  });
}
