//
//  LoginViewController.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 28.04.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var steamIDTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func nextViewButton() {
        if checkTextField(textField: steamIDTextField) {
            performSegue(withIdentifier: "profileSegue", sender: nil)
        }
    }
}

extension LoginViewController {
    private func checkTextField(textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == "" {
            return false
        } else { return true }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileVC = segue.destination as? ProfileViewController else { return }
        profileVC.steamID = steamIDTextField.text
    }
}

