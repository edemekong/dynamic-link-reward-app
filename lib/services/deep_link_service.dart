import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;

  static DeepLinkService? get instance {
    if (_instance == null) {
      _instance = DeepLinkService._();
    }
    return _instance;
  }

  String? referrerCode;

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    if (data != null) {
      _handleDeepLink(data);
    }
    //handle foreground
    dynamicLink.onLink(onSuccess: (PendingDynamicLinkData? dynamicLinkData) async {
      _handleDeepLink(dynamicLinkData!);
    }, onError: (OnLinkErrorException error) async {
      print('Failed: ${error.message}');
    });
  }

  Future<String> createReferLink(String referCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://flutterfairy.page.link',
      link: Uri.parse('https://reward_app.com/refer?code=$referCode'),
      androidParameters: AndroidParameters(
        packageName: 'dev.flutterfairy.dynamic_link_reward_app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'REFER A FRIEND & EARN',
        description: 'Earn 1,000USD on every referral',
        imageUrl: Uri.parse('https://moru.com.np/wp-content/uploads/2021/03/Blog_refer-Earn.jpg'),
      ),
    );

    final ShortDynamicLink shortLink = await dynamicLinkParameters.buildShortLink();
    final Uri dynamicUrl = shortLink.shortUrl;
    return dynamicUrl.toString();
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    var isRefer = deepLink.pathSegments.contains('refer');
    if (isRefer) {
      var code = deepLink.queryParameters['code'];
      if (code != null) {
        //Do something
        referrerCode = code;
        print('ReferrerCode $referrerCode');
      }
    }
  }
}
