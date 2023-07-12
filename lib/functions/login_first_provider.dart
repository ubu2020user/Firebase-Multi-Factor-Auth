import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/multi_factor_auth_type.dart';
import '../provider/auth_provider.dart';
import '../utils/login_providers/login_google.dart';

void functionLoginFirstProvider({
  required BuildContext context,
  MultiFactorAuthType authType = MultiFactorAuthType.GOOGLE,
}) async {
  var authProvider = Provider.of<AuthProvider>(context, listen: false);

  if (authType == MultiFactorAuthType.GOOGLE) {
    var l = await GoogleLogin().signIn(authProvider);
  }
}
