//
//  MetricServiceProtocol.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

//MARK: Allows easy swapping of implementations and testing
// Abrstracts the datasources (API, sensor, mock,etc.)

protocol MetricServiceProtocol{
    ///Fetches metrics asynchronously without blocking the main thread
    func fetchMetric() async throws -> Metric
}
