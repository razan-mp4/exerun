//
//  RunSessionModel.swift
//  exerun
//
//  Created by Nazar Odemchuk on 28/8/2024.
//

import Foundation

class RunSessionModel {
    // Properties to hold the running statistics
    var time: String
    var pace: String
    var elevation: String
    var avgPace: String
    var speed: String
    var distance: String
    var heartRate: String
    
    // Initialization
    init() {
        // Initial values, you can modify as needed
        self.time = "00:00:00"
        self.pace = "0'00''/km"
        self.elevation = "0 m"
        self.avgPace = "0'00''/km"
        self.speed = "0.0 km/h"
        self.distance = "0.0 km"
        self.heartRate = "0 bpm"
    }
    
    // Function to update the time, could be called by a timer
    func updateTime(hours: Int, minutes: Int, seconds: Int) {
        self.time = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Function to update pace, speed, and other stats
    func updateStats(pace: String, elevation: String, avgPace: String, speed: String, distance: String, heartRate: String) {
        self.pace = pace
        self.elevation = elevation
        self.avgPace = avgPace
        self.speed = speed
        self.distance = distance
        self.heartRate = heartRate
    }
}
