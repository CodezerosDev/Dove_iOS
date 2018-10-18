//
//  DNDashBoardVC.swift
//  DoveNetwork
//
//  Created by Reus on 11/06/18.
//  Copyright © 2018 Reus. All rights reserved.
//

import UIKit
import MapKit

class DNDashBoardVC: UIViewController
{
    @IBOutlet weak var viewMap: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewMap.delegate = self
        initiateMapView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnBuyTapped(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            let buySellData = DNConstant.StoryBoards.buyData.instantiateViewController(withIdentifier: String(describing: DNDataSellBuyVC.self)) as! DNDataSellBuyVC
            buySellData.boolbuying = true
            self.navigationController?.pushViewController(buySellData, animated: true)
        }
    }
    
    @IBAction func btnSellData(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            let buySellData = DNConstant.StoryBoards.buyData.instantiateViewController(withIdentifier: String(describing: DNDataSellBuyVC.self)) as! DNDataSellBuyVC
            buySellData.boolbuying = false
            self.navigationController?.pushViewController(buySellData, animated: true)
        }
    }
    
    @IBAction func btnWalletTapped(_ sender: UIButton)
    {
        let walletVC = DNConstant.StoryBoards.wallet.instantiateViewController(withIdentifier: String(describing: DNWalletVC.self)) as! DNWalletVC
        APPLICATION_DELEGATE.navController = UINavigationController(rootViewController: walletVC)
        DispatchQueue.main.async {
            self.present(APPLICATION_DELEGATE.navController!, animated: true, completion: nil)
        }
    }
}

extension DNDashBoardVC
{
    func initiateMapView()
    {
        guard let location = DNLocationManager.sharedInstance.locationManager?.location else{
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        viewMap.setRegion(region, animated: true)
        
        // drop pin at current location
        
        let annotation = DNAnnotation(coordinate: location.coordinate, title: "", subtitle: "", type: .UserLocation)
        self.viewMap.addAnnotation(annotation)
    }
}

extension DNDashBoardVC: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if (annotation.isKind(of: MKUserLocation.self))
        {
            return nil
        }
        
        if annotation.isKind(of: DNAnnotation.self)
        {
            let attractionAnnot = annotation as! DNAnnotation
            let annotationView = DNAnnotationView(annotation: annotation, reuseIdentifier: "Attraction",_attractiontype: attractionAnnot.type)
            annotationView.canShowCallout = attractionAnnot.type == .UserLocation ? true : false
            annotationView.annotation     = annotation
            //annotationView.animatesDrop = true
            return annotationView
        }
        else
        {
            let reuseId = "image"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if pinView == nil
            {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.image = UIImage(named: "location")
            }
            else
            {
                pinView?.annotation = annotation
            }
            return pinView
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        if view.isKind(of: DNAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
}


