//
//  DatabaseHelper.swift
//  MyTestApp
//
//  Created by Joe Kletz on 09/10/2020.
//

import Foundation

class DatabaseHelper {
    public static let shared = DatabaseHelper()
    private init(){}
    
    func addFile() {
        print("ADD FILE")
    }
    
    func browseFiles() {
        print("Browse")
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at: docsurl, includingPropertiesForKeys: nil)!
            for case let f as URL in dir where f.pathExtension == "txt" {
                print(f.lastPathComponent)
            }
        } catch {
            
        }
        
    }
}
