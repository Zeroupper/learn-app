/// Compile-time configuration.
///
/// The OpenRouter API key is injected at build time, never stored on device:
///   flutter run --dart-define=OPENROUTER_API_KEY=sk-or-...
///   flutter build apk --dart-define=OPENROUTER_API_KEY=sk-or-...
const openRouterApiKey = String.fromEnvironment('OPENROUTER_API_KEY');

bool get hasApiKey => openRouterApiKey.isNotEmpty;
