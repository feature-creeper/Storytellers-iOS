//
//  ProfileVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import UIKit
import FirebaseAuth
import CoreData

class ProfileVC: UIViewController {
    
    var currentLanguage = "English"
    
    var myVideosButton : UIButton = {
        let v = UIButton()
//        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        
        let myVideos = "See all"
        let startString = "My Videos  "
        let totalString = startString + myVideos
        
        let fullString = NSMutableAttributedString(string: totalString)

        var startRange = (totalString as NSString).range(of: startString)
        var range = (totalString as NSString).range(of: myVideos)
        
        fullString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1) , range: range)
        fullString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Globals.semiboldWeight, size: 30), range: startRange)
        
        v.setAttributedTitle(fullString, for: .normal)
        
        v.addTarget(self, action: #selector(tappedAllVideos), for: .touchUpInside)
        
        v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return v
    }()
    
    var privacyButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.addTarget(self, action: #selector(tappedPrivacy), for: .touchUpInside)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")!.withTintColor(.gray)
        let fullString = NSMutableAttributedString(string: "Privacy ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        v.setAttributedTitle(fullString, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        v.setImage(UIImage(named: "PrivacyIcon"), for: .normal)
        v.imageView?.contentMode = .scaleAspectFit
        v.imageEdgeInsets = UIEdgeInsets(top: 10, left: -5, bottom: 10, right: 15)
        return v
    }()
    
    var childSafetyButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.addTarget(self, action: #selector(tappedPrivacy), for: .touchUpInside)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")!.withTintColor(.gray)
        let fullString = NSMutableAttributedString(string: "Child safety ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        v.setAttributedTitle(fullString, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        v.setImage(UIImage(named: "SafetyIcon"), for: .normal)
        v.imageView?.contentMode = .scaleAspectFit
        v.imageEdgeInsets = UIEdgeInsets(top: 10, left: -5, bottom: 10, right: 15)
        return v
    }()
    
    var contactButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.addTarget(self, action: #selector(tappedPrivacy), for: .touchUpInside)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")!.withTintColor(.gray)
        let fullString = NSMutableAttributedString(string: "Speak to us ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        v.setAttributedTitle(fullString, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        v.setImage(UIImage(named: "ContactIcon"), for: .normal)
        v.imageView?.contentMode = .scaleAspectFit
        v.imageEdgeInsets = UIEdgeInsets(top: 10, left: -5, bottom: 10, right: 15)
        return v
    }()
    
    var languageButton : UIButton = {
        let v = UIButton()
//        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        
        v.addTarget(self, action: #selector(tappedLanguage), for: .touchUpInside)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    var aStack : UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = 5
        v.alignment = .leading
        return v
    }()
    

    let profileImage : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "Portrait1"))
        return imageView
    }()
    
    
    let scroll : UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        view.addSubview(scroll)
        
        setupViews()
        
        setLanguageButton()

    }
    
    func setupViews(){
        scroll.addSubview(aStack)
        aStack.addSubview(profileImage)
        
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileImage.topAnchor.constraint(equalTo:scroll.topAnchor, constant: 20).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 180).isActive = true
       
        aStack.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        aStack.leftAnchor.constraint(equalTo: scroll.leftAnchor, constant: 10).isActive = true
        aStack.rightAnchor.constraint(equalTo: scroll.rightAnchor, constant: 10).isActive = true
        aStack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
        
        aStack.addArrangedSubview(languageButton)
        aStack.addArrangedSubview(privacyButton)
        aStack.addArrangedSubview(childSafetyButton)
        aStack.addArrangedSubview(contactButton)
        aStack.addArrangedSubview(myVideosButton)
        
        aStack.setCustomSpacing(20, after: contactButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        setProfileImage()
    }
    
    func setProfileImage() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
    }
    
    
    func setLanguageButton() {
        let totalString = "Language  \(currentLanguage)"
        
        let fullString = NSMutableAttributedString(string: totalString)
        var range = (totalString as NSString).range(of: currentLanguage)
        fullString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1) , range: range)
        
        languageButton.setAttributedTitle(fullString, for: .normal)
    }

    
    func setupNavBar() {
        let logout = UIBarButtonItem(image: UIImage(systemName: "arrow.right.square"), style: .plain, target: self, action: #selector(showLogoutDialogue))
        navigationItem.rightBarButtonItems = [logout]
        
        let help = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpTapped))
        navigationItem.leftBarButtonItems = [help]
    }
    
    @objc
    func showLogoutDialogue() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (alert) in
            logoutTapped()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true)
    }

    
    @objc
    func tappedLanguage() {
        let vc = LanguageSelectVC()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func tappedPrivacy() {
        let vc = PrivacyVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func tappedAllVideos() {
        let vc = AllMyVideosVC()
//        vc.delegate = self
//        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func logoutTapped(){
        try? Auth.auth().signOut()
    }
    
    @objc
    func helpTapped(){
        let vc = HelpVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func dismissTapped()  {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let authUI = delegate.authUI
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }

}

extension ProfileVC : LanguageDelegate{
    func selectedLanguage(language:String) {
        currentLanguage = language
        setLanguageButton()
    }
}
