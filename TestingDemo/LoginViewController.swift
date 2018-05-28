//
//  LoginViewController.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // MARK: Dependencies
    var viewModel: LoginViewModel!
    
    // MARK: UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bind to view model events
        //
        // best to use an FRP framework like RxSwift, SwiftBond etc...
        // for demo purposes a simple closure will suffice
        viewModel.showWelcomePrompt = { [weak self] in
            self?.displayWelcomePrompt()
        }
        
        viewModel.viewModelDidUpdate = { [weak self] in
            self?.updateUI()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.wakeup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.sleep()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        viewModel.login()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func didTapSignup(_ sender: UIButton) {
        viewModel.signup()
    }
    
    // MARK: -
    
    func updateUI() {
        if viewModel.loading {
            showLoadingView()
        } else {
            hideLoadingView()
        }
    }
    
    func showLoadingView() {
        loadingView.frame = view.bounds
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    func displayWelcomePrompt() {
        let close = UIAlertAction(title: "Close",
                                  style: .cancel,
                                  handler: nil)
        
        let alert = UIAlertController(title: "Welcome",
                                      message: "Welcome to this awesome app!",
                                      preferredStyle: .alert)
        alert.addAction(close)
        
        show(alert, sender: self)
    }
}
