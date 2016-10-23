//
//  PaymentTableViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/23/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PaymentTableViewController: UITableViewController {
    
    //Variables
    var paymentList: [Payment]?
    var selectedPayment: Payment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentList!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath)

        cell.textLabel!.text = paymentList![indexPath.row].name
        cell.detailTextLabel!.text = paymentList![indexPath.row].type
        
        let bgView = UIView()
        bgView.backgroundColor = UIColorFromHex(rgbValue: 0xFF6A5C)
        cell.selectedBackgroundView = bgView
        cell.textLabel?.highlightedTextColor = self.view.backgroundColor
        cell.detailTextLabel?.highlightedTextColor = self.view.backgroundColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayment = paymentList![indexPath.row]
        
        
        
        if let parentVC = self.parent as? PaymentViewController {
            parentVC.currentPayment = selectedPayment
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
