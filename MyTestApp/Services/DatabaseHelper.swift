//
//  DatabaseHelper.swift
//  MyTestApp
//
//  Created by Joe Kletz on 09/10/2020.
//

import UIKit
import CoreData

class DatabaseHelper {
    public static let shared = DatabaseHelper()
    private init(){}
    
    
    func getVideosForBook(bookID:String, completion : @escaping (Set<VideoMO>)->Void) {
        let fetch = NSFetchRequest<Book>(entityName: "Book")
        fetch.predicate = NSPredicate(format: "id == %@", bookID)
        
        DispatchQueue.main.async {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let book : Book = try! context.fetch(fetch).first! as Book
            
            let videos = book.videos as? Set<VideoMO>
            
            completion(videos!)
        }
    }
    
    func createVideoMO(bookID:String,videoFileName:String, videoURL:URL, completion : @escaping () -> Void) {
        
        let fetch = NSFetchRequest<Book>(entityName: "Book")
        fetch.predicate = NSPredicate(format: "id == %@", bookID)
        
        
        videoURL.imageFromVideoURL(at: 1) { (imageData) in
            DispatchQueue.main.async {
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let context = appDelegate.persistentContainer.viewContext
                
                let book : Book = try! context.fetch(fetch).first! as Book
                
                let video = VideoMO(context: context)
                video.filename = videoFileName
                
                if let data = imageData{
                    video.thumbnail = data
                }
                
                book.addToVideos(video)
                
                try! context.save()
                
                print("VIDEO SAVED TO BOOK \(book.title)")
                
                completion()
            }
        }
        
        
       
    }
    
    func browseDocuments() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

            // Print the urls of the files contained in the documents directory
            print(directoryContents)
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = false ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
