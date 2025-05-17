//
//  SettingsManager.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/14/25.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private let quizUrlKey = "quizUrl"
    private let refreshIntervalKey = "refreshInterval"
    private let lastRefreshTimeKey = "lastRefreshTime"
    
    private let defaults = UserDefaults.standard
    
    private let defaultQuizUrl = "https://tednewardsandbox.site44.com/questions.json"
    private let defaultRefreshInterval = 60.0
    
    var quizUrl: String {
        get {
            return defaults.string(forKey: quizUrlKey) ?? defaultQuizUrl
        }
        set {
            defaults.set(newValue, forKey: quizUrlKey)
        }
    }
    
    var refreshInterval: Double {
        get {
            return defaults.double(forKey: refreshIntervalKey) != 0 ?
                   defaults.double(forKey: refreshIntervalKey) : defaultRefreshInterval
        }
        set {
            defaults.set(newValue, forKey: refreshIntervalKey)
        }
    }
    
    var lastRefreshTime: Date? {
        get {
            return defaults.object(forKey: lastRefreshTimeKey) as? Date
        }
        set {
            defaults.set(newValue, forKey: lastRefreshTimeKey)
        }
    }
    
    
}
