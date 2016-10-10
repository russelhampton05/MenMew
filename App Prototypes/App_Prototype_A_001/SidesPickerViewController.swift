//
//  SidesPickerViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/7/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class SidesPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Variables
    var choiceArray: [String]?
    @IBOutlet weak var sidesPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidesPicker.delegate = self
        sidesPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choiceArray![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let title = choiceArray![row]
        let customStyle = NSAttributedString(string: title, attributes: [NSFontAttributeName:UIFont(name:"HelveticaNeue-Light", size: 18.0)!, NSForegroundColorAttributeName: UIColor.white])
        
        label.attributedText = customStyle
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choiceArray!.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
