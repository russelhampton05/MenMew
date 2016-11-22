//
//  RTableCell.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class RTableCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadTheme()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func loadTheme() {
        
        //Background and Tint
        self.backgroundColor = currentTheme!.primary!
        
        self.tintColor = currentTheme!.highlight!
        
        //Labels
        tableLabel.textColor = currentTheme!.highlight!
        ticketLabel.textColor = currentTheme!.highlight!
        statusLabel.textColor = currentTheme!.highlight!
        dateLabel.textColor = currentTheme!.highlight!
        
        //Buttons
    }
}
