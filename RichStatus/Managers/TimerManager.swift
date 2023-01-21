//
//  TimerManager.swift
//  RichStatus
//
//  Created by Kamyar on 18/01/2023.
//

import Foundation

final class TimerManager: ObservableObject {

    @Published var timerStat: TimerState
    @Published var timerString: String
    var nowDate: Date
    var referenceDate: Date

    init() {
        self.timerStat = AppData.timerRemaining == 0 ? .stoped : .paused
        self.timerString = "Timer"
        self.nowDate = Date()
        self.referenceDate = Date().addingTimeInterval(AppData.timerRemaining)
    }

    func startTimer() {

        self.timerStat = .counting
        self.referenceDate = Date().addingTimeInterval(AppData.timerRemaining)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            if AppData.timerRemaining < 0 {
                timer.invalidate()
                self.timerStat = .stoped
                return
            }
            switch self.timerStat {
            case .counting:
                self.nowDate = Date()
                AppData.timerRemaining = self.referenceDate.timeIntervalSinceNow
                self.timerString = self.countDownString()
            case .paused:
                timer.invalidate()

            case .stoped:
                self.timerString = "Timer"
                AppData.timerRemaining = 0
                timer.invalidate()
            }
        })
    }

    func countDownString() -> String {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour, .minute, .second],
                                                 from: self.nowDate,
                                                 to: self.referenceDate)
        if [components.hour, components.minute, components.second].allSatisfy({ $0 == 0 }) {
            DispatchQueue.main.async {
                self.timerStat = .stoped
            }
            return "Times up!"
        } else if [components.hour, components.minute].allSatisfy({ $0 == 0 }) {
            return String(format: "%02d",
                          components.second ?? 00)
        } else if components.hour == 0 {
            return String(format: "%02d:%02d",
                          components.minute ?? 00,
                          components.second ?? 00)
        } else {
            return String(format: "%02d:%02d:%02d",
                          components.hour ?? 00,
                          components.minute ?? 00,
                          components.second ?? 00)
        }
    }

    enum TimerState {
        case paused
        case stoped
        case counting

        var image: String {
            switch self {

            case .paused:
                return "pause.circle"
            case .stoped:
                return "stop.circle"
            case .counting:
                return "timer"
            }
        }
    }
}
