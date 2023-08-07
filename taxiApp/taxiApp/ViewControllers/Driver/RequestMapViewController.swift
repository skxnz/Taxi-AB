//
//  RequestMapViewController.swift
//  taxiApp
//
//  Created by Alex on 04.08.2023.
//

import UIKit
import MapKit
import Firebase

enum SkipState {
    case customerLocation, destination
}

class RequestMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    var timer = Timer()
    private var state: SkipState = .customerLocation
    let ceo: CLGeocoder = CLGeocoder()
    
    public var userLongitude: Double?
    public var userLatitude: Double?
    
    public var destinationLongitude: Double?
    public var destinationLatitude: Double?
    
    private var userCoordinate: CLLocationCoordinate2D?
    private var destinationCoordinate: CLLocationCoordinate2D?
    
    let driverPin = MyPointAnnotation()
    let customerPin = MyPointAnnotation()
    let destinationPin = MyPointAnnotation()
    
    public var userNickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCoordinates()
        setUpPins()
    }
    
    func setUpPins() {
        driverPin.coordinate = ViewController.driver.coordinate
        driverPin.title = "Driver"
        driverPin.identifier = ViewController.driver.identifier
        
        customerPin.coordinate = userCoordinate!
        customerPin.title = "Customer"
        
        destinationPin.coordinate = destinationCoordinate!
        destinationPin.title = "Destination"
        mapView.addAnnotations([driverPin, customerPin, destinationPin])
    }
    
    func getCoordinates(){
        userCoordinate = CLLocationCoordinate2DMake(userLatitude!,userLongitude!)
        destinationCoordinate = CLLocationCoordinate2DMake(destinationLatitude!,destinationLongitude!)
    }
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        switch state {
        case .customerLocation:
            state = .destination
            ViewController.driver.coordinate = userCoordinate!
            let ac = UIAlertController(title: "Already?", message: "Do you see a client?", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "No", style: .destructive) {_ in
//                let db = Firestore.firestore()
//                db.collection("drive-requests").whereField("orderid", isEqualTo: "\(userNickname)").delete() { error in
//                    if let error = error {
//                        print(String(describing: error))
//                    } else {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    
//                }
//            })
            ac.addAction(UIAlertAction(title: "Yes", style: .default))
        case .destination:
            ViewController.driver.coordinate = destinationCoordinate!
        }
    }
}