//
//  MainController.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/26/21.
//

import Foundation
import UIKit

protocol MainControllerDelegate: class {
    //
}

extension MainController: MainControllerDelegate {
    //
}

class MainController: UIViewController {
    
    var screenNavigationDelegate: ScreenNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? ScreenNavigation, segue.identifier == "ScreenNavigation" {
            //
        }
        
    }
    
}
