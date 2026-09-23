import 'package:flutter_novu/push/types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toJson uses deviceToken/deviceOs for backend contract', () {
    const registration = PushTokenRegistration(
      subscriberId: 'user-123',
      token: 'fcm-token',
      platform: 'android',
      provider: 'fcm',
    );

    expect(registration.toJson(), {
      'deviceToken': 'fcm-token',
      'deviceOs': 'android',
    });
    expect(registration.deviceToken, 'fcm-token');
    expect(registration.deviceOs, 'android');
  });

  test('looksLikeFcmToken detects APA91 tokens', () {
    expect(
      PushTokenRegistration.looksLikeFcmToken(
        'cXyz:APA91bExampleFcmTokenThatShouldNotGoToApns',
      ),
      isTrue,
    );
    expect(
      PushTokenRegistration.looksLikeFcmToken('a1b2c3d4e5f67890'),
      isFalse,
    );
  });

  test('iOS registration uses apns provider and hex-like token', () {
    const registration = PushTokenRegistration(
      subscriberId: 'user-123',
      token: 'a1b2c3d4e5f67890aabbccddeeff0011',
      platform: 'ios',
      provider: 'apns',
    );
    expect(registration.provider, 'apns');
    expect(registration.fcmLike, isFalse);
    expect(registration.toJson(), {
      'deviceToken': 'a1b2c3d4e5f67890aabbccddeeff0011',
      'deviceOs': 'ios',
    });
  });
}
