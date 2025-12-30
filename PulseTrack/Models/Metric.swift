//
//  Metrics.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 30/12/25.
//

import Foundation

//MARK:  Protocols are used to decouple UI  from data sources making the app testable and extensible
//Defines a common interface for all metrics (Heart Rate, Steps, Weather, etc.)

protocol Metric{
    var id: UUID { get }
    var name: String { get }
    var value: String { get }
}
