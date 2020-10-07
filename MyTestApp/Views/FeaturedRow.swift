//
//  FeaturedRow.swift
//  MyTestApp
//
//  Created by Joe Kletz on 07/10/2020.
//

import Foundation
import UIKit


//class FeaturedTableCell: UITableViewCell {
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    }
//
//    func addCollectionView(delegate:SomeProtocol) {
//        let featuredBooks = FeaturedBooksView(withDelegate: delegate,frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
//
//        contentView.addSubview(featuredBooks)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class FeaturedBooksCell: UITableViewCell {
    
    var delegate:SomeProtocol?
    
    var col : UICollectionView!
    
    let bookDetailVC : UIViewController = {
        return BookDetailVC()
    }()
    
    
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        }
    
    
    
    
    func initialise(){
      
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        col = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100), collectionViewLayout: layout)
        
        //let col = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: layout)
        col.backgroundColor = UIColor.white
        col.dataSource = self
        col.delegate = self
        col.showsHorizontalScrollIndicator = false
        col.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        
        addSubview(col)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeaturedBooksCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("TAPPED \(indexPath)")
        delegate?.someTypeMethod()
        //vc.present(bookDetailVC, animated: true)
    }
}

extension FeaturedBooksCell : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 30, height: 20)
    }
    
    
}


class MyCell: UICollectionViewCell {
    
    private let bg : UIView = {
        let i = UIView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.backgroundColor = #colorLiteral(red: 0.271484375, green: 0.4428498745, blue: 1, alpha: 1)
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        //Adding constraint old, active constraints auto adds to right subviw -- bg.addConstraint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
