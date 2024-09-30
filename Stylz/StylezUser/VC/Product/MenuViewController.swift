//
//  MenuViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 19/10/23.
//

import UIKit
import StylesWebKit

class MenuViewController: UIViewController {
  
    
    @IBOutlet var viewDrawer: UIView!
    @IBOutlet var btnSelct: UIButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var lblCrntAddress: UILabel!
    @IBOutlet var lblAddress: UILabel!

    
    var address = [Addresss]()
    var homeView : HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if address.count == 0{
            btnSelct.isHidden = false
        }else{
            btnSelct.isHidden = true
        }
        
        if getUserDetails() == nil{
            self.btnAdd.isHidden = true
        }else{
            self.btnAdd.isHidden = false
        }
        
        btnSelct.backgroundColor = getThemeColor()
        btnAdd.backgroundColor = getThemeColor()
        lblCrntAddress.text = myAddress
        
        lblAddress.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "crnt_location", comment: "")
        btnSelct.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_location", comment: ""), for: .normal)
        btnAdd.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_new", comment: ""), for: .normal)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.isMovingToParent == false{
            self.dismiss(animated: false)
            homeView?.getAddress()
            homeView?.getTop10()
            homeView?.getAllBarbers()
            if userAddress == ""{
                homeView?.lbladdress.text = myAddress
            }else{
                homeView?.lbladdress.text = userAddress
            }
           
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0.0
        
        viewDrawer.frame = CGRect(x: 0, y: -200, width: viewDrawer.frame.width, height:  viewDrawer.frame.height)

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear],
                               animations: {
            self.viewDrawer.frame = CGRect(x: 0, y: topPadding, width: self.viewDrawer.frame.width, height: self.viewDrawer.frame.height)

            self.viewDrawer.layoutIfNeeded()

                },  completion: {(_ completed: Bool) -> Void in
              
                    })
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnCrnt(_ sender: UIButton) {
        latitude = mylatitude
        longitude = mylongitude
        userAddress = myAddress
        if latitude == 0.0{
            homeView?.salons.removeAll()
            homeView?.viewNoDataSaloon.isHidden = false
            homeView?.saonHeight.constant = 280
            homeView?.allBarbers.removeAll()
            homeView?.viewNoDataBarber.isHidden = false
            homeView?.barberHeight.constant = 280            
            self.dismiss(animated: false)
        }else{
            homeView?.getTop10()
            homeView?.getAllBarbers()
            homeView?.lbladdress.text = userAddress
            self.dismiss(animated: false)
        }

    }
    
    @IBAction func btnSelect(_ sender: UIButton) {
        let stry = UIStoryboard(name: "Profile", bundle: nil)
        let vc = stry.instantiateViewController(withIdentifier: stryBrdId.addAddress) as! AddAddressViewController
        vc.isAddingFromHome = true
        if sender.tag == 0{
            vc.homeView = homeView
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MenuViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return address.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menu_cell_id", for: indexPath) as! CategColCell
        cell.lblItem.text = address[indexPath.row].nick_name
        cell.imgItem.image = UIImage(named: "address_list")
        
        cell.viewBg.layer.cornerRadius = 15
        cell.viewBg.layer.masksToBounds = true
        cell.viewBg.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        cell.viewBg.layer.borderWidth = 1

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 , height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addressSelected = true
        latitude = Double(self.address[indexPath.row].latitude ?? "0.0")!
        longitude = Double(self.address[indexPath.row].longitude ?? "0.0")!
        userAddress = self.address[indexPath.row].nick_name ?? ""
        
        homeView?.getTop10()
        homeView?.getAllBarbers()
        homeView?.lbladdress.text = userAddress
        
        self.dismiss(animated: false)
    }
}
