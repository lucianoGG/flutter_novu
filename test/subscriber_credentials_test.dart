import 'package:flutter_novu/api/subscriber.dart';
import 'package:flutter_novu/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriberApi.providerIdValue', () {
    test('maps FCM and OneSignal to Novu API strings', () {
      expect(SubscriberApi.providerIdValue(ProviderId.fcm), 'fcm');
      expect(SubscriberApi.providerIdValue(ProviderId.oneSignal), 'one-signal');
      expect(SubscriberApi.providerIdValue(ProviderId.apns), 'apns');
    });
  });
}
