//
//  AppError.swift
//  PulseTrack
//
//  Created by Salman Mhaskar on 31/12/25.
//

import Foundation

// Represents users facing an error in a clean and readable way.

enum AppError: LocalizedError {
    case failedToLoad
    
    var errorDescription: String? {
        switch self{
        case .failedToLoad:
            return "Failed to load data. Please try again."
        }
    }
}
