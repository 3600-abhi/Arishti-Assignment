import 'package:arishti_task/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  // variables used in authentication
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  List<BiometricType> _availableBiometric = [];
  String _authenticationMessage = "";

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometrices() async {
    List<BiometricType> availableBiometric = [];
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: "Unlock Arishti App",
        options: const AuthenticationOptions(
          stickyAuth: true,
          // biometricOnly: true,
          useErrorDialogs: true
        ),
      );
    } on PlatformException catch (e) {
      print("Exiting the app");
      SystemNavigator.pop();
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _authenticationMessage = isAuthenticated
          ? "Authenticated Successfully"
          : "Failed to Authenticate";
      if (isAuthenticated) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
      else {
        SystemNavigator.pop();
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkBiometric();
    _getAvailableBiometrices();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child : Text("Arishti", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),)
      ),
    );
  }
}
