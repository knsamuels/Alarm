//
//  AlarmController.swift
//  alarm34
//
//  Created by Kristin Samuels  on 6/8/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol AlarmScheduler : AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)

    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController: AlarmScheduler {

    var alarms: [Alarm] = []
    
    static let shared = AlarmController()
   
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        saveToPersistenceStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistenceStore()
    }
    func delete(alarm: Alarm){
        guard let index = alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: index)
        cancelUserNotifications(for: alarm)
    }
    func toggleIsOn (alarm: Alarm) {
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        alarm.enabled = !alarm.enabled
    }
    // MARK: Persistence
    // could be called get file url
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("alarm.json")
        return fileURL
        
    }
    // Save
    func saveToPersistenceStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(alarms)
           try data.write(to: createPersistenceStore())
        } catch {
            print("Error encoding our alarms: \(error) -- \(error.localizedDescription)")
        }
    }

    // Load
    func loadFromPersistenceStore() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            alarms = try jsonDecoder.decode([Alarm].self, from: data)
        } catch {
            print("Error decoding our alarms: \(error) -- \(error.localizedDescription)") 
        }
    }
}

extension AlarmScheduler {

    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = alarm.name
        notificationContent.body = "Your alarm is going off"
        notificationContent.sound = .default
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent , trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current()
            .removeDeliveredNotifications(withIdentifiers: [alarm.uuid])
    }
}
