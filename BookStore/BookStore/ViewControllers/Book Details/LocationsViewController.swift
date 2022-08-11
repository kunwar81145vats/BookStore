//
//  LocationsViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit
import CoreLocation
import MapKit

class LocationsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var book: Book!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let coordX = Double(book.coordinateX), let coordY = Double(book.coordinateY)
        {
            let location = CLLocationCoordinate2D(latitude: coordX, longitude: coordY)
            let place = MKPointAnnotation()
            place.coordinate = location
            place.title = book.title
            
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.addAnnotation(place)
            mapView.setRegion(region, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Store Locations"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
    }
}
