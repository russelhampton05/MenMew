//
//  MessagePopupViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 11/12/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class MessagePopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //IBOutlets
    @IBOutlet var requestLabel: UILabel!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var popupView: UIView!

    //Variables
    var messages: [String] = []
    var selectedMessage: String?
    var didCancel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        loadMessages()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        loadTheme()
        
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        didCancel = true
        removeAnimate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as UITableViewCell!
        
        cell?.textLabel!.text = messages[indexPath.row]
        cell?.backgroundColor = currentTheme!.primary!
        cell?.textLabel!.textColor = currentTheme!.highlight!
        
        let bgView = UIView()
        bgView.backgroundColor = currentTheme!.highlight!
        cell?.selectedBackgroundView = bgView
        cell?.textLabel?.highlightedTextColor = currentTheme!.primary!
        cell?.detailTextLabel?.highlightedTextColor = currentTheme!.primary!
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessage = messages[indexPath.row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Popup view animation
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    //Popup remove animation
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool) in
            if (finished)
            {
                if !self.didCancel {
                    self.processMessage()
                }
                
                self.view.removeFromSuperview()
            }
        })
    }
    
    func processMessage() {
        if let parent = self.parent as? OrderSummaryViewController {
            if selectedMessage != nil {
                
                if selectedMessage == "Request Refill" {
                    selectedMessage = "Requesting refill at Table \(currentUser!.ticket!.tableNum!)"
                }
                else if selectedMessage == "Request Seating" {
                    selectedMessage = "Requesting additional/change of seating at Table \(currentUser!.ticket!.tableNum!)"
                }
                else if selectedMessage == "Follow-up Order" {
                    selectedMessage = "Requesting a follow up on Ticket \(currentUser!.ticket!.desc!) at Table \(currentUser!.ticket!.tableNum!)"
                }
                else if selectedMessage == "Other Request" {
                    selectedMessage = "Requesting server assistance at Table \(currentUser!.ticket!.tableNum!)"
                }
                
                parent.sendMessage(message: selectedMessage!)
            }
        }
    }
    
    func loadMessages() {
        self.messages.append("Request Refill")
        self.messages.append("Request Seating")
        self.messages.append("Follow-up Order")
        self.messages.append("Other Request")
    }
    
    func loadTheme() {
        
        //Background and Tint
        view.tintColor = currentTheme!.highlight!
        popupView.backgroundColor = currentTheme!.primary!
        messageTableView.backgroundColor = currentTheme!.primary!
        messageTableView.sectionIndexBackgroundColor = currentTheme!.primary!
        
        //Labels
        requestLabel.textColor = currentTheme!.highlight!
        
        //Buttons
        confirmButton.backgroundColor = currentTheme!.highlight!
        confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
        cancelButton.backgroundColor = currentTheme!.highlight!
        cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
        
    }

}
