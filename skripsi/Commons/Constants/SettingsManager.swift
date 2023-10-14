//
//  SettingsManager.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation

class SettingsManager {
    
    static let shared = SettingsManager()
    
    private init() {}
    
    func hasFinishedOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaults.keyHasFinishedOnBoarding)
    }
    
    func setHasFinishedOnboarding() {
        UserDefaults.standard.set(true, forKey: UserDefaults.keyHasFinishedOnBoarding)
    }
}
