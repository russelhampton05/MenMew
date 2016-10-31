//
//  PaymentDetailsViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/31/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PaymentDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Variables
    var ticket: Ticket?
    var payments: [Payment] = []
    var selectedPayment: Payment?
    
    //IBOutlets
    @IBOutlet var ticketLabel: UILabel!
    @IBOutlet var paymentPicker: UIPickerView!
    
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        //Sample data    
        payments.append(Payment(name: "XXXX-1234", type: "VISA"))
        payments.append(Payment(name: "XXXX-4567", type: "MasterCard"))
        payments.append(Payment(name: "jdoe@gmail.com", type: "PayPal"))
        payments.append(Payment(name: "XX23ARW2", type: "Rewards Card"))
        
        ticketLabel.text = ticket!.desc!
        
        
        paymentPicker.delegate = self
        paymentPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPayment = payments[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return payments[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let title = payments[row].name
        
        let customStyle = NSAttributedString(string: title!, attributes: [NSFontAttributeName:UIFont(name:"HelveticaNeue-Light", size: 24.0)!, NSForegroundColorAttributeName: UIColor.white])
        
        label.attributedText = customStyle
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return payments.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        
        let confirmPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        
        self.addChildViewController(confirmPopup)
        self.view.addSubview(confirmPopup.view)
        confirmPopup.didMove(toParentViewController: self)
        confirmPopup.item = selectedPayment?.name
        confirmPopup.addMessage(context: "PayOrder")
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToSummarySegue", sender: self)
    }
}
