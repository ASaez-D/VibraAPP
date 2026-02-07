import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_logger.dart';

import '../utils/api_constants.dart';

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
      final host = dotenv.env[AcrCloudApiConstants.envHost] ?? '';
      final accessKey = dotenv.env[AcrCloudApiConstants.envAccessKey] ?? '';
      final accessSecret =
          dotenv.env[AcrCloudApiConstants.envAccessSecret] ?? '';

      if (host.isEmpty || accessKey.isEmpty || accessSecret.isEmpty) {
        AppLogger.error('ACRCloud credentials missing in .env');
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
