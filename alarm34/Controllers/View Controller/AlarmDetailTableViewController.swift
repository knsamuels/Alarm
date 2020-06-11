//
//  AlarmDetailTableViewController.swift
//  alarm34
//
//  Created by Kristin Samuels  on 6/8/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    // MARK: Outlets
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else {return}
            alarmIsOn = alarm.enabled
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var alarmTitleText: UITextField!
    @IBOutlet var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    @IBAction func enabledButtonTapped(_ sender: Any) {
        alarmIsOn.toggle()
        if alarmIsOn == true {
            enableButton.setTitle("Turn Off", for: .normal)
            enableButton.backgroundColor = .white
            
        } else {
            if alarmIsOn == false {
                enableButton.setTitle("Turn On", for: .normal)
                    enableButton.backgroundColor = .black
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let alarm = alarm,
            let name = alarmTitleText.text {
            let fireDate = datePicker.date
            AlarmController.shared.update(alarm: alarm, fireDate: fireDate, name: name, enabled: alarmIsOn)
        } else {
            let name = alarmTitleText.text ?? "Alarm"
            let fireDate = datePicker.date
            AlarmController.shared.addAlarm(fireDate: fireDate, name: name, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard let alarm = alarm else {return}
        alarmTitleText.text = alarm.name
        datePicker.date = alarm.fireDate
        if self.alarm?.enabled == true {
            enableButton.setTitle("Turn Off", for: .normal)
        } else {
            if self.alarm?.enabled == false {
                enableButton.setTitle("Turn On", for: .normal
                )
            }
        }
    }
}
