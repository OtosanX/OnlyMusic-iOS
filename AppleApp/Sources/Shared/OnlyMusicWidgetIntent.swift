import AppIntents

// Audio intents run in the app process, including while its UI is suspended.
struct WidgetTransportIntent: AudioPlaybackIntent {
    static var title: LocalizedStringResource = "OnlyMusic Playback"
    static var isDiscoverable = false

    @Parameter(title: "Command") var command: String

    init() { command = "toggle" }
    init(command: String) { self.command = command }

    @MainActor
    func perform() async throws -> some IntentResult {
        #if !ONLYMUSIC_WIDGET
        let services = AppServices.shared
        await services.waitUntilReady()
        switch command {
        case "previous": services.controller.previous()
        case "next": services.controller.next()
        case "toggle": services.controller.togglePlayPause()
        default: break
        }
        #endif
        return .result()
    }
}
