import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/home/DynamicJoin.dart';

class DynamicLinkService {
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      print("deepLink $data");
      final Uri deepLink = data?.link;
      print(deepLink.toString());

      if (deepLink != null) {
        String code = deepLink.queryParameters['code'];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DynamicJoin(code)));
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        print('dynamicLink $dynamicLink');
        final Uri deepLink = dynamicLink?.link;
        String code = deepLink.queryParameters['code'];
        print("deepLink2 $deepLink code $code");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DynamicJoin(code)));
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
