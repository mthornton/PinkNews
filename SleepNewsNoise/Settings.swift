//
//  Settings.swift
//  PinkNews
//
//  Created by Michael Thornton on 1/11/22.
//  Copyright © 2022 Michael Thornton. All rights reserved.
//

import Foundation


enum SettingsKeys: String {
    case pinkDuration = "pinkDuration"
    case feed = "feed"
    case sound = "sound"
}


class Settings: ObservableObject {
    
    @Published var playAllNews = true
    

    static let noFeedTag = "Don't play news"
    
    static let sounds: [String: String] = [
        "White noise": "Pink_noise.ogg.mp3",
        "Light rain": "light_rain.ogg.mp3",
        "Heavy rain": "rain_and_thunder.ogg.mp3"
    ]
    
    static let soundNames = [
        "White noise",
        "Light rain",
        "Heavy rain"
    ]
    
    static let feeds = [
        "Don't play news",
        "Cyber Wire",
        "ESPN",
        "New York Times: The Daily",
        "NPR: Up First",
        "Pastor Rick",
        "The Morning Agenda",
        "WaPo: The 7",
        "WaPo: Post Reports",
        "Wharton Business Daily",
    ]
    
    static let feedUrls: [String: String] = [
        "NPR: Up First": "https://feeds.npr.org/510318/podcast.xml",
        "New York Times: The Daily": "https://feeds.simplecast.com/54nAGcIl",
        "WaPo: The 7": "https://podcast.posttv.com/itunes/the-7.xml",
        "WaPo: Post Reports": "https://podcast.posttv.com/itunes/post-reports.xml",
        "ESPN": "https://feeds.megaphone.fm/ESP8348692127",
        "Pastor Rick": "https://dailyhope.libsyn.com/rss",
        "Wharton Business Daily": "https://feeds.acast.com/public/shows/5ab54c70bb6ddf45527e06b1",
        "Cyber Wire": "https://feeds.megaphone.fm/cyberwire-daily-podcast",
        "The Morning Agenda": "https://www.omnycontent.com/d/playlist/8ab739a0-6a10-4a67-91ee-ae28012e7b58/a2792ce2-e48a-4f84-844d-afa9014aa436/de44be94-46cf-4e04-9345-afa9014e1f3a/podcast.rss"
    ]

    // default to 8 hours
    @Published var pinkDuration: Int = 8 {
        didSet {
            print("updated duration")
            updateValue(pinkDuration, forKey: .pinkDuration)
        }
    }
    

    @Published var feedName: String = Settings.noFeedTag {
        didSet {
            print("updated feed")
            updateValue(feedName, forKey: .feed)
        }
    }

    @Published var soundName: String = "White noise" {
        didSet {
            print("updated sound")
            updateValue(soundName, forKey: .sound)
        }
    }

    
    var soundFileName: String {
        if let fn = Settings.sounds[soundName] {
            return fn
        }
        else {
            return "White noise"
        }
    }
    
    var link: String? {
        return Settings.feedUrls[feedName]
    }
    
    var hadFeed: Bool {
        feedName != Settings.noFeedTag
    }
    
    
    init() {
        
        let defaults = UserDefaults.standard
        
        // defaults.removeObject(forKey: SettingsKeys.pinkDuration.rawValue)
        // defaults.removeObject(forKey: SettingsKeys.feed.rawValue)
        
        
        if let pinkDuration = defaults.value(forKey: SettingsKeys.pinkDuration.rawValue) as? Int {
            self.pinkDuration = pinkDuration
        }
        else {
            // if nothing found set to the default value
            defaults.setValue(self.pinkDuration, forKey: SettingsKeys.pinkDuration.rawValue)
        }

        if let feedName = defaults.value(forKey: SettingsKeys.feed.rawValue) as? String {
            self.feedName = feedName
        }
        
        if let soundName = defaults.value(forKey: SettingsKeys.sound.rawValue) as? String {
            self.soundName = soundName
        }
        
    }
    
    
    
    func updateValue(_ value: Any, forKey key: SettingsKeys) {
     
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    
    
    func value(_ key: SettingsKeys) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key.rawValue)
    }

    
} // end class



extension Settings: CustomStringConvertible {

    var description: String {
        "duration: \(self.pinkDuration), feed: \(feedName), link: \(self.link ?? "no link")"
    }
} // end extension
