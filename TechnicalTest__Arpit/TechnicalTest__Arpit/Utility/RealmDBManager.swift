//
//  RealmDBManager.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 26/04/24.
//

import Foundation
import RealmSwift




class RealmDBManager {
    
    private var realm: Realm
    static let shared = RealmDBManager()
 
    private init() {
        self.realm = try! Realm()
    }
}

extension RealmDBManager {
    
    func addObjectsToDatabse<T: Object>(data: [T]) {
        for object in data {
            try! realm.write {
                realm.add(object)
            }
        }
    }
    
    func deleteObjectsFromDatabse() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    func getObjectsFromDatabse() -> [Article] {
        return Array(realm.objects(Article.self))
    }
}
