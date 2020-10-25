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
        v.setTitleColor(.gray, for: .normal)
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
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")
        let fullString = NSMutableAttributedString(string: "Privacy ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        v.setAttributedTitle(fullString, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    var childSafetyButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")
        let fullString = NSMutableAttributedString(string: "Child safety ")
        fullString.append(NSAttributedString(attachment: imageAttachment))

        v.setAttributedTitle(fullString, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    var contactButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")
        let fullString = NSMutableAttributedString(string: "Speak to us ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        v.setAttributedTitle(fullString, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    var languageButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        
//        let language = "English"

        v.addTarget(self, action: #selector(tappedLanguage), for: .touchUpInside)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    var aStack : UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = 10
        v.alignment = .leading
        return v
    }()
    
    var circleView : CircleView = {
        let v = CircleView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = v.bounds.width / 2
        return v
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
        aStack.addSubview(circleView)
        
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        circleView.topAnchor.constraint(equalTo:scroll.topAnchor, constant: 20).isActive = true
        circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 100).isActive = true
       
        aStack.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 20).isActive = true
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
    
    
    func setLanguageButton() {
        let totalString = "Language  \(currentLanguage)"
        
        let fullString = NSMutableAttributedString(string: totalString)
        var range = (totalString as NSString).range(of: currentLanguage)
        fullString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1) , range: range)
        
        languageButton.setAttributedTitle(fullString, for: .normal)
    }

    
    func setupNavBar() {
        let logout = UIBarButtonItem(image: UIImage(systemName: "arrow.right.square"), style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItems = [logout]
        
        let help = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpTapped))
        navigationItem.leftBarButtonItems = [help]
    }
    
    

    
    @objc
    func tappedLanguage() {
        let vc = LanguageSelectVC()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func tappedAllVideos() {
        let vc = AllMyVideosVC()
//        vc.delegate = self
//        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
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


/// A special UIView displayed as a ring of color
class CircleView: UIView {
    override func draw(_ rect: CGRect) {
        drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView() -> () {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1 // your desired value
            
        let circlePath = UIBezierPath(
                arcCenter: CGPoint(x:halfSize,y:halfSize),
                radius: CGFloat( halfSize - (desiredLineWidth/2) ),
                startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.orange.cgColor
//        shapeLayer.strokeColor = UIColor.orange.cgColor
//        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}

