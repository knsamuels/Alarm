//
//  AlarmListTableViewController.swift
//  alarm34
//
//  Created by Kristin Samuels  on 6/8/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as? SwitchTableViewCell else {return UITableViewCell()}
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        cell.updateViews(with: alarm)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? AlarmDetailTableViewController else {return}
                let alarm = AlarmController.shared.alarms[indexPath.row]
                destination.alarm = alarm
            }
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let alarmToUpdate = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleIsOn(alarm: alarmToUpdate)
        cell.updateViews(with: alarmToUpdate)
    }
}
