//
//  PostStore.swift
//  FirebaseTaskApp
//
//  Created by sun on 23/11/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class PostStore {
    
    let db = Firestore.firestore()
    
    var Title : String
    var posts : String
    var day : String
    
    init(Title:String,posts:String,day:Date) {
        self.Title = Title
        self.posts = posts
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyy" //hh:mm:ss
        let now = df.string(from: day)
        
        self.day = now
        
        print(now)
        print(posts)
        print(Title)
        
        let objUTCDate: NSDate = df.date(from: now)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSinceNow)
        print(milliseconds)
        let strTimeStamp: String = "\(milliseconds)"
        
        let docData: [String: Any] = [
            "Title": self.Title,
            "posts": self.posts,
            "id": Int(milliseconds),
            "dateExample": Timestamp(date: Date()),
            "day": self.day,
        ]
         db.collection("Post").document().setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
