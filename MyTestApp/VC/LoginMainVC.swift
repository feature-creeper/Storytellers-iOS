//
//  LoginMainVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 11/11/2020.
//

import UIKit

class LoginMainVC: UIViewController {
    
    let mainImageView : MainImagesView = {
        let v = MainImagesView(frame: CGRect.zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let loginButton : GradientButton = {
        let v = GradientButton()
//        v.setTitle("Login", for: .normal)
        v.title = "Login"
        v.colors = [#colorLiteral(red: 0.0862745098, green: 1, blue: 0.7960784314, alpha: 1).cgColor,#colorLiteral(red: 0.07397184521, green: 0.4660721421, blue: 0.9371407628, alpha: 1).cgColor]
        
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .systemTeal
        v.addTarget(self, action: #selector(tappedLogin), for: .touchUpInside)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 25)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.layer.cornerRadius = 10
        
        return v
    }()
    
    let signupButton : GradientButton = {
        let v = GradientButton()
//        v.setTitle("Signup", for: .normal)
        
        v.title = "Signup"
        v.colors = [#colorLiteral(red: 1, green: 0.4431372549, blue: 0.1176470588, alpha: 1).cgColor,#colorLiteral(red: 0.8941176471, green: 0.1333333333, blue: 0.9215686275, alpha: 1).cgColor]
        
        v.setTitleColor(.white, for: .normal)
        v.addTarget(self, action: #selector(tappedSignup), for: .touchUpInside)
        v.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.2352941176, blue: 1, alpha: 1)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 25)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.layer.cornerRadius = 10
        return v
    }()
    
    let buttonsStack : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 10
        v.distribution = .fillEqually
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        view.addSubview(buttonsStack)
        
        buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        buttonsStack.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        buttonsStack.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        buttonsStack.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        buttonsStack.addArrangedSubview(loginButton)
        buttonsStack.addArrangedSubview(signupButton)
        
        view.addSubview(mainImageView)
        
        mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6588235294, blue: 1, alpha: 1)
        self.view = v
    }
    
    @objc
    func tappedLogin(){
        let vc = LoginVC()
        self.present(vc, animated: true)
    }
    
    @objc
    func tappedSignup(){
        let vc = EmailSignupVC()
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}


internal class MainImagesView: UIImageView {
    
    let bookImage : UIImageView = {
       let v = UIImageView(image: UIImage(named: "OpenBook"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let logoImage : UIImageView = {
       let v = UIImageView(image: UIImage(named: "CircleLogo"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let beeLady : UIImageView = {
       let v = UIImageView(image: UIImage(named: "BeeLady"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let witchGirl : UIImageView = {
       let v = UIImageView(image: UIImage(named: "WitchGirl"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()

    let superBoy : UIImageView = {
       let v = UIImageView(image: UIImage(named: "SuperBoy"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let mummy : UIImageView = {
       let v = UIImageView(image: UIImage(named: "Mummy"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let superDad : UIImageView = {
       let v = UIImageView(image: UIImage(named: "SuperDad"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let skeleton : UIImageView = {
       let v = UIImageView(image: UIImage(named: "Skeleton"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(bookImage)
        addSubview(logoImage)
        addSubview(beeLady)
        addSubview(superDad)
        addSubview(witchGirl)
        addSubview(superBoy)
        addSubview(mummy)
        addSubview(skeleton)
        
        let offset = UIScreen.main.bounds.width/4
        
        bookImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bookImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bookImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        logoImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        logoImage.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
        logoImage.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        beeLady.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        beeLady.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -offset - 30).isActive = true
        beeLady.widthAnchor.constraint(equalToConstant: 160).isActive = true
        beeLady.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        superDad.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        superDad.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset + 45).isActive = true
        superDad.widthAnchor.constraint(equalToConstant: 140).isActive = true
        superDad.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        skeleton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -110).isActive = true
        skeleton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: 15).isActive = true
        skeleton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        skeleton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        witchGirl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
        witchGirl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -offset - 30).isActive = true
        witchGirl.widthAnchor.constraint(equalToConstant: 120).isActive = true
        witchGirl.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        superBoy.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        superBoy.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 40).isActive = true
        superBoy.widthAnchor.constraint(equalToConstant: 160).isActive = true
        superBoy.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        mummy.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mummy.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset).isActive = true
        mummy.widthAnchor.constraint(equalToConstant: 140).isActive = true
        mummy.heightAnchor.constraint(equalToConstant: 140).isActive = true
//        
//        UIView.animate(withDuration: 3, delay: 0, options: [.autoreverse, .repeat]) {
//            self.beeLady.transform = CGAffineTransform(rotationAngle: 50)
//        }
//        UIView.animate(withDuration: 3, delay: 0, options: [.autoreverse, .repeat]) {
//            self.superDad.transform = CGAffineTransform(rotationAngle: .pi/9)
//        }
        
        UIView.animate(withDuration: 3, delay: 0, options: [.autoreverse, .repeat]) {
            self.mummy.transform = CGAffineTransform(rotationAngle: 50)
        }
        
        UIView.animate(withDuration: 4, delay: 0, options: [.autoreverse, .repeat]) {
            self.witchGirl.transform = CGAffineTransform(translationX: 30, y: 40)
        }
        
        UIView.animate(withDuration: 3.5, delay: 0, options: [.autoreverse, .repeat]) {
            self.superBoy.transform = CGAffineTransform(translationX: 0, y: 30)
            self.superBoy.transform = CGAffineTransform(rotationAngle: .pi/11)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal class GradientButton : UIButton{
    
    var title : String?
    var colors : [Any]?
    
    override func layoutSubviews() {
        
        layer.masksToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = layer.bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
        let text = CATextLayer()
        text.font = UIFont(name: Globals.semiboldWeight, size: 20)
        text.frame = bounds
        text.string = title
        text.alignmentMode = .center
        text.fontSize = 25
        text.anchorPoint = CGPoint(x: 0.5,y: 0.3)
//        text.foregroundColor = UIColor.white.cgColor
        layer.insertSublayer(text, at: 1)
    }
}
