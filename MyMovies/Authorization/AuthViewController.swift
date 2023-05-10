//
//  AuthViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 07.05.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginInputView: InputView!
    @IBOutlet weak var passwordInputView: InputView!
    
    @IBOutlet weak var backroundImageView: UIImageView!
    
    @IBOutlet weak var authFormView: UIView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var bottomSignInButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        registerForKeyboardNotifications()
        
        AuthService.delegate = self
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        let login = loginInputView.getValue()
        let password = passwordInputView.getValue()
        
        if (login.count < 3) || (password.count < 3) {
            // show message for short login or password and return
            return
        }
        
        if self.stopInterface { return }
        self.stopInterface = true
        
        loginInputView.clearFocus()
        passwordInputView.clearFocus()
        
        
        AuthService.singIn(login: login, password: password)
    }
    
    
    // MARK: private zone
    
    private var stopInterface = false
    
    private func configure() {
        
        signInButton.layer.cornerRadius = Config.authWindowInputAndButtonCornerRadius
        
        passwordInputView.inputTextField.isSecureTextEntry = true
        
        let imgName: String = "s" + String(Int.random(in: 0...11))
        backroundImageView.image = UIImage(named: imgName)
        
        let layer = CAGradientLayer();
        layer.frame = authFormView.bounds
        layer.colors = [UIColor.clear.cgColor, Colors.base.cgColor]
        layer.locations = [0.2, 0.7]
        authFormView.layer.insertSublayer(layer, at: 0)
        
        loginInputView.setPlaceholder("login")
        passwordInputView.setPlaceholder("password")
    }
    
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let height = keyboardFrame.cgRectValue.height + 8
        
        UIView.animate(withDuration: 0.5) {
            self.bottomSignInButtonConstraint.constant = height
            self.authFormView.backgroundColor = Colors.base.withAlphaComponent(0.8)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide   () {
        
        UIView.animate(withDuration: 0.5) {
            self.bottomSignInButtonConstraint.constant = 8
            self.authFormView.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }
        
    }
}

extension AuthViewController: AuthServiceSuccessAndErrorProtocol {
    func onSuccess(_ sessionID: String) {
        print("signIn successed, sessionID: \(sessionID)")
        self.stopInterface = false
        self.view.removeFromSuperview()
    }
    
    func onError(_ authError: AuthError) {
        // show error auth message
        print("Error: \(authError.description)")
        self.stopInterface = false
    }
}
