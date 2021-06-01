//
//  NetworkAPI.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/24/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkAPI: NSObject {
    
    internal static func dataToJson(data:Data) -> JSON? {
        do {
            let json = try JSON(data: data)
            Swift.print("JSON:====\(json)====")
            return json
        } catch {
            return nil
        }
    }
    
    static func getMovieDetails(onSuccess:((_ result: Movie)->())?,onFail:((_ message:String)->())?) {
        AF.request("http://ec2-52-76-75-52.ap-southeast-1.compute.amazonaws.com/movie.json").responseJSON { (response) in
            if let json = response.data {
                guard let data = self.dataToJson(data:json)  else {
                    onFail?("Cant connect to internet")
                    return
                }

                var result: Movie?
                
                if !(data == JSON.null) {
                    let movie = Movie(value: data)
                    result = movie
                    onSuccess?(result!)
                } else {
                    onFail?("error unknown")
                }
                return
            } else {
                onFail?("Cant connect to internet")
            }
        }
    }
    
    static func getMovieSchedules(onSuccess:((_ result: Schedule)->())?,onFail:((_ message:String)->())?) {
        AF.request("http://ec2-52-76-75-52.ap-southeast-1.compute.amazonaws.com/schedule.json").responseJSON { (response) in
            if let json = response.data {
                guard let data = self.dataToJson(data:json)  else {
                    onFail?("Cant connect to internet")
                    return
                }

                let result: Schedule?
                
                if !(data == JSON.null) {
                    let schedule = Schedule()
                    var dates: [Dates] = []
                    var cinemas: Cinemas?
                    var times: Times?
                    
                    for (_ , subJson):(String, JSON) in data["dates"] {
                        let date = Dates(value: subJson)
                        dates.append(date)
                    }
                    for (_ , subJson):(String, JSON) in data["cinemas"] {
                        let cinema = Cinemas(value: subJson)
                        for (_ , subData):(String, JSON) in subJson["cinemas"] {
                            let cinemaData = Cinema(value: subData)
                            cinema.cinemas.append(cinemaData)
                        }
                        cinemas = cinema
                    }
                    for (_ , subJson):(String, JSON) in data["times"] {
                        let time = Times(value: subJson)
                        for (_ , subData):(String, JSON) in subJson["times"] {
                            let timeData = Time(value: subData)
                            time.times.append(timeData)
                        }
                        times = time
                    }
                    
                    schedule.dates = dates
                    schedule.cinemas = cinemas
                    schedule.times = times
                    
                    result = schedule
                    onSuccess?(result!)
                } else {
                    onFail?("error unknown")
                }
                
            } else {
                onFail?("Cant connect to internet")
            }
        }
    }
    
}
