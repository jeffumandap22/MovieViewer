//
//  MovieViewerController.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/24/21.
//

import UIKit

class MovieSeatMapController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var labelSample: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return labelSample
    }

}
