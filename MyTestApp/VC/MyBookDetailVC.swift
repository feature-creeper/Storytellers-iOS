//
//  MyBookDetailVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import UIKit
import AVKit

class MyBookDetailVC: UIViewController {

    var book : Book? {
        didSet{
            titleLabel.text = book?.title
            authorLabel.text = book?.author
            if let title = book?.title {
                self.title = title
                coverImageView.setImage(fromCoreDataNamed: title.replacingOccurrences(of: " ", with: "_"))
            }
            
            if let synopsis = book?.synopsis {
                self.aboutContentsLabel.text = synopsis
            }
            
            ageLabel.attributedText = getAgeString(age: "4+")
            durationLabel.attributedText = getDurationString(duration: "15 minutes")
            
            
        }
    }
    
    var videos : [VideoMO] = []
    
    var videoHeight : CGFloat = 0
    var videosHeightConstraint: NSLayoutConstraint?
    
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
    
    let lowerDetailsStack : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .leading
        return v
    }()
    
    let ageLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.semiboldWeight, size: 16)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.textColor = .gray
        return v
    }()
    
    let durationLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.semiboldWeight, size: 16)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.textColor = .gray
        return v
    }()
    
    let titleLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.semiboldWeight, size: 30)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        return v
    }()
    
    let authorLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.mediumWeight, size: 24)
        v.textAlignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let myVideosLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.mediumWeight, size: 20)
        v.textColor = .black
        v.text = "My videos"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let aboutLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.mediumWeight, size: 20)
        v.textColor = .black
        v.text = "About"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let aboutContentsLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.regularWeight, size: 18)
        v.textColor = .black
        v.numberOfLines = 0
        v.lineBreakMode = .byWordWrapping
        v.text = "About"
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var copyrightButton : UIButton = {
        let v = UIButton()
        v.setTitleColor(UIColor.systemBlue, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 18)
        v.addTarget(self, action: #selector(copyrightTapped), for: .touchUpInside)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.forward")?.withTintColor(.systemBlue)
        let fullString = NSMutableAttributedString(string: "Copyright ")
        fullString.append(NSAttributedString(attachment: imageAttachment))

        v.setAttributedTitle(fullString, for: .normal)
        
        v.contentEdgeInsets = UIEdgeInsets(top: 25, left: 0, bottom: 15, right: 10)
        return v
    }()
    
    let readButton : UIButton = {
        let v = UIButton()
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 25)
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
        DatabaseHelper.shared.getVideosForBook(bookID: (book?.id)!) { [self] (videos) in
            var tempVideos : [VideoMO] = []
            for video in videos {
                tempVideos.append(video)
            }
            tempVideos.sort{$0.added! > $1.added!}
            self.videos = tempVideos
            
            if self.videos.count > 0 {
                videosHeightConstraint?.constant = 150
                videosHeightConstraint?.isActive = true
                myVideosLabel.text = "My videos"
                myVideosLabel.textColor = .black
                self.view.layoutIfNeeded()
            } else{
                myVideosLabel.text = "No videos yet"
                myVideosLabel.textColor = .systemGray4
            }
            
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
        scrollView.addSubview(myVideosLabel)
        scrollView.addSubview(myVideosCollectionView)
        scrollView.addSubview(lowerDetailsStack)
        
        topDetailsStack.addArrangedSubview(titleLabel)
        topDetailsStack.addArrangedSubview(authorLabel)
        topDetailsStack.addArrangedSubview(ageLabel)
        topDetailsStack.addArrangedSubview(durationLabel)
        topDetailsStack.addArrangedSubview(readButton)

        lowerDetailsStack.addArrangedSubview(aboutLabel)
        lowerDetailsStack.addArrangedSubview(aboutContentsLabel)
        lowerDetailsStack.addArrangedSubview(copyrightButton)
        
        topDetailsStack.alignment = .center
        
        topDetailsStack.setCustomSpacing(14, after: authorLabel)
        topDetailsStack.setCustomSpacing(20, after: durationLabel)
        topDetailsStack.setCustomSpacing(25, after: readButton)

        readButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        
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
        
        myVideosLabel.topAnchor.constraint(equalTo: topDetailsStack.bottomAnchor, constant: 25).isActive = true
        myVideosLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        myVideosLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        //myVideosLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        myVideosCollectionView.topAnchor.constraint(equalTo: myVideosLabel.bottomAnchor, constant: 15).isActive = true
        myVideosCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myVideosCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        videosHeightConstraint = NSLayoutConstraint(item: myVideosCollectionView, attribute: .height, relatedBy: .equal, toItem: myVideosCollectionView, attribute: .height, multiplier: 0, constant: 0)
        videosHeightConstraint?.isActive = true
        
        lowerDetailsStack.topAnchor.constraint(equalTo: myVideosCollectionView.bottomAnchor, constant: 20).isActive = true
        lowerDetailsStack.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor).isActive = true
        lowerDetailsStack.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: lowerDetailsStack.bottomAnchor, constant: 50).isActive = true
    }
    
    @objc
    func copyrightTapped() {
        let vc = PrivacyVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func tappedRead() {
        
        let vc = DeepARVC(nibName: nil, bundle: nil)
        
        guard let effects = book?.effects else {return}
        
        let effectSequence : [[String:Any]] = effects.getEffectSequenceArray()
        
        
        var imageSequence : [[String:Any]] = []
        
        if let images = book?.images {
            imageSequence = images.getEffectSequenceArray()
        }
        
        
        
        if let content = book?.content {
            vc.content = content
            let story = DeepARVM(rawString: content)
            story.delegate = vc
            story.effects = effectSequence
            story.flats = imageSequence
            vc.storyVM = story
        }

        if let id = book?.id {
            vc.bookID = id
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func playVideo(videoURL:URL) {
        let player = AVPlayer(url: videoURL)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    func tappedShare(videoURL:URL) {
        //guard let data = URL(string: "https://www.zoho.com") else { return }
        let av = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func showActionSheet(index:Int) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let videoURL = documentsDirectory.appendingPathComponent(self.videos[index].filename!)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

         alert.addAction(UIAlertAction(title: "Play", style: .default , handler:{ (UIAlertAction)in
            
            self.playVideo(videoURL: videoURL)
         }))

        alert.addAction(UIAlertAction(title: "Share", style: .default , handler:{ [self] (UIAlertAction)in
             tappedShare(videoURL: videoURL)
         }))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ [self] (UIAlertAction)in
             print("User click Delete button")
            book?.removeFromVideos(videos[index])
            videos.remove(at: index)
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            try? context.save()
            
            
            myVideosCollectionView.reloadData()
         }))
        
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler:{ [self] (UIAlertAction)in
            

            print("User click Dismiss button")
        }))

         self.present(alert, animated: true, completion: {
             print("completion block")
         })
    }
    
    func getAgeString(age:String) -> NSMutableAttributedString{
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "person.fill")!.withTintColor(.gray)

        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " " + age))
        return fullString
    }
    
    func getDurationString(duration:String) -> NSMutableAttributedString{
        let timeAttachment = NSTextAttachment()
        timeAttachment.image = UIImage(systemName: "stopwatch.fill")?.withTintColor(.gray)
        

        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: timeAttachment))
        fullString.append(NSAttributedString(string: " " + duration))
        return fullString
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showActionSheet(index: indexPath.item)
    }
}


class MyVideoCell: UICollectionViewCell {
    
    var image : UIImage?
    {
        didSet{
            thumbnailImageView.image = image
            self.setNeedsDisplay()
        }
    }
    
    let thumbnailImageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    var mskView : UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemGray5
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.frame = contentView.frame
        thumbnailImageView.layer.position = CGPoint(x: thumbnailImageView.layer.position.x, y: thumbnailImageView.layer.position.y + 30)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
