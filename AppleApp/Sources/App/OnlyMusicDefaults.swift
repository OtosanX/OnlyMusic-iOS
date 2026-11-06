import Foundation

enum OnlyMusicDefaults {
    static func register(in defaults: UserDefaults = .standard) {
        defaults.register(defaults: [
            "autoplay": false,
            "animated_canvas": false,
            "reduce_animation": true,
            "synced_lyrics": false,
            "prefer_music_only": true,
            "show_music_videos": false,
            "smart_fade_enabled": false,
            "stop_when_backgrounded": false,
            "stop_music_on_close": false,
            "theme_mode": "dark"
        ])
    }
}
