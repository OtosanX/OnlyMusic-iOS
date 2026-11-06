import Foundation

@main struct OnlyMusicDefaultsCheck {
    static func main() {
        let suite = "onlymusic-check-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        OnlyMusicDefaults.register(in: defaults)
        precondition(!defaults.bool(forKey: "autoplay"))
        precondition(!defaults.bool(forKey: "animated_canvas"))
        precondition(defaults.bool(forKey: "reduce_animation"))
        precondition(!defaults.bool(forKey: "stop_when_backgrounded"))
        precondition(defaults.string(forKey: "theme_mode") == "dark")
        defaults.set(true, forKey: "autoplay")
        defaults.set(false, forKey: "reduce_animation")
        OnlyMusicDefaults.register(in: defaults)
        precondition(defaults.bool(forKey: "autoplay"))
        precondition(!defaults.bool(forKey: "reduce_animation"))
        print("OnlyMusic defaults: quiet first launch and saved choices passed")
    }
}
