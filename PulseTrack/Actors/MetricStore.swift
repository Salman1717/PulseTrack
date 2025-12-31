//
//  MetricStore.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

//Owns and protects  Shared Metric State from data races.
///A data race occurs when multiple threads or concurrent tasks access the same memory location at the same time, at least one access is a write operation,
///and there is no synchronization mechanism in place.
///This leads to undefined behavior, which can manifest as unpredictable results, data corruption, subtle bugs, or app crashes  that are difficult to reproduce

actor MetricStore{
    
    private var metrics: [Metric] = []
    
    /// Replace store metrics safely.
    func set(_ newMetrics: [Metric]){
        metrics = newMetrics
    }
    
    /// Read metrics safely.
    func get() -> [Metric] {
        metrics
    }
    
    /// Clear stored metrics.
    func clear(){
        metrics.removeAll()
    }
}
