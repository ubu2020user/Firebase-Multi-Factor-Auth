#include "include/firebase_multi_factor_auth/firebase_multi_factor_auth_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "firebase_multi_factor_auth_plugin.h"

void FirebaseMultiFactorAuthPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  firebase_multi_factor_auth::FirebaseMultiFactorAuthPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
