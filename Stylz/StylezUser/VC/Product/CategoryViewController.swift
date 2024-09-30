//
//  CategoryViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 13/08/23.
//

import UIKit
import StylesWebKit

class CategoryViewController: UIViewController {

    struct VCConst {
        static let cellId = "category_cell_id"
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var colCategory: UICollectionView!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var tblList: UITableView!


    var categories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.tintColor = getThemeColor()
        getCategory()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_category", comment: "")
        
      
    }
    
    func getCategory(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
            
           self.categories.removeAll()
            
        var details = [String:Any]()
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        StylzAPIFacade.shared.getCategory(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{

                    if let data = aRes?.json?["data"].array{
                        for m in data{
                            let booking = Categories(json: m)
                            self.categories.append(booking)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tblList.reloadData()
                    }
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
    
}

//extension CategoryViewController : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCConst.cellId, for: indexPath) as! ReOrderColCell
//        
//        cell.viewBg.layer.cornerRadius = 10
//        cell.viewBg.layer.masksToBounds = true
//        cell.viewBg.backgroundColor = getLightColor()
//        cell.viewBg.dropShadow(color: UIColor.lightGray)
//        
//        cell.lblPrice.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? categories[indexPath.item].name_ar :  categories[indexPath.item].name_en
//        setImage(imageView: cell.imgBg, url: categories[indexPath.item].service_category_icon ?? "")
//        return cell
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width / 4 - 20, height: collectionView.frame.width / 4)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.shops) as! ShopsViewController
//        vc.categoryId = self.categories[indexPath.item].id ?? 0
//        vc.name = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? categories[indexPath.item].name_ar ?? "" :  categories[indexPath.item].name_en ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
//}

extension CategoryViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! SalonListCell
        cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? categories[indexPath.item].name_ar :  categories[indexPath.item].name_en
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.shops) as! ShopsViewController
                vc.categoryId = self.categories[indexPath.item].id ?? 0
                vc.name = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? categories[indexPath.item].name_ar ?? "" :  categories[indexPath.item].name_en ?? ""
                self.navigationController?.pushViewController(vc, animated: true)

    }
}
