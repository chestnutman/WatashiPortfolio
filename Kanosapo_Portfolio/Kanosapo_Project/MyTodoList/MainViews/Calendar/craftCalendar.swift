//
//  craftCalendar.swift
//  MyTodoList
//
//  Created by 三浦 on 2020/09/23.
//  Copyright © 2020 古府侑樹. All rights reserved.
//

import UIKit
import Foundation

import EventKit
import RealmSwift



func craftCalendar(){
    print("craftCalendar")
    
    let no1point = 30
    let no23point = 1410
    let hour = (no23point - no1point)/23
    let minute:Double
    minute = Double(hour)/Double(60)
    
    let cal = realm.objects(Calendar24.self)
    let defaultcal = realm.objects(DefaultCalendar.self)
    
    for item in cal {
        let color = UIColor.black
        makeView(start: item.start, c_dotime: item.c_dotime, dotime: item.todo.first!.dotime, calendarid: item.calendarid, title: item.todo.first!.title, color: color)
        
    }
    print("DefaultCalendar")
    for item in defaultcal {
        let color = UIColor(displayP3Red: CGFloat(item.color_r), green: CGFloat(item.color_g), blue: CGFloat(item.color_b), alpha: 1.0)
        if(item.allDay == false){
            makeView(start: item.start, c_dotime: item.c_dotime, dotime: 0, calendarid: item.calendarid, title: item.title, color: color)
        
        }
    }
}
