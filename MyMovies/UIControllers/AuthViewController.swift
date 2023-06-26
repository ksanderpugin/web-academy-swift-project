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
    
    public var delegate: AuthCompleted?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        registerForKeyboardNotifications()
        
        NetworkManager.main.signInDelegate = self
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        self.login = loginInputView.getValue()
        self.password = passwordInputView.getValue()
        
        if (self.login.count < 3) || (self.password.count < 3) {
            Toast.show(message: "Pleace, entered correct login and password (minimum 3 symbols)", viewControler: self, duration: 3)
            return
        }
        
        if self.stopInterface { return }
        self.stopInterface = true
        
        loginInputView.clearFocus()
        passwordInputView.clearFocus()
        
        NetworkManager.main.signInRequest(login: self.login, password: self.password)
    }
    
    
    // MARK: private zone
    
    private var stopInterface = false
    private var login = ""
    private var password = ""
    
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

extension AuthViewController: SignInSuccessAndErrorDelegate {
    
    func onSuccess() {
        
        let alert = UIAlertController(title: nil, message: "Save sign in data on this device?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            
            UserSecurity.main.saveLoginAndPassword(login: self.login, password: self.password)
            self.view.removeFromSuperview()
            self.delegate?.showWindowForAuthUser()
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
            
            self.view.removeFromSuperview()
            self.delegate?.showWindowForAuthUser()
        })
        
        self.present(alert, animated: true)
        
        self.stopInterface = false
    }
    
    func onError(_ error: NetworkManagerError) {
        
        self.stopInterface = false
        
        if error.code == .loginOrPasswordError || error.code == .internetOrServerError {
            Toast.show(message: error.description, viewControler: self, duration: 3)
        } else {
            Toast.show(message: "Service temporarily unavailable, please try again later", viewControler: self, duration: 5)
        }
    }
}


protocol AuthCompleted {
    func showWindowForAuthUser()
}
