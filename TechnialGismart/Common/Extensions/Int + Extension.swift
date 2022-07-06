//
//  Int + Extension.swift
//  Techical
//
//  Created by Egor Evseenko on 05.07.22.
//

import UIKit

enum TimeState {
    case seconds
    case minutes
    case hours
    case days
}

extension Int {
    func convertToDate(_ state: TimeState) -> String {
        switch state {
        case .seconds:
            return String(format: "%02d", self % 60)
        case .minutes:
            return String(format: "%02d", (self / 60) % 60)
        case .hours:
            return String(format: "%02d", (self / 3600))
        case .days:
            return String(format: "%02d", (self / (3600 * 24)))
        }
    }
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        return formatter.string(from: Double(self)) ?? ""
    }

}
