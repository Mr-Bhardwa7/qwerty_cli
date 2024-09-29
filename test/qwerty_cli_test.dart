import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQwertyCliPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {}
