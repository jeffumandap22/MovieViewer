//
//  MovieDetailsController.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/24/21.
//

import UIKit
import SDWebImage

class MovieDetailsController: UIViewController {
    
    var screenNavigationDelegate: ScreenNavigationDelegate?

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var portraitImage: UIImageView!
    
    @IBOutlet weak var canonicalTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var advisoryRatingLabel: UILabel!
    @IBOutlet weak var runtimeMinsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var posterImageUrl: String?
    var portraitImageUrl: String?
    
    var schedule: Schedule?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    @IBAction func viewSeatMapTapped(_ sender: Any) {
        screenNavigationDelegate?.loadSeatMap(sched: self.schedule,movie: self.movie)
    }
    
    func setData() {
        NetworkAPI.getMovieDetails { (movie) in
            self.movie = movie
            
            self.canonicalTitleLabel.text = movie.canonical_title
            self.genreLabel.text = movie.genre
            self.advisoryRatingLabel.text = movie.advisory_rating
            let minsToInt = (movie.runtime_mins! as NSString).integerValue
            let (h,m) = Common.secondsToHoursMinutesSeconds(mins: minsToInt)
            self.runtimeMinsLabel.text = "\(h)hr \(m)mins"
            self.releaseDateLabel.text = "\(Common.formatDate(date: movie.release_date!))"
            self.synopsisLabel.text = movie.synopsis
            
            self.posterImage.sd_setImage(
                with: URL(string: movie.poster_landscape!),
                placeholderImage: UIImage(),
                options: SDWebImageOptions(rawValue: 0),
                completed: { (image, error, cacheType, imageURL) in
                    if (error != nil) {
                        self.posterImage.image = UIImage()
                    } else {
                        self.posterImage.image = image
                    }
            })
            
            self.portraitImage.sd_setImage(
                with: URL(string: movie.poster!),
                placeholderImage: UIImage(),
                options: SDWebImageOptions(rawValue: 0),
                completed: { (image, error, cacheType, imageURL) in
                    if (error != nil) {
                        self.portraitImage.image = UIImage()
                    } else {
                        self.portraitImage.image = image
                    }
            })
            
        } onFail: { (error) in
            print(error)
        }
        
        getMovieSchedules()
    }
    
    func getMovieSchedules() {
        NetworkAPI.getMovieSchedules { (schedule) in
            let sched = Schedule()
            sched.cinemas = schedule.cinemas
            sched.dates = schedule.dates
            sched.times = schedule.times
            self.schedule = sched
        } onFail: { (error) in
            print(error)
        }

    }

}

