//
//  BookDetailVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 07/10/2020.
//

import UIKit

class BookDetailVC: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    
    var label: UILabel!
    
    var headerContainerView: UIView!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        
        setViewConstraints()
        
        // ScrollView
//        scrollView.backgroundColor = UIColor.black
        
        // Label Customization
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        label.textColor = .white
        label.text = "YOUR TEXT HERE"
        
        // Set Image on the Header
        imageView.image = UIImage(named: "Llama")
        
        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)//addAction(#selector(tapped), for: .touchUpInside)
        //let closeImage = UIIMage(//UIImage(systemName: "arrow.backward.circle.fill")
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)

        
        
         let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        applyShadow(view: button)
        
//        self.largeBoldDoc.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
//        self.largeBoldDoc.layer.shadowOffset = CGSizeMake(0, 2.0f);
//        self.largeBoldDoc.layer.shadowOpacity = 1.0f;
//        self.largeBoldDoc.layer.shadowRadius = 0.0f;
//        self.largeBoldDoc.layer.masksToBounds = NO;
//        self.largeBoldDoc.layer.cornerRadius = 4.0f;
        
//        closeImage?.size = CGSize(width: 150, height: 150)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
//        button.backgroundColor = UIColor.blue
        
        view.addSubview(button)
    }
    
    @objc
    func dismissTapped()  {
        print("TAPPED")
        self.dismiss(animated: true, completion: nil)
    }


    func createViews() {
        // ScrollView
        scrollView = UIScrollView()
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        
        // Label
        label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        self.scrollView.addSubview(label)
        
        // Header Container
        headerContainerView = UIView()
        headerContainerView.backgroundColor = .gray
        self.scrollView.addSubview(headerContainerView)
        
        // ImageView for background
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        self.headerContainerView.addSubview(imageView)
    }
    

    func setViewConstraints() {
        // ScrollView Constraints
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // Label Constraints
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.label.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -10),
            self.label.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 280)
        ])

        // Header Container Constraints
        let headerContainerViewBottom : NSLayoutConstraint!
        
        self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        headerContainerViewBottom = self.headerContainerView.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -10)
        headerContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerContainerViewBottom.isActive = true

        // ImageView Constraints
        let imageViewTopConstraint: NSLayoutConstraint!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.headerContainerView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.headerContainerView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.headerContainerView.bottomAnchor)
        ])

        imageViewTopConstraint = self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
    }
    
    func applyShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4.0
    }
}
    
    
    
    /*
    
    var scrollView: UIScrollView!
    
    var headerContainerView: UIView!
    
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        scrollView.bounces = true
        
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)//addAction(#selector(tapped), for: .touchUpInside)
        //let closeImage = UIIMage(//UIImage(systemName: "arrow.backward.circle.fill")
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)

         let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        
//        closeImage?.size = CGSize(width: 150, height: 150)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
//        button.backgroundColor = UIColor.blue
        
        scrollView.addSubview(button)
        
        
        // Header Container
        headerContainerView = UIView()
        headerContainerView.backgroundColor = .gray
        self.scrollView.addSubview(headerContainerView)
        
        // ImageView for background
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFill
        self.headerContainerView.addSubview(imageView)
        
        setupViews()
    }
    
    @objc
    func dismissTapped()  {
        print("TAPPED")
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        let headerImageView = UIImageView()
        scrollView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -120).isActive = true
        let headerContainerViewBottom : NSLayoutConstraint!
        headerContainerViewBottom = self.headerContainerView.bottomAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: -10)
        headerContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerContainerViewBottom.isActive = true
        headerImageView.backgroundColor = #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1)
        
        
        // ImageView Constraints
        let imageViewTopConstraint: NSLayoutConstraint!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.headerContainerView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.headerContainerView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.headerContainerView.bottomAnchor)
        ])
        
        imageViewTopConstraint = self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalToSystemSpacingBelow: headerImageView.bottomAnchor, multiplier: 1).isActive = true
//        stack.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 1).isActive = true
        stack.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "Title"
        titleLabel.font = UIFont(name: "KohinoorTelugu-Medium", size: 35)
        
        let authorLabel = UILabel()
        view.addSubview(authorLabel)
        authorLabel.text = "Author"
        authorLabel.font = UIFont(name: "KohinoorTelugu-Medium", size: 20)
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(authorLabel)
        
    }

}
*/
