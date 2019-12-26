//
//  CalendarService.swift
//  Pilltracker
//
//  Created by Robert Baker on 26/12/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import Foundation
import EventKit

class CalendarService {
    func updateCalendarEntries() {
        let pills = PillService().savedPills()
        for pill in pills {
            saveCalendarEntry(for: pill)
        }
    }
    
    func saveCalendarEntry(for pill: Pill) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if granted && error == nil {
                
                for dose in pill.doses {
                    let event: EKEvent = EKEvent(eventStore: eventStore)
                    let doseViewModel = DoseViewModel(pillModel: pill, doseModel: dose)
                     
                    event.notes = dose.id.uuidString
                    event.title = doseViewModel.friendlyDoseTitle()
                    event.startDate = dose.expectedDoseTime
                    event.endDate = dose.expectedDoseTime
                    event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil))
                    
                    let alarm = EKAlarm(absoluteDate: event.startDate)
                    event.alarms = [alarm]
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    do {
                        try eventStore.save(event, span: EKSpan.thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error: \(error)")
                        return
                    }
                }
            } else {
                // show settings alert
            }
        })
    }
}
