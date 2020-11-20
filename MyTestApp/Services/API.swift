//
//  API.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import Foundation
import Firebase


enum FeaturedList : String {
    case featured, recently_added
}

class API {
    public static let sharedAPI = API()
    private init(){
        db = Firestore.firestore()
    }
    
    var db:Firestore!
    
    func getFeaturedBooks(featured:FeaturedList, completion: @escaping ([BookFeatured])->Void) {
        let docRef = db.collection(featured.rawValue)
        
        var books:[BookFeatured] = []
        
        docRef.getDocuments { (snap, error) in
            snap?.documents.forEach({ (document) in
                
                do{
                    var bookData = document.data()
                    if let date = bookData["added"] as? Timestamp {
                        date.dateValue()
                        bookData.removeValue(forKey: "added")
                        
                        let book = try BookFeatured(from: bookData)
                    
                        books.append(book)
                    }
                } catch{
                    
                }
                
            })
            
            completion(books)
        }
    }
    
    func getFeaturedBook(withId id: String, completion : @escaping (BookInfo)->Void) {
        let docRef = db.collection("books").document(id)
        
        docRef.getDocument { (snapshot, error) in
//            print("SNAPSHOT")
//            print(snapshot?.data())
            
            var _effects : String?
            if let effects = snapshot?.data()?["effects"]{
                do {
                    let e = effects as! [String]
                    _effects = e.joined(separator: ",")
                } catch  {
                    
                }
            }
            
            var _images : String?
            if let images = snapshot?.data()?["images"]{
                do {
                    let e = images as! [String]
                    _images = e.joined(separator: ",")
                } catch  {
                    
                }
            }

            
            var effectSequenceString = ""
            
            if let effectSequence = snapshot?.data()?["effect_sequence"]{
                do {
                    let e = effectSequence as! [[String:Any]]
                    
                    for item in e {
                        let jsonEncoder = JSONEncoder()
                        
                        let effectSeqData = try? JSONSerialization.data(withJSONObject: item, options: [])
                        if let data = effectSeqData {
                            let effect = String(data: data, encoding: .utf8)
                            
                            effectSequenceString.append(effect!)
                        }
                    }
                    
                } catch  {
                    
                }
            }
            
            
            do {
                let bookData = try JSONSerialization.data(withJSONObject: snapshot?.data(), options: [])
                
                let decoder = JSONDecoder()
                
                var bookInfo = try decoder.decode(BookInfo.self, from: bookData)
                bookInfo.id = snapshot?.documentID
                
                if let effects = _effects{
                    bookInfo.effects = effects
                }
                
                if let images = _images{
                    bookInfo.images = images
                }
                
                bookInfo.effectSequence = effectSequenceString
                
                completion(bookInfo)
            }
            catch{
                
            }
        }
    }
    
    func getBookContent(withBookId id : String, completion : @escaping ([String:Any]) -> Void) {
        let docRef = db.collection("books").document(id).collection("content")
        
        var content: [String:Any] = [:]
        
        var chapters : [[String]] = []
        
        docRef.getDocuments { (snap, error) in
            snap?.documents.forEach({ (docSnap) in
                
                if let chapter = docSnap.data()["text"] as? [String]{
                    chapters.append(chapter)
                }
            })
            
            content["content"] = chapters
            
            completion(content)
        }
    }
    
    func saveEffectToDocuments(effectName:String, completion: @escaping ()->Void) {
        let storageRef = Storage.storage().reference().child("Effects/\(effectName)")

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent(effectName)

        storageRef.write(toFile: documentsDirectory) { (url, error) in
            completion()
        }
    }
    
    func saveImageToDocuments(imageName:String, completion: @escaping ()->Void) {
        let storageRef = Storage.storage().reference().child("Images/\(imageName)")

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent(imageName)

        storageRef.write(toFile: documentsDirectory) { (url, error) in
            completion()
        }
    }
}

extension Decodable {
  init(from: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: from, options: [])
    let decoder = JSONDecoder()
    self = try decoder.decode(Self.self, from: data)
  }
}
