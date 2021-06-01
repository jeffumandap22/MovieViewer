//
//  MovieSeatMapViewController.swift
//  MovieViewer
//
//  Created by Jeff Umandap on 5/25/21.
//

import UIKit
import RealmSwift

class MovieSeatMapViewController: UIViewController, UIScrollViewDelegate {
    
    var screenNavigationDelegate: ScreenNavigationDelegate?
    
    @IBOutlet weak var theatreLabel: UILabel!
    
    @IBOutlet weak var seatCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var cinemaButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var selectedSeatsCollection: UICollectionView!
    @IBOutlet weak var reserveSeatButton: UIButton!
    @IBOutlet weak var selectedSeatPriceLabel: UILabel!
    
    
    var viewController: MovieDetailsController?
    
    var seatCount: Int = 0
    
    var movieData: Movie?
    var seatData: SeatMap?
    var availableSeat: AvailableSeats?
    
    var schedule: Schedule?
    
    var selectedTime: Time?
    var selectedDate: Dates?
    var selectedCinema: Cinema?
    
    var selectedSeatsPrice: Double = 0.0
    var selectedSeatsArray: [ReservedSeatsRealm] = []
    var selectedStringArray: [String]  = []
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 36,
        minimumInteritemSpacing: 2,
        minimumLineSpacing: 2,
        sectionInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        self.theatreLabel.text = self.movieData?.theater
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        
        seatCollectionView.delegate = self
        seatCollectionView.dataSource = self
        selectedSeatsCollection.dataSource = self
        
        seatCollectionView?.collectionViewLayout = columnLayout
        seatCollectionView?.contentInsetAdjustmentBehavior = .always
        seatCollectionView.register(UINib.init(nibName: "SeatCell", bundle: nil), forCellWithReuseIdentifier: "SeatCell")
        selectedSeatsCollection.register(UINib.init(nibName: "SelectedSeatCell", bundle: nil), forCellWithReuseIdentifier: "SelectedSeatCell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func updatePrice() {let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_PH")
        formatter.numberStyle = .currency
        if let amount = formatter.string(from: selectedSeatsPrice as NSNumber) {
            self.selectedSeatPriceLabel.text = "\(amount)"
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reserveTapped(_ sender: UIButton) {
        let seatsSelected = self.selectedSeatsArray
        if seatsSelected.count != 0 {
            let realm = try! Realm()
            for data in seatsSelected {
                try! realm.write {
                    realm.add(data)
                }
            }
            selectedSeatsPrice = 0.0
            selectedSeatPriceLabel.text = "₱0.00"
            self.selectedSeatsArray.removeAll()
            self.selectedStringArray.removeAll()
            self.selectedSeatsCollection.reloadData()
            self.seatCollectionView.reloadData()
        } else {
            Common.quickAlert(self, mtitle: "No Selected Seats Yet", message: "Please select available seats", onDone: nil)
        }
    }
    
    @IBAction func dateTapped(_ sender: UIButton) {
        Common.quickAlertSelectDate(self, mtitle: "Select Date", message: "", dates: (self.schedule?.dates)!) { (dates) in
            self.selectedDate = dates
            self.dateButton.setTitle(dates.label, for: .normal)
            self.seatCollectionView.reloadData()
        }
    }
    @IBAction func cinemaTapped(_ sender: Any) {
        Common.quickAlertSelectTheatre(self, mtitle: "Select Theatre", message: (self.schedule?.cinemas?.parent)!, cinemas: (self.schedule?.cinemas!.cinemas)!) { (cinema) in
            self.selectedCinema = cinema
            self.cinemaButton.setTitle(cinema.label, for: .normal)
            self.seatCollectionView.reloadData()
        }
    }
    
    @IBAction func timeTapped(_ sender: Any) {
        Common.quickAlertSelectTime(self, mtitle: "Select Time", message: "", times: (self.schedule?.times!.times)!) { (time) in
            self.selectedTime = time
            self.timeButton.setTitle(time.label, for: .normal)
            self.seatCollectionView.reloadData()
        }
    }

    
    
}


extension MovieSeatMapViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == seatCollectionView {
            return (seatData?.seatmap.count)!
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == seatCollectionView {
            return (seatData?.seatmap[section].count)!
        } else {
            return selectedStringArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == seatCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCell
            let seat = seatData?.seatmap[indexPath.section][indexPath.row]
            
            let selectedTime = self.selectedTime?.id
            let selectedDate = self.selectedDate?.id
            let selectedCinema = self.selectedCinema?.cinema_id
            
            cell.isUserInteractionEnabled = false
            cell.cellLabel.isHidden = false
            cell.cellLabel.text = ""
            
            if (selectedTime != nil) && (selectedDate != nil) && (selectedCinema != nil) {
                let realm = try! Realm()
                let result = realm.objects(ReservedSeatsRealm.self).filter("seat = '\(seat!)' AND time = '\(selectedTime!)' AND cinema = '\(selectedCinema!)' AND date = '\(selectedDate!)'").first
                if result != nil {
                    cell.cellView.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                } else {
                    if (seat == "A(30)") || seat == "a(30)" {
                        cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        for seatFree in availableSeat!.seats {
                            if seatFree == seat {
                                cell.cellView.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                                cell.isUserInteractionEnabled = true
                                for seatInArray in selectedStringArray {
                                    if seatInArray == seat {
                                        cell.isUserInteractionEnabled = false
                                        cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                                        cell.cellLabel.text = "✓"
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if (seat == "A(30)") || seat == "a(30)" {
                    cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    for seatFree in availableSeat!.seats {
                        if seatFree == seat {
                            cell.cellView.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                            cell.isUserInteractionEnabled = true
                        }
                    }
                }
            }
            
            if selectedStringArray.count == 10 {
                cell.isUserInteractionEnabled = false
                cell.cellView.layer.opacity = 0.5
            } else {
                cell.cellView.layer.opacity = 1
            }
            
            return cell
        }
        
        if collectionView == selectedSeatsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedSeatCell", for: indexPath) as! SelectedSeatCell
            let seat = selectedStringArray[indexPath.row]
            cell.cellIdLabel.text = seat
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seat = seatData?.seatmap[indexPath.section][indexPath.row]
        print("Realm Viewer path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        if (self.selectedDate != nil) && (self.selectedTime != nil) && (self.selectedCinema != nil) {
            let seatRealm = ReservedSeatsRealm()
            seatRealm.seat = seat ?? ""
            seatRealm.price = self.selectedTime?.price ?? ""
            seatRealm.time = self.selectedTime?.id ?? ""
            seatRealm.cinema = self.selectedCinema?.cinema_id ?? ""
            seatRealm.date = self.selectedDate?.id ?? ""
        
            seatRealm.generateKey()
            
            self.selectedSeatsArray.append(seatRealm)
            self.selectedStringArray.append(seatRealm.seat)
            guard let price = Int(seatRealm.price) else { return }
            self.selectedSeatsPrice += Double(price)
            updatePrice()
            seatCollectionView.reloadData()
            selectedSeatsCollection.reloadData()
        } else {
            Common.quickAlert(self, mtitle: "Please Select", message: "Time / Date / Theatre") {
                //
            }
        }
        
    }
    
}


class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int

    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
