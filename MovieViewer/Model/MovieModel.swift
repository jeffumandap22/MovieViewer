//
//  MovieModel.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/24/21.
//

import Foundation
import UIKit
import SwiftyJSON

class Movie: NSObject {
    var canonical_title: String?
    var poster: String?
    var poster_landscape: String?
    var genre: String?
    var advisory_rating: String?
    var runtime_mins: String?
    var release_date: String?
    var synopsis: String?
    var cast: [String] = []
    var theater: String?
    
    public override init() { }
       
    public init(value:JSON) {
        self.canonical_title  = value["canonical_title"].string ?? ""
        self.poster           = value["poster"].string ?? ""
        self.poster_landscape = value["poster_landscape"].string ?? ""
        self.genre            = value["genre"].string ?? ""
        self.advisory_rating  = value["advisory_rating"].string ?? ""
        self.runtime_mins     = value["runtime_mins"].string ?? ""
        self.release_date     = value["release_date"].string ?? ""
        self.synopsis         = value["synopsis"].string ?? ""
        self.theater          = value["theater"].string ?? ""
    }
}

class Schedule: NSObject {
    var dates: [Dates]?
    var cinemas: Cinemas?
    var times: Times?
}

class Dates: NSObject {
    var id: String?
    var label: String?
    var date: String?
    
    public override init() { }
       
    public init(value:JSON) {
        self.id     = value["id"].string ?? ""
        self.label  = value["label"].string ?? ""
        self.date   = value["date"].string ?? ""
    }
}

class Cinemas: NSObject {
    var parent: String?
    var cinemas: [Cinema] = []
    
    public override init() { }
       
    public init(value:JSON) {
        self.parent = value["parent"].string ?? ""
    }
}

class Cinema: NSObject {
    var id: String?
    var cinema_id: String?
    var label: String?
    
    public override init() { }
       
    public init(value:JSON) {
        self.id         = value["id"].string ?? ""
        self.cinema_id  = value["cinema_id"].string ?? ""
        self.label      = value["label"].string ?? ""
    }
}

class Times: NSObject {
    var parent: String?
    var times: [Time] = []
    
    public override init() { }
       
    public init(value:JSON) {
        self.parent = value["parent"].string ?? ""
    }
}

class Time: NSObject {
    var id: String?
    var label: String?
    var schedule_id: String?
    var popcorn_price: String?
    var popcorn_label: String?
    var seating_type: String?
    var price: String?
    var variant: String?
    
    public override init() { }
       
    public init(value:JSON) {
        self.id             = value["id"].string ?? ""
        self.label          = value["label"].string ?? ""
        self.schedule_id    = value["schedule_id"].string ?? ""
        self.popcorn_price  = value["popcorn_price"].string ?? ""
        self.popcorn_label  = value["popcorn_label"].string ?? ""
        self.seating_type   = value["seating_type"].string ?? ""
        self.price          = value["price"].string ?? ""
        self.variant        = value["variant"].string ?? ""
    }
}

struct AvailableSeats: Codable  {
    let seats: [String]
    let seat_count: Int
}

struct SeatMap: Codable {
    let seatmap: [[String]]
    let available: AvailableSeats
}

struct Error: Codable {
    let message: String
    let documentation_url: String
}

struct Parser {
    
    func parseSeat(completion: @escaping (SeatMap) -> Void, onFail:((_ message:String)->())?) {
        let api = URL(string: "http://ec2-52-76-75-52.ap-southeast-1.compute.amazonaws.com/seatmap.json")
        URLSession.shared.dataTask(with: api!) { data, _, error in
            
            if error != nil {
                onFail?(error?.localizedDescription ?? "Unknown error")
                return
            } else {
                if let result: SeatMap = try? JSONDecoder().decode(SeatMap.self, from: data!) {
                    print(result)
                    completion(result)
                } else {
                    if let error: Error = try? JSONDecoder().decode(Error.self, from: data!) {
                        onFail?(error.message)
                    }
                }

            }
            
        }.resume()
    }
    
}
