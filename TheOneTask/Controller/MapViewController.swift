//
//  MapViewController.swift
//  TheOneTask
//
//  Created by Meet on 12/07/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

//MARK: Variable Declaration
    var person : Person!
    
//MARK: Outlet Declaration
    @IBOutlet weak var mapview: MKMapView!
    
//MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lat = person.lat, let lng = person.lng else{
            return
        }
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        setPinUsingMKPlacemark(location: location)
    }

}

//MARK: - Cutom methods extension
extension MapViewController{
    func setPinUsingMKPlacemark(location: CLLocationCoordinate2D) {
       let pin = MKPlacemark(coordinate: location)
       let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapview.setRegion(coordinateRegion, animated: true)
        mapview.addAnnotation(pin)
    }
}
