//
//  ScreenNavigation.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/26/21.
//

import Foundation
import UIKit

protocol ScreenNavigationDelegate:class {
    func loadHomeView()
    func loadSeatMap(sched: Schedule?, movie: Movie?)
}

class ScreenNavigation: UINavigationController, ScreenNavigationDelegate {
    
    var homeVC: MovieDetailsController?
    
    let parser = Parser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeView()
    }
    
    
    func loadHomeView(){
        if let _ = homeVC {
            //
        } else {
            homeVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsController") as? MovieDetailsController
        }
        homeVC?.screenNavigationDelegate = self
        self.pushViewController(homeVC!, animated: true)
    }
    
    func loadSeatMap(sched: Schedule?,movie: Movie?) {
        
        parser.parseSeat { (data) in
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieSeatMapViewController") as! MovieSeatMapViewController
                vc.seatData = data
                vc.availableSeat = data.available
                vc.schedule = sched
                vc.movieData = movie
                vc.screenNavigationDelegate = self
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
            }
        } onFail: { message in
            print(message)
        }
        
    }
}
