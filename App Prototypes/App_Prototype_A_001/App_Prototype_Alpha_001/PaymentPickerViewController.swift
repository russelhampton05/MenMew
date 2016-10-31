//
//  PaymentPickerViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/31/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PaymentPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Variables
    var payments: [Payment]?
    
    //IBOutlets
    @IBOutlet var paymentPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        paymentPicker.delegate = self
        paymentPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return payments![row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let title = payments![row].name
        
        let customStyle = NSAttributedString(string: title!, attributes: [NSFontAttributeName:UIFont(name:"HelveticaNeue-Light", size: 24.0)!, NSForegroundColorAttributeName: UIColor.white])
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return payments!.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
