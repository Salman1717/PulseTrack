//
//  StepsService.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

//MARK: Step service to fetch step data

struct StepsService : MetricServiceProtocol{
    
    func fetchMetric() async throws ->  Metric {
        /// Simulate network and sensor deplay
        try await Task.sleep(nanoseconds: 8_000_000_000)
        
        return Steps(count: Int.random(in: 1_000 ... 20_000))
    }
}
