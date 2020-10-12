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
        buyButton.addTarget(self, action: #selector(browseDatabase), for: .touchUpInside)
        
        return buyButton
    }()
    
    var testButton : UIButton = {
        let buyButton = STButton(frame: CGRect(x: 0, y: 0, width: 400, height: 50),fontSize: 22)
        buyButton.backgroundColor = .systemGray4
        buyButton.setTitle("Create File", for: .normal)
        buyButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(createFileInDB), for: .touchUpInside)
        
        return buyButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.bookFeatured = bookFeatured
        
        createViews()
        
        setViewConstraints()
        
        // ScrollView
//        scrollView.backgroundColor = UIColor.black
        
        // Label Customization
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.numberOfLines = 0
        label.text = book?.title
        
        // Set Image on the Header
        //.image = UIImage(named: "Llama")
        
//        let storageRef = Storage.storage().reference()
        
//        if let cover = book?.cover {
//            let coverRef = storageRef.child(cover)
//            coverRef.downloadURL { [self] url, error in
//              if let error = error {
//                print(error.localizedDescription)
//              } else {
//                //self.coverImageView.sd_setImage(with: url)
//                imageView.sd_setImage(with: url, completed: nil)
//              }
//            }
//        }
        
        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)//addAction(#selector(tapped), for: .touchUpInside)
        //let closeImage = UIIMage(//UIImage(systemName: "arrow.backward.circle.fill")
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)

        
        
         let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        applyShadow(view: button)
        
//        closeImage?.size = CGSize(width: 150, height: 150)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
//        button.backgroundColor = UIColor.blue
        
        view.addSubview(button)
        
        
        
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
        contentStack.addArrangedSubview(testButton)
        contentStack.addArrangedSubview(buyButton)
        
        contentStack.setCustomSpacing(30.0, after: contentStack.subviews[0])
        contentStack.distribution = .fill
        
    }
    
    @objc
    func browseDatabase(){
        viewModel.getBookContent()
    }
    
    @objc
    func createFileInDB(){
//        DatabaseHelper.shared.addFile()
//        viewModel.save()
    }
    
    func applyShadow(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4.0
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
    func receivedBook(book: BookInfo) {
        
        self.book = book
    }
    
    func saved() {
        print("SAVED")

        }
        
}
    
