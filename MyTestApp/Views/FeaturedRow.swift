//
//  FeaturedRow.swift
//  MyTestApp
//
//  Created by Joe Kletz on 07/10/2020.
//

import Foundation
import UIKit
import FirebaseStorage
import SDWebImage



class FeaturedBooksCell: UITableViewCell {
    
    var delegate:SomeProtocol?
    
    var col : UICollectionView!
    
    var books : [BookFeatured] = []
    
    var rowName : String!
    
    private let rowLabel : UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    let bookDetailVC : UIViewController = {
        return BookDetailVC()
    }()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        }
    
    
    func initialise(){
        
        
        addSubview(rowLabel)
        rowLabel.font = UIFont(name: "Rubik-SemiBold", size: 30)
        rowLabel.text = rowName
        rowLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rowLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant:  7).isActive = true
//        rowLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        rowLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
      
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        col = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        addSubview(col)
        col.translatesAutoresizingMaskIntoConstraints = false
        col.topAnchor.constraint(equalTo: rowLabel.bottomAnchor,constant: 4).isActive = true
        col.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        col.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        col.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        //let col = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: layout)
        col.backgroundColor = UIColor.white
        col.dataSource = self
        col.delegate = self
        col.showsHorizontalScrollIndicator = false
        col.alwaysBounceHorizontal = true
        col.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeaturedBooksCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.book = books[indexPath.item]
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("TAPPED \(indexPath)")
        delegate?.tappedBook(books[indexPath.item])//.tappedBook(books[indexPath.item])
        //vc.present(bookDetailVC, animated: true)
    }
}

extension FeaturedBooksCell : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //let width = 150
    return CGSize(width: 150 , height: collectionView.bounds.height)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    
}


class MyCell: UICollectionViewCell {
    
    private let bg : UIView = {
        let i = UIView()
        i.translatesAutoresizingMaskIntoConstraints = false
        
        return i
    }()
    
    
    private let coverImageView : UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.backgroundColor = .systemGray5
        return i
    }()
    
    private let bookTitleLabel : UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    private let authorLabel : UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    var book : BookFeatured?{
        didSet{
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
        contentView.addSubview(coverImageView)
        coverImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        coverImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        coverImageView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        coverImageView.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor).isActive = true
        coverImageView.layer.cornerRadius = 17
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        

        

        

    }
    
    func setupViews() {
        if let title = book?.title{
        contentView.addSubview(bookTitleLabel)
        bookTitleLabel.text  = title
        bookTitleLabel.font = UIFont(name: "Rubik-SemiBold", size: 19.0)
        bookTitleLabel.numberOfLines = 2
        bookTitleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor,constant: 6).isActive = true
        bookTitleLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        bookTitleLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        }
        
        if let author = book?.author {
            authorLabel.text = author
            authorLabel.font = UIFont(name: "Rubik-Regular", size: 15.0)
            contentView.addSubview(authorLabel)
            authorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: -3).isActive = true
            authorLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
            authorLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        }
        
        let storageRef = Storage.storage().reference()
        
        if let cover = book?.cover {
            let coverRef = storageRef.child(cover)
            coverRef.downloadURL { url, error in
              if let error = error {
                print(error.localizedDescription)
              } else {
                self.coverImageView.sd_setImage(with: url)
              }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
