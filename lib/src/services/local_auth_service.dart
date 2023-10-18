import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuthService {
  late LocalAuthentication auth;

  LocalAuthService(){
    auth = LocalAuthentication();
  }

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    return await auth.authenticate(
      authMessages:const <AuthMessages>[AndroidAuthMessages(
        signInTitle: 'Validar Identidade',
        cancelButton: 'Cancelar',
        biometricHint: '',
      )],
      localizedReason: 'Use a biometria ou senha para validar sua identidade.',
    );
  }
}