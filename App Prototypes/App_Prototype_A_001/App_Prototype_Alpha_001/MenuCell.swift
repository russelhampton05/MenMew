//
//  MenuCell.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/12/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class MenuCell : UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodDesc: UILabel!
    @IBOutlet weak var foodShadow: UIImageView!
    @IBOutlet weak var shadowHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    
    var isObserving = false
    
    //Cell heights
    class var expandedHeight: CGFloat { get { return 300 } }
    class var normalHeight: CGFloat { get { return 180 } }
    
    //Check for the cell's height to show or hide details
    func checkHeight() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.foodDesc.isHidden = (self.frame.size.height < MenuCell.expandedHeight)
            self.addButton.isHidden = (self.frame.size.height < MenuCell.expandedHeight)
        })
        
        if frame.size.height < MenuCell.expandedHeight {
            UIView.animate(withDuration: 0.1, animations: {
                self.shadowHeight.constant = 50
            })
        }
        else {
            UIView.animate(withDuration: 0.1, animations: {
                self.shadowHeight.constant = 100
            })
        }
    }
    
    //Subscribe the cell for observing frame changes
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            checkHeight()
        }
    }
    
    //Unsubscribe the cell for observing frame changes
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
    }
    
    //Override for actual height observation
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }

    deinit {
        ignoreFrameChanges()
    }
}
