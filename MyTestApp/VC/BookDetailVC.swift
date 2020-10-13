//
//  BookDetailVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 07/10/2020.
//

import UIKit
import FirebaseStorage
import SDWebImage

class BookDetailVC: UIViewController, UIScrollViewDelegate {
    
    let viewModel = BookDetailVM()
    
    var bookFeatured : BookFeatured?
    
    var book:BookInfo? {
        didSet{
            label.text = book?.title
            
            setCoverImage()
        }
    }
    
    var scrollView: UIScrollView!
    
    var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var spinner = LoadingView()
    
    var headerContainerView: UIView!
    
    var imageView: UIImageView!
    
    var contentStack : UIStackView = {
       let i = UIStackView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.axis = .vertical
        return i
    }()
    
    var buyButton : UIButton = {
        let buyButton = STButton(frame: CGRect(x: 0, y: 0, width: 400, height: 50),fontSize: 22)
        buyButton.backgroundColor = .orange
        buyButton.setTitle("Get this book", for: .normal)
        buyButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(tappedGetBook), for: .touchUpInside)
        
        return buyButton
    }()
    
    var testButton : UIButton = {
        let buyButton = STButton(frame: CGRect(x: 0, y: 0, width: 400, height: 50),fontSize: 22)
        buyButton.backgroundColor = .systemGray4
        buyButton.setTitle("Look at docs", for: .normal)
        buyButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(lookAtDocs), for: .touchUpInside)
        
        return buyButton
    }()
    
    var backButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        
        let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        button.applyShadow()
        
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.bookFeatured = bookFeatured
        
        createViews()
        
        setViewConstraints()
        
        // Label Customization
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.numberOfLines = 0
        label.text = book?.title
        

        viewModel.getBook()
    }
    

    
    @objc
    func dismissTapped()  {
        
        self.dismiss(animated: true, completion: nil)
//        let vc = TestViewController()
//        self.present(vc, animated: true, completion: nil)
    }


    func createViews() {
        // ScrollView
        scrollView = UIScrollView()
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        
        // Label

        self.scrollView.addSubview(label)
        
        // Header Container
        headerContainerView = UIView()
        headerContainerView.backgroundColor = .gray
        self.scrollView.addSubview(headerContainerView)
        
        // ImageView for background
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        self.headerContainerView.addSubview(imageView)
        
        scrollView.addSubview(contentStack)
        
        view.addSubview(backButton)
        
        self.view.addSubview(spinner)
        
        spinner.isHidden = true
        
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
        

        // Header Container Constraints
        let headerContainerViewBottom : NSLayoutConstraint!
        
        self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        headerContainerViewBottom = self.headerContainerView.bottomAnchor.constraint(equalTo: self.contentStack.topAnchor, constant: -20)
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
        
        


        NSLayoutConstraint.activate([
            self.contentStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.contentStack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.contentStack.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 300)
        ])
        
        contentStack.spacing = 8
        
        contentStack.addArrangedSubview(label)
        contentStack.addArrangedSubview(buyButton)
        contentStack.addArrangedSubview(testButton)
        
        
        contentStack.setCustomSpacing(30.0, after: contentStack.subviews[0])
        contentStack.distribution = .fill
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spinner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc
    func tappedGetBook(){
        spinner.isHidden = false
        viewModel.getBookContent()
    }
    
    @objc
    func lookAtDocs(){
        DatabaseHelper.shared.browseDocuments()
    }
    
    fileprivate func setCoverImage() {
        let storageRef = Storage.storage().reference()
        
        if let cover = book?.cover {
            let coverRef = storageRef.child(cover)
            coverRef.downloadURL { [self] url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    //self.coverImageView.sd_setImage(with: url)
                    imageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }
}

extension BookDetailVC : BookDetailDelegate {
    
    func receivedBookInfo(book: BookInfo) {
        self.book = book
    }
    
    func saved() {
        print("SAVED")
    }
    
    func addedNewBookToMyBookshelf(){
        spinner.isHidden = true
    }
        
}
    
class LoadingView: UIView {
    
    var spinner : UIActivityIndicatorView = {
        let s = UIActivityIndicatorView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.color = .white
        s.style = .large
        s.startAnimating()
        return s
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 80).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
