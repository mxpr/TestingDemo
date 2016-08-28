//
//  LoginViewModel.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import Foundation

protocol LoginViewModel {
    var showWelcomePrompt: (() -> Void)? { get set }
    
    func wakeup()
    func sleep()
    func login()
    func signup()
}

protocol KeyValueStore {
    func boolForKey(key: String) -> Bool
    mutating func setBool(value: Bool, forKey: String)
}

class DefaultLoginViewModel: LoginViewModel {
    
    struct Constants {
        static let WelcomePromptDisplayedKey = "WelcomePromptDisplayedKey"
    }
    
    var showWelcomePrompt: (() -> Void)? = nil
    private var keyValueStore: KeyValueStore
    init(keyValueStore: KeyValueStore) {
        self.keyValueStore = keyValueStore
    }
    
    func wakeup() {
        let previouslyDisplayed = keyValueStore.boolForKey(Constants.WelcomePromptDisplayedKey)
        if (!previouslyDisplayed) {
            showWelcomePrompt?()
            keyValueStore.setBool(true, forKey: Constants.WelcomePromptDisplayedKey)
        }
    }
    
    func sleep() {
        
    }
    
    func login() {
        
    }
    
    func signup() {
        
    }
    
}

extension NSUserDefaults: KeyValueStore {
    
}

class TestingLoginViewModel: LoginViewModel {
    
    var showWelcomePrompt: (() -> Void)? = nil
    let beeper: Beeper = DarwinNotificationCenterBeeper()
    
    init() {
    
        
        beeper.registerBeepHandler(BeeperConstants.TriggerWelcomePrompt) { [unowned self] in
            self.showWelcomePrompt?()
        }
    }
    
    func wakeup() {
        
    }
    
    func sleep() {
        
    }
    
    func login() {
        
    }
    
    func signup() {
        
    }
    
}


