import 'package:flutter_acrcloud/flutter_acrcloud.dart';

import '../config/environment_config.dart';
import '../utils/app_logger.dart';

class SongRecognitionService {
  static final SongRecognitionService _instance =
      SongRecognitionService._internal();

  factory SongRecognitionService() {
    return _instance;
  }

  SongRecognitionService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final host = EnvironmentConfig.acrCloudHost;
      final accessKey = EnvironmentConfig.acrCloudAccessKey;
      final accessSecret = EnvironmentConfig.acrCloudAccessSecret;

      if (host.isEmpty || accessKey.isEmpty || accessSecret.isEmpty) {
        AppLogger.error('ACRCloud credentials missing in environment config');
        return;
      }

      await ACRCloud.setUp(ACRCloudConfig(accessKey, accessSecret, host));
      _isInitialized = true;
      AppLogger.info('ACRCloud initialized successfully');
    } catch (e) {
      AppLogger.error('Error initializing ACRCloud', e);
    }
  }

  Future<ACRCloudSession?> startRecognition() async {
    if (!_isInitialized) await initialize();

    try {
      return ACRCloud.startSession();
    } catch (e) {
      AppLogger.error('Error starting recognition session', e);
      return null;
    }
  }

  void stopRecognition() {
    try {
      // flutter_acrcloud handles session cancellation via the session object usually,
      // but if we just want to stop global recording if applicable.
      // Actually usually we just cancel the session if we store it.
      // For this simple implementation, we might not need explicit stop if we await the result.
      // But let's see how the library works. It usually returns a session we can cancel.
    } catch (e) {
      AppLogger.error('Error stopping recognition', e);
    }
  }
}
