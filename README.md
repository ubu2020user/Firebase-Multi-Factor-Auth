# Table of Contents
- [Table of Contents](#table-of-contents)
- [General](#general)
- [Disclaimer](#disclaimer)
- [Setup](#setup)
  - [1. Add the Plugin](#1-add-the-plugin)
  - [2. Firebase initalization](#2-firebase-initalization)
  - [3. Enable Cloud Firestore (Database)](#3-enable-cloud-firestore-database)
  - [4. Enable internet for android apps](#4-enable-internet-for-android-apps)
  - [5. Enable google client id for web apps](#5-enable-google-client-id-for-web-apps)
- [Implementation](#implementation)
  - [1. main.dart](#1-maindart)
  - [2. Wrap your app in the FirebaseMultiFactorAuth widget](#2-wrap-your-app-in-the-firebasemultifactorauth-widget)
    - [2.1 Login Widget](#21-login-widget)
    - [2.2 OTP Phone Widget](#22-otp-phone-widget)
    - [2.3 OTP Verification Widget](#23-otp-verification-widget)
    - [2.4 First Login Widget](#24-first-login-widget)
  - [3. Main Widget](#3-main-widget)
- [Common errors](#common-errors)
  - [Google Sign In](#google-sign-in)
- [How does it work?](#how-does-it-work)
  - [1. Firebase Multi Factor Auth Widget](#1-firebase-multi-factor-auth-widget)
  - [2. Auth Controller Widget](#2-auth-controller-widget)
  - [3. OTP Controller Widget](#3-otp-controller-widget)
  - [4. FirebaseMultiFactorAuth](#4-firebasemultifactorauth)
- [Post Scriptum](#post-scriptum)

 
# General
This library enables the firebase multi factor authentication for your flutter app.  
The first implemented method is the google sign in. The second method is the phone number sign in.

If you use google mail for login and two different phone numbers for MFA, you create two accounts.  
It will not be checked if your phone number is already used for another account.

An example project with working android and web instance lies under example/.  
Other platforms are not implemented or tested yet.   
But you can add it ;) It is open source.

You do not need to use the provided widgets.   
You can use the functions, widgets and capabilities directly.

# Disclaimer
Firebase multi factor authentication without credit card for testing purposes only? 
Sure!

This is a proof of concept (poc).

This library is not affiliated with Firebase or Google.
> It is only for testing purposes when you do not have a credit card and want to test firebase multi factor authentication.

Usually you don't have to pay for a certain amount of MFA requests. Only for this amount this library is allowed to use.   
You are responsible for any damage or loss of profit for google that may occur.


# Setup
## 1. Add the Plugin
```bash
flutter pub add firebase_multi_factor_auth
```

## 2. Firebase initalization
You can follow this guide as well: [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup?platform=ios)
```bash
# Install the CLI if not already done so
dart pub global activate flutterfire_cli

# Run the `configure` command, select a Firebase project and platforms
flutterfire configure
```

## 3. Enable Cloud Firestore (Database)
```bash
# Project Settings > Database > Create Database
# Select a location
# Add a collection named "private"
# Add a collection named "public"
```

## 4. Enable internet for android apps
Add following line to AndroidManifest.xml

```xml
  <uses-permission android:name="android.permission.INTERNET"/>
```
 
## 5. Enable google client id for web apps
Example [web/index.html](./example/web/index.html).
```md
In your web/index.html add following line: 
<meta name="google-signin-client_id" content="YOUR_OWN_ID.apps.googleusercontent.com">

Follow: https://pub.dev/packages/google_sign_in
or see: https://www.balbooa.com/gridbox-documentation/how-to-get-google-client-id-and-client-secret
```

# Implementation
## 1. main.dart
Example [main.dart](./example/lib/main.dart).

Add following before you run the app
```dart 
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // this will be only possible if you run 'flutterfire configure' before!

  runApp(const App());
}
```

## 2. Wrap your app in the FirebaseMultiFactorAuth widget
Example [app.dart](./example/lib/app.dart).  

```dart
FirebaseMultiFactorAuthWidget(
    loginWidget: LoginWidget(),
    otpControllerWidget: OTPControllerWidget(
      phoneInputWidget: OTPPhoneWidget(),
      otpSentWidget: OTPVerificationWidget(),
      firstLoginWidget: UsernameInputWidget(),
    ),
    mainWidget: MainWidget(),
  ),
),
```
### 2.1 Login Widget
Example [login_widget.dart](./example/lib/widgets/1_login_widget.dart). 

Implement your login page with the loginFirstProvider function.

The function below will trigger the google sign in flow.
```dart
ElevatedButton.icon(
  label: Text("Login Google"),
  icon: Icon(Icons.g_mobiledata_outlined),
  onPressed: () {
    FirebaseMultiFactorAuth.loginFirstProvider(
        context: context, authType: MultiFactorAuthType.GOOGLE);
  },
),
```
### 2.2 OTP Phone Widget
Example [otp_phone_input.dart](./example/lib/widgets/2_otp_phone_input_widget.dart). 

Implement your phone number input widget.  

With the function below you trigger the number checking and otp sending flow.
```dart
FirebaseMultiFactorAuth.inputPhoneNumberSendOTP(
  context: context, 
  phoneNumber: phoneController.text
);
```

### 2.3 OTP Verification Widget
Example [otp_verification_input.dart](./example/lib/widgets/3_otp_verification_input_widget.dart). 

Implement your otp input widget.

With the function below you trigger the otp verification flow.
```dart
await FirebaseMultiFactorAuth.inputPhoneOTP(
            context: this.context, 
            otpCode: _otpController.text);
```

### 2.4 First Login Widget
Example [first_login_widget.dart](./example/lib/widgets/4_username_input_widget.dart).   

Implement the widget that is shown on the user's first login.

With the function below you disable the first login widget for the user's next login.
```dart
/* Your code and maybe some firestore calls */

await FirebaseMultiFactorAuth.setFirstLogin(
        context: context, 
        isFirstLogin: false);
```

## 3. Main Widget
The main widget is just your app that will be allowed to run when and if the user is logged in via two factors. 

# Common errors
## Google Sign In
```md
Error while singing in with google: PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null, null)

## Android SHA-1 app not registered
1. Just add the SHA-1 key to your firebase project settings.
1.1. Open android/ folder in Android Studio
1.2. Open Gradle tab on the right side
1.3. Execute Gradle Task "gradle signingReport"
1.4. Copy SHA-1 key from the console
1.5. Add SHA-1 key to your firebase project settings.
   
## Support mail not added
2. Add a support mail to your firebase project settings.
2.1. Open firebase project settings
2.2. Add a support mail
2.3. Save
```

# How does it work?
## 1. Firebase Multi Factor Auth Widget
The [widget](./lib/widgets/1_firebase_multi_factor_auth_widget.dart) is the main widget that wraps your app.  
It enables the three main providers: [AuthProvider](./lib/provider/auth_provider.dart), [UserProvider](./lib/provider/user_provider.dart) and [OTPProvider](./lib/provider/otp_provider.dart).

## 2. Auth Controller Widget
The [widget](./lib/widgets/2_auth_controller_widget.dart) listens on AuthProvider state changes and handles the different cases of the user logged in, not logged in, logged in with one factor and logged in with two factors.

## 3. OTP Controller Widget
The [widget](./lib/widgets/3_otp_controller_widget.dart) listens on OTPProvider state changes and handles the different cases of the otp states.  
Those are: 
1. OTPState.PHONE_INPUT
2. OTPState.OTP_SENT
3. OTPState.FIRST_LOGIN

The 3. state describes the otp flow after the user is logged in but before he saw the on first login page.

## 4. FirebaseMultiFactorAuth
The [class](./lib/firebase_multi_factor_auth.dart) is the main class that contains all the functions easily available to the libraries user.

# Post Scriptum

P.S.: The concept and this implementation was first developed in late 2022 and is still in development.
P.P.S.: Google declined my application as dev! 😡😂