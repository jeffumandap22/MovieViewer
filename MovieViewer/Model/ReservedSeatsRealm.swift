//
//  ReservedSeatsRealm.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/26/21.
//

import Foundation
import RealmSwift

class ReservedSeatsRealm: Object {
    @objc dynamic var seat      = ""
    @objc dynamic var price     = ""
    @objc dynamic var time      = ""
    @objc dynamic var cinema    = ""
    @objc dynamic var date      = ""
    @objc dynamic var compoundKey:String = "" //FORMAT: "seat-price-time-theatreId-cinema-date
    
    func generateKey(){
        self.compoundKey = "\(seat)-\(price)-\(time)-\(cinema)-\(date)"
        print("CompoundKey: \(compoundKey)")
    }
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
}
    
