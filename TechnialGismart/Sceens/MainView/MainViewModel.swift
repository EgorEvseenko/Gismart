//
//  MainViewModel.swift
//  Techical
//
//  Created by Egor Evseenko on 05.07.22.
//

import UIKit
import Combine

final class MainViewModel {
    @Published var currentTime: Int = 60 * 60 * 24 // random time (24 hours)
    private var timer = Timer()
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(startTimer),
                                     userInfo: nil, repeats: true)
    }
    
    @objc func startTimer() {
        if currentTime > .zero {
            currentTime -= 1
        } else {
            timer.invalidate()
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
}
