//
//  LoginViewModel.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import Foundation

protocol LoginViewModel {
    
    // can be removed when using a Reactive framework
    var viewModelDidUpdate: (() -> Void)? { get set }
    var showWelcomePrompt: (() -> Void)? { get set }
    var loading: Bool { get }
    
    func wakeup()
    func sleep()
    func login()
    func signup()
    
    
}

protocol KeyValueStore {
    func bool(forKey: String) -> Bool
    mutating func set(_ value: Bool, forKey: String)
}

class DefaultLoginViewModel: LoginViewModel {
    struct Constants {
        static let WelcomePromptDisplayedKey = "WelcomePromptDisplayedKey"
    }
    
    var showWelcomePrompt: (() -> Void)?
    var viewModelDidUpdate: (() -> Void)?
    
    var loading: Bool = false {
        didSet {
            viewModelDidUpdate?()
        }
    }
    
    private var keyValueStore: KeyValueStore
    init(keyValueStore: KeyValueStore) {
        self.keyValueStore = keyValueStore
    }
    
    func wakeup() {
        let previouslyDisplayed = keyValueStore.bool(forKey: Constants.WelcomePromptDisplayedKey)
        if (!previouslyDisplayed) {
            showWelcomePrompt?()
            keyValueStore.set(true, forKey: Constants.WelcomePromptDisplayedKey)
        }
    }
    
    func sleep() {
        
    }
    
    func login() {
        loading = true
    }
    
    func signup() {
        
    }
    
}

extension UserDefaults: KeyValueStore {
    
}

class TestingLoginViewModel: LoginViewModel {
    var showWelcomePrompt: (() -> Void)? = nil
    var viewModelDidUpdate: (() -> Void)?
    
    var loading: Bool = false {
        didSet {
            viewModelDidUpdate?()
        }
    }
    
    let beeper: Beeper = DarwinNotificationCenterBeeper()
    
    init() {
        beeper.registerBeepHandler(identifier: BeeperConstants.TriggerWelcomePrompt) { [unowned self] in
            self.showWelcomePrompt?()
        }
    }
    
    func wakeup() {
        
    }
    
    func sleep() {
        
    }
    
    func login() {
        loading = true
    }
    
    func signup() {
        
    }
}
