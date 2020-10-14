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
            
            var _effects : String?
            
            if let effects = snapshot?.data()?["effects"]{
                do {
                    let e = effects as! [String]
//                    let data = try JSONSerialization.data(withJSONObject: e, options: [])
//                    let f = String(data: data, encoding: .utf8)
                    _effects = e.joined(separator: ",")
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
                
//                if let text = docSnap.data()["text"] as? [String]{
//                    print("JUST THE TEXT: \(text)")
//                    let chapterText = text.joined(separator: "_")
//                    content[docSnap.documentID] = chapterText
//                }
                
//                content[docSnap.documentID] = docSnap.data()
                
//                chapters.append(docSnap.data())
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
}

extension Decodable {
  init(from: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: from, options: [])
    let decoder = JSONDecoder()
    self = try decoder.decode(Self.self, from: data)
  }
}
