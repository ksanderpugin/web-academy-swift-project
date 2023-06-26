//
//  ToastViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 11.05.2023.
//

import UIKit

class Toast {

    public static func show(message: String, viewControler: UIViewController, duration: Double) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        viewControler.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}
