//
//  LoginVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 20/10/2020.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import GoogleUtilities

class LoginVC: UIViewController {
    
    let bottomStackView : UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        //        v.backgroundColor = .brown
        return v
    }()
    
    let logoImageView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = #imageLiteral(resourceName: "Logo Purple")
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    let emailLoginButton : UIButton = {
        let v = UIButton()
        v.setTitle("Login ", for: .normal)
        v.backgroundColor = .blue
        v.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.layer.cornerRadius = 10
        return v
    }()
    
    
    
    let FacebookLoginButton : UIButton = {
        let v = UIButton()
        v.setTitle("Continue with Facebook", for: .normal)
        v.backgroundColor = #colorLiteral(red: 0.07319874316, green: 0.4660471082, blue: 0.9370654821, alpha: 1)
        v.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.layer.cornerRadius = 10
        return v
    }()
    
    let googleLoginButton : UIButton = {
        let v = UIButton()
//        v.style = .iconOnly
        
        v.setTitle("Continue with Google", for: .normal)
        v.backgroundColor = .red
        v.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
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
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uidelegate

        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(bottomStackView)
        
        bottomStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bottomStackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor,constant: 10).isActive = true
        bottomStackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor,constant: -10).isActive = true
        
        bottomStackView.addArrangedSubview(logoImageView)
        bottomStackView.addArrangedSubview(emailTextField)
        bottomStackView.addArrangedSubview(passwordTextField)
        bottomStackView.addArrangedSubview(emailLoginButton)
        bottomStackView.addArrangedSubview(FacebookLoginButton)
        bottomStackView.addArrangedSubview(googleLoginButton)
        
        bottomStackView.spacing = 10
        
        bottomStackView.setCustomSpacing(20, after: passwordTextField)
        bottomStackView.setCustomSpacing(45, after: logoImageView)
        bottomStackView.setCustomSpacing(30, after: emailLoginButton)
        
        logoImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    //    func showDialogue(message:String) {
    //        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    //        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    //
    //        self.present(alert, animated: true)
    //    }
    
    
    //poop123
    @objc
    func signInWithEmail() {
        
        guard let email = emailTextField.text else {
            //Show dialogue
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: "poop123") { [weak self] authResult, error in
            
            if error == nil{
                //self!.goToTabBar()
            }else{
                self!.showDialogue(message: error!.localizedDescription, title: "Error")
            }
            
        }
    }
    
    @objc
    func signInWithGoogle() {
        print("TAPPING GOOGLE")
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc
    func tappedLogin() {
        
        signInWithEmail()
    }
    
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        self.view = v
    }
    
    
}

extension LoginVC :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension LoginVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
            }
        }
    }
}

//extension LoginVC : GIDSignInUIDelegate{
//    
//}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    override func willMove(toSuperview newSuperview: UIView?) {
        layer.cornerRadius = 10
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
