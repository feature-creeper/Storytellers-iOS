//
//  MyBookDetailVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import UIKit

class MyBookDetailVC: UIViewController {

    var book : Book? {
        didSet{
            titleLabel.text = book?.title
            authorLabel.text = book?.author
            if let title = book?.title {
                self.title = title
                coverImageView.setImage(fromCoreDataNamed: title.replacingOccurrences(of: " ", with: "_"))
            }
            
            
        }
    }
    
    var videos : [VideoMO] = []
    
    let coverImageView : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    let scrollView : UIScrollView = {
        let v = UIScrollView()
        v.alwaysBounceVertical = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let topDetailsStack : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let titleLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "Heebo-Bold", size: 30)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let authorLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "Heebo-Medium", size: 20)

        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let myVideosLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "Heebo-Bold", size: 20)
        v.textColor = .gray
        v.text = "My videos"
        return v
    }()
    
    let readButton : UIButton = {
        let v = UIButton()
        v.titleLabel?.font = UIFont(name: "Heebo-Bold", size: 25)
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.setTitle("Let's read!", for: .normal)
        v.backgroundColor = .orange
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 9
        v.addTarget(self, action: #selector(tappedRead), for: .touchUpInside)
        return v
    }()
    
    let myVideosCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.showsHorizontalScrollIndicator = false
        collView.alwaysBounceHorizontal = true
        collView.backgroundColor = .white
        collView.register(MyVideoCell.self, forCellWithReuseIdentifier: "cell")
        return collView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        
        myVideosCollectionView.delegate = self
        myVideosCollectionView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.largeTitleDisplayMode = .never
        getVideos()

    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        view = v
    }
    
    func getVideos() {
        DatabaseHelper.shared.getVideosForBook(bookID: (book?.id)!) { (videos) in
            var tempVideos : [VideoMO] = []
            for video in videos {
                print("VIDEO FOUND: \(video.filename)")
                tempVideos.append(video)
            }
            self.videos = tempVideos
            
            self.myVideosCollectionView.reloadData()
        }
    }

    @objc
    func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(coverImageView)
        scrollView.addSubview(topDetailsStack)
        scrollView.addSubview(myVideosCollectionView)
        topDetailsStack.addArrangedSubview(titleLabel)
        topDetailsStack.addArrangedSubview(authorLabel)
        topDetailsStack.addArrangedSubview(readButton)
        topDetailsStack.addArrangedSubview(myVideosLabel)
        
        topDetailsStack.setCustomSpacing(40, after: authorLabel)
        topDetailsStack.setCustomSpacing(25, after: readButton)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        coverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25).isActive = true
        coverImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        topDetailsStack.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20).isActive = true
        topDetailsStack.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor).isActive = true
        topDetailsStack.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor).isActive = true
        
        myVideosCollectionView.topAnchor.constraint(equalTo: topDetailsStack.bottomAnchor, constant: 15).isActive = true
        myVideosCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myVideosCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myVideosCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
    }
    
    @objc
    func tappedRead() {
        
        let vc = DeepARVC(nibName: nil, bundle: nil)
        guard let effects = book?.effects?.getEffectArray() else {return}
        
        if let content = book?.content {
            vc.content = content
            let story = StoryText(rawString: content)
            story.delegate = vc
            vc.storyVM = story
        }
        
        if let id = book?.id {
            vc.bookID = id
        }
        
        vc.maskPath = effects.first
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension MyBookDetailVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyVideoCell
        if let data = videos[indexPath.item].thumbnail{
            cell.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
}

extension MyBookDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
}


class MyVideoCell: UICollectionViewCell {
    
    var image : UIImage?
    {
        didSet{
            
//            let imageLayer = CALayer()
//            contentView.layer.addSublayer(imageLayer)
//
//            imageLayer.contents = image?.cgImage
//            imageLayer.contentsGravity = .resizeAspectFill
//            imageLayer.cornerRadius = 10
            
            
            
//            imageLayer.contentsCenter = CGRect(x: 0.25, y: 0.25, width: 1, height: 0.5)
            thumbnailImageView.image = image
//            thumbnailImageView.layer.cornerRadius = 10
//            mskView.frame = thumbnailImageView.frame
            //thumbnailImageView.mask = mskView
            self.setNeedsDisplay()
        }
    }
    
    let thumbnailImageView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 9
        v.layer.masksToBounds = true
        
        return v
    }()
    
    var mskView : UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
//
//        mskView = UIView(frame: contentView.frame)
//
//        mskView.layer.cornerRadius = 10
//        backgroundColor = .gray
//        layer.backgroundColor = UIColor.red.cgColor
//        layer.cornerRadius = 9
//        contentView.clipsToBounds = true
//        contentView.layer.masksToBounds = true
        
//        mskView.frame = contentView.frame
//        contentView.addSubview(mskView)
        
        contentView.addSubview(thumbnailImageView)
//        thumbnailImageView.mask = mskView
        setupViews()
        
    }
    
    func setupViews() {
        
        thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        thumbnailImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
//        mskView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        mskView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        mskView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        mskView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
