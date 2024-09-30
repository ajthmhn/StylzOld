//
//  AddAddressViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/09/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MapKit
import GoogleMaps
import GooglePlaces
import DropDown
import StylesWebKit

class AddAddressViewController: UIViewController {


    @IBOutlet weak var txtNickName: MDCOutlinedTextField!
    @IBOutlet weak var isDefault: UISwitch!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblIsDefault: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgBack: UIButton!
    
    @IBOutlet var viewyTypes: [UIView]!
    @IBOutlet var viewSearch: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnBAck: UIButton!
    @IBOutlet weak var viewNickName: UIView!


    var isFirst = false
    var index = -1
    var canCall = false
    var isFristTime = true
    let marker = GMSMarker()
    var selectedLocation : CLLocation?
    var countryLatitude : Double?
    var countryLongitude : Double?
    var crntaddress = ""
    var adressChoosed = false
    let locationManager = CLLocationManager()
    var valueNOtTaken = false
    var addressSelecteds = false
    var homeView : HomeViewController?
    
    var searchBar = UISearchBar()
    private var tableView: UITableView!
    private var tableDataSource: GMSAutocompleteTableDataSource!

    var selectedAddres : Addresss?
    
    var isAddingFromHome = false
    
    var shouldAutoFill = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtNickName.textAlignment = .right
        }else{
            txtNickName.textAlignment = .left
        }
        
        btnAdd.backgroundColor = getThemeColor()
        btnBAck.tintColor = getThemeColor()
        
        self.viewSearch.addSubview(searchBar)
        searchBar.frame = self.viewSearch.bounds
        searchBar.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "all_barber", comment: "")
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.delegate = self

        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self

        tableView = UITableView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height - 450))
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableDataSource.tableCellBackgroundColor = UIColor.white
        
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.backgroundColor = UIColor.white
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.lightGray
            }
        }

        self.locationManager.requestAlwaysAuthorization()
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = UIImage(named: "location_address")
                leftView.tintColor = UIColor.lightGray
            }
        }
            

        if selectedAddres != nil{
            shouldAutoFill = false
            if self.selectedAddres?.latitude == nil || self.selectedAddres?.latitude == ""{
                DispatchQueue.global(qos: .default).async {
                            [weak self] in

                    self?.locationManager.requestWhenInUseAuthorization()

                    if CLLocationManager.locationServicesEnabled() {
                        self?.locationManager.delegate = self
                        self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        self?.locationManager.startUpdatingLocation()
                    }
                }
                
                DispatchQueue.main.async {
                    showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "pin_location", comment: ""), sender: self)
                }
            }else{
                self.countryLatitude = Double(self.selectedAddres?.latitude ?? "0.0")
                self.countryLongitude = Double(self.selectedAddres?.longitude ?? "0.0")
                let camera = GMSCameraPosition.camera(withLatitude: (self.countryLatitude ?? 0.0), longitude: (self.countryLongitude ?? 0.0), zoom: 17.0)
                self.mapView?.animate(to: camera)
            }

            txtNickName.text = self.selectedAddres?.nick_name
            
            if self.selectedAddres?.is_default == 1{
                self.isDefault.isOn = true
            }else{
                self.isDefault.isOn = false
            }
            
            btnAdd.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_address", comment: ""), for: .normal)

        }else{
            DispatchQueue.global(qos: .default).async {
                        [weak self] in

                self?.locationManager.requestWhenInUseAuthorization()

                if CLLocationManager.locationServicesEnabled() {
                    self?.locationManager.delegate = self
                    self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self?.locationManager.startUpdatingLocation()
                }
            }
            btnAdd.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_address", comment: ""), for: .normal)

        }
        
        setDesign()
        
        
    }
    
    
    func setDesign(){
        if homeView == nil{
            viewNickName.isHidden = false
        }else{
            viewNickName.isHidden = true
            btnAdd.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "update_address", comment: ""), for: .normal)
        }
        
        txtNickName.attributedPlaceholder = setRequired(placeHolder: LocalizationSystem.sharedInstance.localizedStringForKey(key: "nick_name", comment: ""))
        txtNickName.label.attributedText = setRequired(placeHolder: LocalizationSystem.sharedInstance.localizedStringForKey(key: "nick_name", comment: ""))

        setTextfieldDesign(text: txtNickName)
    }
    
    func setRequired(placeHolder:String) -> NSMutableAttributedString{
        let text = placeHolder
        let ranges = (text as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: ranges)
        return attributedString
    }
    
    

    func setTextfieldDesign(text:MDCOutlinedTextField){
        text.setNormalLabelColor(UIColor.lightGray, for: .normal)
        text.setFloatingLabelColor(UIColor(hexString: "143659")!, for: .editing)
        text.setOutlineColor(UIColor.lightGray, for: .normal)
        text.setOutlineColor(UIColor(hexString: "143659")!, for: .editing)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if homeView != nil{
            addressSelected = true
            latitude = self.countryLatitude ?? 0.0
            longitude = self.countryLongitude ?? 0.0
            self.navigationController?.popToRootViewController(animated: false)

        }else{
            if txtNickName.text == "" {
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_nick", comment: ""), sender: self)
                return
            }
            
            if selectedAddres != nil{
               updateAddress()
            }else{
                addAddress()
            }
        }
        
    }
     
    
    func addAddress(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        details["latitude"] = self.countryLatitude
        details["longitude"] = self.countryLongitude
        details["nick_name"] = self.txtNickName.text

        
        StylzAPIFacade.shared.createAddress(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "address_added", comment: ""), view: self.view)
                   
                   if self.isAddingFromHome == true{
                       addressSelected = true
                       latitude = self.countryLatitude ?? 0.0
                       longitude = self.countryLongitude ?? 0.0
                       userAddress = self.txtNickName.text ?? ""
                   }
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                       self.navigationController?.popViewController(animated: true)
                   }
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                    }
                }
            }else{
                if let error = aRes?.json?["error"].array{
                    if error.count > 0{
                        showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                    }
                }else{
                    showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                }
                }
            }
    }
    
    func updateAddress(){
        
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

extension AddAddressViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isFristTime == true {
            if selectedAddres != nil{
                if self.selectedAddres?.latitude == nil || self.selectedAddres?.latitude == ""{
                    let location:CLLocation = locations[0] as CLLocation
                    let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
                    self.mapView?.animate(to: camera)
                    DispatchQueue.main.async {
                        self.reverseGeocodeCoordinateForMovement(location.coordinate)
                    }
                }else{
                    let camera = GMSCameraPosition.camera(withLatitude: (self.countryLatitude ?? 0.0), longitude: self.countryLongitude ?? 0.0, zoom: 17.0)
                    self.mapView?.animate(to: camera)
                    DispatchQueue.main.async {
                        self.reverseGeocodeCoordinateForMovement(CLLocationCoordinate2D(latitude: self.countryLatitude ?? 0.0, longitude: self.countryLongitude ?? 0.0))
                    }
                }
        }else{
            let location:CLLocation = locations[0] as CLLocation
            let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
            self.mapView?.animate(to: camera)
            DispatchQueue.main.async {
                self.reverseGeocodeCoordinateForMovement(location.coordinate)
            }
        }
           
           self.locationManager.stopUpdatingLocation()
            self.isFristTime = false
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

extension AddAddressViewController : GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //if isFristTime == true{
        DispatchQueue.main.async {
            if self.isFristTime == false{
                self.addressSelecteds = true
            }
           
            self.reverseGeocodeCoordinateForMovement(position.target)
        }
    }
    
    private func reverseGeocodeCoordinateForMovement(_ coordinate: CLLocationCoordinate2D) {

        // 1
        let geocoder = GMSGeocoder()

        // 2
        
        if valueNOtTaken == false{
            valueNOtTaken = true
        }else{
            countryLongitude = coordinate.longitude
            countryLatitude = coordinate.latitude
        }
        
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.searchBar.text = lines.joined(separator: "\n")
            self.crntaddress = lines.joined(separator: "\n")
            if self.homeView != nil{
                userAddress = "\(address.country ?? ""), \(address.locality ?? "")"
            }
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            
            
            
//                    print("\ncoordinate.latitude=\(address.coordinate.latitude)")
//                    print("coordinate.longitude=\(address.coordinate.longitude)")
//                    print("thoroughfare=\(address.thoroughfare)")
//                    print("locality=\(address.locality)")
//                    print("subLocality=\(address.subLocality)")
//                    print("administrativeArea=\(address.administrativeArea)")
//                    print("postalCode=\(address.postalCode)")
//                    print("country=\(address.country)")
//                    print("lines=\(address.lines)")
        }
}
}

extension AddAddressViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Update the GMSAutocompleteTableDataSource with the search text.
    tableDataSource.sourceTextHasChanged(searchText)
      tableView.isHidden = false
     
  }
}

extension AddAddressViewController: GMSAutocompleteTableDataSourceDelegate {
  func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    // Turn the network activity indicator off.
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    // Reload table data.
    tableView.reloadData()
  }

  func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    // Turn the network activity indicator on.
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    // Reload table data.
    tableView.reloadData()
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
    // Do something with the selected place.
//      print("Place name: \(place.name)")
//      print("Place address: \(place.formattedAddress)")
//      print("Place attributions: \(place.attributions)")
      
      tableView.isHidden = true
      searchBar.text = place.formattedAddress
      
//      print("\ncoordinate.latitude=\(place.coordinate.latitude)")
//      print("coordinate.longitude=\(place.coordinate.longitude)")
//      print("thoroughfare=\(place.thoroughfare)")
//      print("locality=\(place.locality)")
//      print("subLocality=\(place.subLocality)")
//      print("administrativeArea=\(place.administrativeArea)")
//      print("postalCode=\(place.postalCode)")
//      print("country=\(place.country)")
//      print("lines=\(place.lines)")
      
      let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 17.0)
      self.mapView?.animate(to: camera)
      DispatchQueue.main.async {
          self.shouldAutoFill = true
          self.addressSelecteds = true
          self.reverseGeocodeCoordinateForMovement(place.coordinate)
      }

  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
    // Handle the error.
    print("Error: \(error.localizedDescription)")
  }

  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
      self.searchBar.endEditing(true)
      return true
  }
}
