//
//  InputView.swift
//  MyMovies
//
//  Created by Aleksandr on 08.05.2023.
//

import UIKit

class InputView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var inputWrapperView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("InputView", owner: self, options: nil)
        contentView.fixInView(self)
        inputTextField.delegate = self
        configure()
    }
    
    func getValue() -> String {
        
        return self.inputTextField.text ?? ""
    }
    
    func setPlaceholder(_ text: String) {
        
        self.inputTextField.placeholder = text
        self.inputTextField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)]
        )
    }
    
    func clearFocus() {
        
        self.inputTextField.resignFirstResponder()
    }
    
    @IBAction func inputEditingDidBegin(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.inputWrapperView.backgroundColor = UIColor(red: 47/255, green: 90/255, blue: 106/255, alpha: 1)
            self.inputWrapperView.layer.borderColor = UIColor.white.cgColor
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func inputEditingDidEnd(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.inputWrapperView.backgroundColor = .clear
            self.inputWrapperView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
            self.layoutIfNeeded()
        }
    }
    
    private func configure() {
        
        inputWrapperView.layer.cornerRadius = Config.authWindowInputAndButtonCornerRadius
        inputWrapperView.backgroundColor = .clear
        inputWrapperView.layer.borderWidth = 1
        inputWrapperView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        
        inputTextField.borderStyle = .none
        inputTextField.backgroundColor = .clear
        inputTextField.tintColor = .white.withAlphaComponent(0.5)
        inputTextField.textColor = .white
    }
}

extension InputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
}
