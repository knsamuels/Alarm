//
//  SwitchTableViewCell.swift
//  alarm34
//
//  Created by Kristin Samuels  on 6/8/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {

   //MARK:- Outlets
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else { return}
            updateViews(with: alarm)
        }
    }
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var alarmSwitch: UISwitch!
    // MARK:- Actions

    weak var delegate: SwitchTableViewCellDelegate?
    
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
    func updateViews(with alarm: Alarm) {
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
        
        
    }
}
