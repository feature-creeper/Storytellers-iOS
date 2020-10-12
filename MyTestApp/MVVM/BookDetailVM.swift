//
//  BookDetailVM.swift
//  MyTestApp
//
//  Created by Joe Kletz on 11/10/2020.
//

import Foundation
import UIKit
import FirebaseStorage


protocol BookDetailDelegate {
    func receivedBook(book : BookInfo)
    func saved()
}

class BookDetailVM {
    
    var bookFeatured: BookFeatured?
    
    var bookInfo:BookInfo?
    
    var delegate : BookDetailDelegate?
    
    
    func getBookContent() {
        
        //Start Loading
        
        //Create a queue to execute all in serial - Perhaps QueueGroup?
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let book = Book(context: context)
        
        guard let title = bookInfo?.title else {return}
        
        book.author = bookInfo!.author
        book.cover = bookInfo!.cover
        book.title = title
        
        if let coverPath = bookInfo?.cover {
            saveImage(imagePath: coverPath, imageName: (title.replacingOccurrences(of: " ", with: "_")))
        }
        
        
        if let id = bookInfo?.id {
            API.sharedAPI.getBookContent(withBookId: id) { (content) in
                do{
                    let contentData = try JSONSerialization.data(withJSONObject: content, options: [])
                    let contentStringified = String(data: contentData, encoding: String.Encoding.utf8)
                    book.content = contentStringified
                    try context.save()
                    
                    
                } catch{
                    //Error
                }
            }
        }
    }
    
    func saveImage(imagePath:String, imageName : String) {
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
            print("Downloaded pic!")
          }
        }
    }
    
    func getBook() {
        
        guard let bookID = bookFeatured?.id else {return}
        API.sharedAPI.getFeaturedBook(withId: bookID) { (bookInfo) in

            self.delegate!.receivedBook(book: bookInfo)
            
            self.bookInfo = bookInfo
        }
    }
}
