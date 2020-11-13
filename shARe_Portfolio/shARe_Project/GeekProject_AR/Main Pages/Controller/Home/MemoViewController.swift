//
//  MemoViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2019/08/19.
//  Copyright © 2019 Riku Yanagimachi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NCMB

class MemoViewController: UIViewController, CLLocationManagerDelegate {
    var memo: Memo!
    
    var memos: [Memo]!
    
    @IBOutlet var memoTitle:UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var presentButton: UIButton!
    
    var locManager: CLLocationManager!
    
    let annotation = MKPointAnnotation()
    
    var lat: Double?
    var lon: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memoTitle.textColor = UIColor.white
        presentButton.layer.cornerRadius = 25
        
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        print("メモっす\(memo)")
        
        locManager = CLLocationManager()
        locManager.delegate = self
        
        // 位置情報の使用の許可を得る
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        guard let memo = memo else {
            print("memo中何もないぞ")
            return
        }
        self.memoTitle.text = memo.title
        
        self.lat = memo.latitude
        self.lon = memo.longitude
        
        self.annotation.coordinate = CLLocationCoordinate2DMake(self.lat!, self.lon!)
        
        annotation.title = "メモ所在地"
        annotation.subtitle = "Bluh"
        
        mapView.addAnnotation(annotation)

    }
    
    
    
    @IBAction func presentAR(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemoARKitViewController") as! MemoARKitViewController
        controller.memo = memo
        self.present(controller, animated: true, completion: nil)
    }
}
