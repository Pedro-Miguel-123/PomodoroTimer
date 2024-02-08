//
//  CustomDialog.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct CustomDialog: View {
    @State var timer: PomodoroTimer
    @State private var showPickerWork: Bool = false
    @State private var showPickerBreak: Bool = false
    @Binding var isActive: Bool
    
    private let data: [[String]] = [
        Array(0...24).map {"\($0)"},
        Array(0...59).map {"\($0)"},
        Array(0...59).map {"\($0)"}
    ]
    
    
    @State var totalTimeWork: Int
    @State var totalTimeBreak: Int
    @State var selectionWork: [Int]
    @State var selectionBreak: [Int]
    
    
    var body: some View {
        VStack {
            Spacer()
            Text("Change duration")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(50)
        
            Text("\(timer.workActivityName) time")
                .font(.title2)
                .padding()
            
            if showPickerWork {
                PickerView(data: self.data, selections: self.$selectionWork)
                    .background(.clear)
            }
            
            Text("\(timer.durationWork)")
                .font(.title3)
                .onTapGesture {
                    closePickerBreak()
                    showPickerWork = true
            }
            
            Text("\(timer.breakActivityName) time")
                .font(.title2)
                .padding()
            
            if showPickerBreak {
                PickerView(data: self.data, selections: self.$selectionBreak)
            }
            
            Text("\(timer.durationBreak)")
                .font(.title3)
                .onTapGesture {
                    closePickerWork()
                    showPickerBreak = true
            }
            Spacer()
            Button("Submit") {
                totalTimeWork = Int(calculateTimeInSeconds(selectionWork))
                totalTimeBreak = Int(calculateTimeInSeconds(selectionBreak))
                timer.setWorkTime(workTime: totalTimeWork)
                timer.setBreakTime(breakTime: totalTimeBreak)
                isActive = false
            }
        }
    }
    
    func closePickerWork() {
        showPickerWork = false
        totalTimeWork = Int(calculateTimeInSeconds(selectionWork))
        timer.setWorkTime(workTime: totalTimeWork)
    }
    
    func closePickerBreak() {
        showPickerBreak = false
        totalTimeBreak = Int(calculateTimeInSeconds(selectionBreak))
        timer.setBreakTime(breakTime: totalTimeBreak)
    }
    
    private func calculateTimeInSeconds(_ selection: [Int]) -> TimeInterval {
        let minutes = selection[1]
        let seconds = selection[2]
        let hours = selection[0]
        
        let totalSeconds = seconds + (minutes * 60) + (hours * 3600)
        return TimeInterval(totalSeconds)
    }
}

#Preview {
    CustomDialog(timer: PomodoroTimer(workInSeconds: 10, breakInSeconds: 5),isActive: .constant(true), totalTimeWork: 10, totalTimeBreak: 5, selectionWork: [10 / 3600, (10 % 3600) / 60, 10 % 60], selectionBreak: [5 / 3600, (5 % 3600) / 60, 5 % 60])
}
