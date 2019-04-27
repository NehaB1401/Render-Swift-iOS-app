//
//  ViewItemDetailViewController.swift
//  FinalProjectRender
//
//  Created by Swift on 4/26/19.
//  Copyright © 2019 Swift. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseStorage
import MapKit

final class addressAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

class ViewItemDetailViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate ,UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (sItem.itemImages == nil)
        {
            return 0
        }
        else
        {
            return (sItem.itemImages?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ViewImageCollectionViewCell
        cell!.useMemberString(item:sItem.itemImages![indexPath.row])
        // cell?.image.image = UIImage(named: "register")
        return cell!
    }
    

    var itemId: String?
    
    var saleItemList = [SaleItem]()
    var sItem: Item = Item()
    var locationManager : CLLocationManager?
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descTxt: UITextView!
    
    @IBOutlet weak var priceTxt: UITextField!
    
    @IBAction func askDetails(_ sender: UIButton) {
    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var categoryTxt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemsRef = Database.database().reference().child("items")

        itemsRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            
            guard let postSaleItems = PostSaleItemList(with: snapshot) else { return}
            self.saleItemList = postSaleItems.SaleItemList
            
            for saleItem in self.saleItemList
            {
                if(saleItem.itemId == self.itemId)
                {
                    self.sItem.propertyAddress = saleItem.propertyAddress
                    self.loadItemDetails(si: saleItem)
                    self.sItem.itemImages = saleItem.itemImages
                    self.imageCollectionView.reloadData()
                }
            }
            
        })

        
        // Do any additional setup after loading the view.
    }
    
    func loadItemDetails(si: SaleItem) {
        //print(movie);
       titleTxt.text = si.itemTitle
        descTxt.text = si.description
        priceTxt.text = String(format:"%f",si.price!)
        categoryTxt.text = si.itemCategory
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let coordinate = CLLocationCoordinate2D(latitude:(self.sItem.propertyAddress!.latitude)!, longitude:(self.sItem.propertyAddress!.longitude)!)
        
        let annotation = addressAnnotation(coordinate: coordinate, title: self.sItem.propertyAddress?.addressLine1, subtitle: self.sItem.propertyAddress?.city)
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
   
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let addressAnnotationV = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as?
            MKMarkerAnnotationView{
            addressAnnotationV.animatesWhenAdded = true
            addressAnnotationV.titleVisibility = .adaptive
            addressAnnotationV.subtitleVisibility = .adaptive
            
            return addressAnnotationV
        }
        return nil
    }
}
