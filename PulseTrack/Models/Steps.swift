//
//  Steps.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

//MARK: Another Concrete Steps Model that uses the Metric Protocol

struct Steps: Metric {
    let id = UUID()
    
    let count: Int
    
    var name: String{
        "Steps"
    }
    
    var value: String{
        "\(count) steps"
    }
}
