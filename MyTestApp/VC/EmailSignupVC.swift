//
//  EmailSignupVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 25/10/2020.
//

import UIKit
import FirebaseAuth

class EmailSignupVC: UIViewController {
    
    let bottomStackView : UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        return v
    }()
    
    let signupButton : UIButton = {
        let v = UIButton()
        v.setTitle("Sign me up!", for: .normal)
        v.backgroundColor = .red
        v.addTarget(self, action: #selector(tappedSignup), for: .touchUpInside)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.layer.cornerRadius = 10
        return v
    }()
    
    let emailTextField : TextField = {
        let v = TextField()
        v.autocapitalizationType = .none
        v.returnKeyType = .done
        v.placeholder = "Enter email"
        v.font = UIFont(name: "Rubik-Regular", size: 20)
        v.backgroundColor = .systemGray6
        return v
    }()
    
    let passwordTextField : TextField = {
        let v = TextField()
        v.returnKeyType = .done
        v.placeholder = "Enter password"
        v.font = UIFont(name: "Rubik-Regular", size: 20)
        v.backgroundColor = .systemGray6
        v.isSecureTextEntry = true
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        self.view = v
    }
    
    func setupViews() {
        view.addSubview(bottomStackView)
        
        bottomStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bottomStackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor,constant: 10).isActive = true
        bottomStackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor,constant: -10).isActive = true
        
        
        bottomStackView.addArrangedSubview(emailTextField)
        bottomStackView.addArrangedSubview(passwordTextField)
        bottomStackView.addArrangedSubview(signupButton)
        
        bottomStackView.spacing = 10
        
        bottomStackView.setCustomSpacing(20, after: passwordTextField)
        
    }
    

    @objc
    func tappedSignup() {
        signup()
    }
    
    func signup() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        print("EMAIL: \(email)")
        print("PASSWORD: \(password)")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                
            }else{
                self.showDialogue(message: error!.localizedDescription, title:"Error")
            }
        }
    }
}
