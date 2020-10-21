//
//  BookDetailVM.swift
//  MyTestApp
//
//  Created by Joe Kletz on 11/10/2020.
//

import Foundation
import UIKit
import FirebaseStorage
import CoreData


protocol BookDetailDelegate {
    func receivedBookInfo(book : BookInfo)
    func bookAlreadyOwned()
    func fetchingBook()
    func saved()
    func addedNewBookToMyBookshelf()
}

class BookDetailVM {
    
    var bookFeatured: BookFeatured?
    
    var bookInfo:BookInfo?{
        didSet{
            checkIfOwnedAlready()
        }
    }
    
    var delegate : BookDetailDelegate?
    
    var bookOwned = false
    
    func checkIfOwnedAlready() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let id = bookInfo?.id else {return}
        
        do {
            let fetch = NSFetchRequest<Book>(entityName: "Book")
            fetch.predicate = NSPredicate(format: "id == %@", id)
            let book : Book? = try (context.fetch(fetch).first ?? nil) as Book?
            
            
            if book != nil  {
                bookOwned = true
            }
            
        } catch  {
            
        }
    }
    
    func tappedGetBook(){
        if !bookOwned {
            delegate?.fetchingBook()
            getBookContent()
        }else{
            delegate?.bookAlreadyOwned()
        }
    }
    
    
    func getBookContent() {
        
        //Start Loading
        
        //Create a queue to execute all in serial - Perhaps QueueGroup?
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let book = Book(context: context)
        
        guard let title = bookInfo?.title else {return}
        
        book.author = bookInfo!.author
        book.cover = bookInfo!.cover
        book.title = title
        book.id = bookInfo?.id
        
        if let effects = bookInfo?.effects {
            book.effects = effects
            print(effects)
        }
        
        
        let dGroup = DispatchGroup()
        
        dGroup.enter()
        if let coverPath = bookInfo?.cover {
            saveImage(imagePath: coverPath, imageName: (title.replacingOccurrences(of: " ", with: "_"))) {
                dGroup.leave()
            }
        }
        
        dGroup.enter()
        if let id = bookInfo?.id {
            API.sharedAPI.getBookContent(withBookId: id) { (content) in
                
                print("content \(content)")
                
                
                do{
                    let contentData = try JSONSerialization.data(withJSONObject: content, options: [])
                    let contentStringified = String(data: contentData, encoding: String.Encoding.utf8)
                    book.content = contentStringified
                    dGroup.leave()
                } catch{
                    //Error
                }
            }
        }
        
        dGroup.enter()
        if let effects = book.effects {
            API.sharedAPI.saveEffectToDocuments(effectName: effects.getEffectArray().first!) {
                dGroup.leave()
            }
        }
        
        
        dGroup.notify( queue: DispatchQueue.main) { [self] in
            do {
                try context.save()
                delegate?.addedNewBookToMyBookshelf()
                
                DatabaseHelper.shared.browseDocuments()
                
            } catch  {
                
            }
        }
        
        
    }
    
    func saveImage(imagePath:String, imageName : String, completion: @escaping () -> Void) {
        let storageRef = Storage.storage().reference().child(imagePath)
        
        // Create local filesystem URL
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent(imageName).appendingPathExtension("png")
        
        // Download to the local filesystem
        let downloadTask = storageRef.write(toFile: documentsDirectory) { url, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print("Uh-oh, an error occurred!")
          } else {
            // Local file URL for "images/island.jpg" is returned
            
            completion()
            print("Downloaded pic!")
          }
        }
    }
    
    func getBook() {
        
        guard let bookID = bookFeatured?.id else {return}
        API.sharedAPI.getFeaturedBook(withId: bookID) { (bookInfo) in

            self.delegate!.receivedBookInfo(book: bookInfo)
            
            self.bookInfo = bookInfo
        }
    }
}
