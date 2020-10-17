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
            titleLabel.text = book?.title
            authorLabel.text = book?.author
            descriptionLabel.text = book?.description
            
            if let readtime = book?.readtime {
                readtimeLabel.attributedText = getTimeString(readtime: readtime)
            }
            
            setCoverImage()
        }
    }
    
    var scrollView: UIScrollView!
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Heebo-Bold", size: 40)
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Heebo-Medium", size: 28)
        return label
    }()
    
    var readtimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Heebo-Medium", size: 22)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Heebo-Regular", size: 19)
        return label
    }()
    
    var spinner = LoadingView(title: "Downloading your\nnew book")
    
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

    
    var backButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        
        let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        button.applyShadow(offset: CGSize(width: 1, height: 1), opacity: 0.3, radius: 4.0)
        
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

        self.scrollView.addSubview(titleLabel)
        
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
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        
        spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spinner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        spinner.isHidden = true
        
    }
    

    func setViewConstraints() {
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
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
            self.contentStack.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
            self.contentStack.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor),
            self.contentStack.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 300)
        ])
        
        contentStack.spacing = 8
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(authorLabel)
        contentStack.addArrangedSubview(readtimeLabel)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(buyButton)
        
        contentStack.setCustomSpacing(40, after: descriptionLabel)
        
        scrollView.bottomAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 30).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spinner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func getTimeString(readtime:String) -> NSMutableAttributedString{
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "stopwatch.fill")

        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " " + readtime))
        return fullString
    }
    
    @objc
    func tappedGetBook(){
        spinner.isHidden = false
        viewModel.getBookContent()
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
