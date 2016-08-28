//
//  LoginViewController.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Dependencies
    var viewModel: LoginViewModel?
    
    // MARK: UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bind to view model events
        //
        // best to use an FRP framework like RxSwift, SwiftBond etc...
        // for demo purposes a simple closure will suffice
        viewModel?.showWelcomePrompt = { [weak self] in
            let alert = UIAlertController(title: "Welcome", message: "Welcome to this awesome app!", preferredStyle: .Alert)
            
            let close = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
            alert.addAction(close)
            
            self?.showViewController(alert, sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.wakeup()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.sleep()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLogin(sender: UIButton) {
        viewModel?.login()
    }
    
    @IBAction func didTapSignUp(sender: UIButton) {
        viewModel?.signup()
    }
    
}
