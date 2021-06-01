//
//  Common.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/26/21.
//

import Foundation
import UIKit

public class Common: NSObject {
    
    static func formatDate(date: String) -> String {
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        let firstDate = dateF.date(from: date)
        dateF.dateFormat = "MMM dd, yyyy"
        let newDateString = dateF.string(from: firstDate!)
        return newDateString
    }
    
    static func secondsToHoursMinutesSeconds (mins : Int) -> (Int, Int) {
        return ((mins % 3600) / 60, (mins % 3600) % 60)
    }

    static func quickAlert(_ vc:UIViewController, mtitle:String, message:String, onDone: (()->())?){
        let alert = UIAlertController(title: mtitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            if let onDone = onDone{
                onDone()
            }
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func quickAlertSelectDate(_ vc:UIViewController, mtitle:String, message:String, dates:[Dates], onDone: ((_ date: Dates)->())?){
        let alert = UIAlertController(title: mtitle, message: message, preferredStyle: .actionSheet)
        
        for date in dates {
            let dateAction = UIAlertAction(title: date.label, style: .default) { action in
                if let onDone = onDone{
                    onDone(date)
                }
            }
            alert.addAction(dateAction)
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func quickAlertSelectTheatre(_ vc:UIViewController, mtitle:String, message:String, cinemas:[Cinema], onDone: ((_ date: Cinema)->())?){
        let alert = UIAlertController(title: mtitle, message: message, preferredStyle: .actionSheet)
        
        for cinema in cinemas {
            let dateAction = UIAlertAction(title: cinema.label, style: .default) { action in
                if let onDone = onDone{
                    onDone(cinema)
                }
            }
            alert.addAction(dateAction)
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func quickAlertSelectTime(_ vc:UIViewController, mtitle:String, message:String, times:[Time], onDone: ((_ date: Time)->())?){
        let alert = UIAlertController(title: mtitle, message: message, preferredStyle: .actionSheet)
        
        for time in times {
            let dateAction = UIAlertAction(title: "Time:\(time.label ?? "") - Price: \(time.price ?? "")", style: .default) { action in
                if let onDone = onDone{
                    onDone(time)
                }
            }
            alert.addAction(dateAction)
        }
        vc.present(alert, animated: true, completion: nil)
    }


}

