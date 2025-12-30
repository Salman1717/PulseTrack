//
//  HeartRate.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

//MARK: Concrete implementation of the Metric protocol.
//Struct is used for models to get value semantics which is safe for asyn code and avoids shared mutable state

struct HeartRate: Metric {
    let id = UUID()
    
    let bpm: Int
    
    var name: String {
        "Heart Rate"
    }
    
    ///Formatted value for UI display
    /// Keeping formatting inside the model keeps Views clean.
    var value: String{
        "\(bpm) BPM"
    }
    
}
