//
//  DataStore.swift
//  FirebaseTaskApp
//
//  Created by sun on 20/11/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class DataStore : ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published
    var dataArr = [DataArray]()
    
    func Reload(){
        
        //Reset Array
        dataArr = [DataArray]()
        
        db.collection("Post").getDocuments { (Snapshort, err) in
            if let err = err {
                print("Error \(err)")
            } else {
                for document in Snapshort!.documents {
                    print(document.data())

                    let id  = document.get("id") as? Int
                    let Title = document.get("Title") as? String
                    let posts = document.get("posts") as? String
                    let day = document.get("day") as? String
                    
                    let createData = DataArray(id: id!, Title: Title!, posts: posts!, day: day!)
                    
                    self.dataArr.append(createData)
                    
                }
            }
        }
        
    }
    
}
