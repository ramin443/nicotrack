/// App Mode Configuration
/// 
/// Change the appMode value to toggle between different modes:
/// - AppMode.production: Normal app behavior with actual premium status
/// - AppMode.dev: Forces full premium features for development/testing
/// 
/// To change mode, simply modify the appMode value below and hot reload.

enum AppMode {
  production,  // Normal app behavior
  dev,         // Forces full premium features
}

class AppModeConfig {
  /// CHANGE THIS VALUE TO TOGGLE BETWEEN MODES
  /// 
  /// Set to:
  /// - AppMode.production for normal app behavior
  /// - AppMode.dev to force full premium features
  static const AppMode appMode = AppMode.dev;
  
  /// Check if app is in dev mode
  static bool get isDevMode => appMode == AppMode.dev;
  
  /// Check if app should force premium features
  static bool get shouldForcePremium => isDevMode;
}