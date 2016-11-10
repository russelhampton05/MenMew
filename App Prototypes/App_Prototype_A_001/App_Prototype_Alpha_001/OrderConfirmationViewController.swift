//
//  OrderConfirmationViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/20/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    //Variables
    var ticket: Ticket?
    
    //IBOutlets
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet var ticketLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var ticketTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        //Format date to more human-readable result
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = formatter.date(from: ticket!.timestamp!)
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        
        ticketLabel.text = ticket!.desc!
        dateLabel.text = formatter.string(from: currentDate!)
        
        loadTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        self.navigationController?.isNavigationBarHidden = false
        performSegue(withIdentifier: "UnwindToMainSegue", sender: self)
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.bgColor!
        self.view.tintColor = currentTheme!.hlColor!
        
        //Navigation
        UINavigationBar.appearance().backgroundColor = currentTheme!.bgColor!
        UINavigationBar.appearance().tintColor = currentTheme!.hlColor!
        self.navigationController?.navigationBar.barTintColor = currentTheme!.bgColor!
        
        //Labels
        orderTitle.textColor = currentTheme!.hlColor!
        ticketTitle.textColor = currentTheme!.hlColor!
        dateTitle.textColor = currentTheme!.hlColor!
        ticketLabel.textColor = currentTheme!.hlColor!
        dateLabel.textColor = currentTheme!.hlColor!
        
        
        //Buttons
        confirmButton.backgroundColor = currentTheme!.hlColor!
        confirmButton.setTitleColor(currentTheme!.textColor!, for: .normal)
    }
    
}
