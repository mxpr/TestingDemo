//
//  AppDelegate.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func loginViewModel() -> LoginViewModel {
        let defaults = UserDefaults.standard
        let uiTesting = defaults.bool(forKey: "ui-testing")
        let useTestingViewModel = defaults.bool(forKey: "use-testing-view-model")
        
        if uiTesting && useTestingViewModel {
            return TestingLoginViewModel()
        }
        
        return DefaultLoginViewModel(keyValueStore: defaults)
    }
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        initialViewController.viewModel = loginViewModel()
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

