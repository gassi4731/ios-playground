//
//  ViewController.swift
//  Sample
//
//  Created by Yo Higashida on 2022/07/06.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var locationManager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 位置情報が使用可能な場合
        if status == .authorizedWhenInUse {
            // 位置情報を取得する
            locationManager?.startUpdatingLocation()
        }
    }
    
    // 位置情報が更新された場合
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }

        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in

            if let error = error {
                print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?[0] {

                var locInfo = ""
                locInfo = locInfo + "Latitude: \(loc.coordinate.latitude)\n"
                locInfo = locInfo + "Longitude: \(loc.coordinate.longitude)\n\n"

                locInfo = locInfo + "Country: \(placemark.country ?? "")\n"
                locInfo = locInfo + "State/Province: \(placemark.administrativeArea ?? "")\n"
                locInfo = locInfo + "City: \(placemark.locality ?? "")\n"
                locInfo = locInfo + "PostalCode: \(placemark.postalCode ?? "")\n"
                locInfo = locInfo + "Name: \(placemark.name ?? "")"

                print(locInfo)
            }
        })
        
        let cr = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(cr, animated: true)
        
        let pa = MKPointAnnotation()
        pa.title = "I'm here!"
        pa.coordinate = loc.coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pa)
    }
    
    // エラーが発生した場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
