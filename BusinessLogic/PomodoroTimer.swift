//
//  PomodoroTimer.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import Foundation
import Observation

enum PomodoroTimerState: String {
    case idle
    case running
    case paused
}

enum PomodoroTimerMode: String {
    case work
    case pause
}

@Observable
class PomodoroTimer {
    // timer -> tick every second
    // properties -> how many seconds left / passed
    //            -> fraction 0-1
    //            -> String ... 10:42
    // methods -> play, pause, resume, reset, skip
    // helper functions
    
    private var _mode: PomodoroTimerMode = .work
    private var _state: PomodoroTimerState = .idle
    
    private var _durationWork: TimeInterval
    private var _durationBreak: TimeInterval
    
    private var _secondsPassed: Int = 0
    private var _fractionPassed: Double = 0
    private var _dateStarted: Date = Date.now
    private var _secondsPassedBeforePause: Int = 0
    
    private var _timer: Timer?
    
    private var _audio: PomodoroAudio = PomodoroAudio()
    
    private var _workActivityName: String = "Work"
    private var _breakActivityName: String = "Break"
    
    
    init(workInSeconds: TimeInterval, breakInSeconds: TimeInterval) {
        _durationWork = workInSeconds
        _durationBreak = breakInSeconds
    }
    
    // MARK: Computed Properties
    var workActivityName: String {
        return _workActivityName
    }
    
    var breakActivityName: String {
        return _breakActivityName
    }
    
    var durationWorkInSeconds: Int {
        return Int(_durationWork)
    }
    
    var durationBreakInSeconds: Int {
        return Int(_durationBreak)
    }
    
    var durationWork: String {
        return _formatSeconds(Int(_durationWork))
    }
    
    var durationBreak: String {
        return _formatSeconds(Int(_durationBreak))
    }
    
    var durationString: String {
        return _formatSeconds(Int(_duration))
    }
    
    var secondsPassed: Int {
        return _secondsPassed
    }
    
    var secondsPassedString: String {
        return _formatSeconds(_secondsPassed)
    }
    
    var secondsLeft: Int {
        Int(_duration) - _secondsPassed
    }
    
    var secondsLeftString: String {
        return _formatSeconds(secondsLeft)
    }
    
    var fractionPassed: Double {
        return _fractionPassed
    }
    
    var fractionLeft: Double {
        1.0 - _fractionPassed
    }

    var state: PomodoroTimerState {
        _state
    }
    
    var mode: PomodoroTimerMode {
        _mode
    }
    
    var currentActivityName: String {
        if mode == .work {
            return _workActivityName
        } else {
            return _breakActivityName
        }
    }
    
    private var _duration: TimeInterval {
        if mode == .work {
            return _durationWork
        } else {
            return _durationBreak
        }
    }
    
    //MARK: Public Methods
    func changeWorkActivityName(name: String) {
        _workActivityName = name
    }
    
    func changeBreakActivityName(name: String) {
        _breakActivityName = name
    }
    
    func start() {
        _dateStarted = Date.now
        _secondsPassed = 0
        _fractionPassed = 0
        _state = .running
        _createTimer()
    }
    
    func resume() {
        _dateStarted = Date.now
        _state = .running
        _createTimer()
    }
    
    func pause() {
        _secondsPassedBeforePause = _secondsPassed
        _state = .paused
        _killTimer()
    }
    
    func reset() {
        _secondsPassed = 0
        _fractionPassed = 0
        _secondsPassedBeforePause = 0
        _state = .idle
        _killTimer()
    }
    
    func skip() {
        if self._mode == .work {
            self._mode = .pause
        } else {
            self._mode = .work
        }
        _state = .idle
    }
    
    func setWorkTime(workTime: Int) {
        _durationWork = TimeInterval(workTime)
    }
    
    func setBreakTime(breakTime: Int) {
        _durationBreak = TimeInterval(breakTime)
    }
    
    //MARK: Private method
    private func _createTimer() {
        //schedule notification
        PomodoroNotification.scheduleNotification(seconds: TimeInterval(secondsLeft), title: "Timer Done", body: "Your Pomodoro timer is done")
        //create timer
        _timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self._onTick()
        }
    }
    
    private func _killTimer() {
        _timer?.invalidate()
        _timer = nil
    }
    
    private func _onTick() {
        // calculate the seconds since start date
        let secondsSinceStartDate = Date.now.timeIntervalSince(self._dateStarted)
        // add the seconds before paused (if any)
        self._secondsPassed = Int(secondsSinceStartDate) + self._secondsPassedBeforePause
        // calculate fraction
        self._fractionPassed = TimeInterval(self._secondsPassed) / self._duration
        // play tick
        _audio.play(.tick)
        // done? play sound, reset, switch (work -> pause -> work), reset timer
        if self.secondsLeft == 0 {
            self._fractionPassed = 0
            self.skip() // to switch mode
            self.reset() // also resets timer
            // play ending sound
            _audio.play(.done)
        }
    }
    
    private func _formatSeconds(_ seconds: Int) -> String {
        if seconds <= 0 {
            return "00:00"
        }
        let hh: Int = seconds / 3600
        let mm: Int = (seconds % 3600) / 60
        let ss: Int = seconds % 60
        
        if hh > 0 {
            return String(format: "%02d:%02d:%02d", hh, mm, ss)
        }
        else {
            return String(format: "%02d:%02d", mm, ss)
        }
    }
}
