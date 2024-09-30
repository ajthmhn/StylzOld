//
//  SelfSizedTableView.swift
//  HydMemberApp
//
//  Created by Aamir Shaikh on 12/4/20.
//  Copyright © 2020 Gexton. All rights reserved.
//

import Foundation
import  UIKit
class SelfSizedTableView: UITableView {
 
 public  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
 public static  var minWidth = 20
 public static var maxHeightMinus = 0
 
    override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
    self.layoutIfNeeded()
  }
  
    //for setting maxHeight
  /*override var intrinsicContentSize: CGSize {
    
    print("content Size \(contentSize.height)")

    let height = min(contentSize.height+50, maxHeight)
  
  //  let height = min(contentSize.height,maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }*/
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
       // let height = min
       // let height = min(contentSize.height,maxHeight+UITableView)
         // return CGSize(width: contentSize.width, height: height)
           return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }


//    override var intrinsicContentSize: CGSize {
//        layoutIfNeeded()
//        maxHeight=contentSize.height
//        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//    }

}

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                     height: contentSize.height + adjustedContentInset.top)
    }
}
