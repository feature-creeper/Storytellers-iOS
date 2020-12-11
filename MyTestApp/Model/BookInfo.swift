//
//  BookInfo.swift
//  MyTestApp
//
//  Created by Joe Kletz on 11/10/2020.
//

import Foundation

struct BookInfo : Codable {
    var author : String?
    var title : String?
    var cover : String?
    var id : String?
    var effects : String?
    var pages : String?
    var about : String?
    var readtime : String?
    var effectSequence : String?
    var images : String?
    var imageSequence : String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case cover
        case about
        case readtime
    }
}
