//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct ContentView: View {
    private var timer = PomodoroTimer(workInSeconds: 10, breakInSeconds: 5)
    
    @State private var displayWarning = false
    @State var isActive: Bool = false
    @State var showActivityDialog: Bool = false
    @Environment(\.scenePhase) var scenePhase
    @State private var mainActivityName: String = ""
    @State private var breakActivityName: String = ""
    
    var body: some View {
        VStack {
            Button("Change activities") {
                showActivityDialog = true
            }
            .alert("Change Activities", isPresented: $showActivityDialog, actions: {
                TextField("Main Activity", text: $mainActivityName)
                TextField("Break Activity", text: $breakActivityName)
                
                Button("Save", action: {
                    timer.changeWorkActivityName(name: mainActivityName)
                    timer.changeBreakActivityName(name: breakActivityName)
                })
                Button("Cancel", role: .cancel, action: {
                    showActivityDialog = false
                })
            }, message: {
                Text("Please choose the new activities names")
            })
            .foregroundColor(Color("Light"))
            Spacer()
            CircleTimer(
                fraction: timer.fractionPassed,
                primaryText: timer.secondsLeftString,
                secondaryText: timer.currentActivityName,
                duration: timer.durationString
            )
            
            HStack {
                if timer.state == .idle && timer.mode == .pause {
                    CircleButton(icon: "forward.fill") {
                        timer.skip()
                    }
                }
                
                if timer.state == .idle {
                    CircleButton(icon: "play.fill") {
                        timer.start()
                    }
                }
                
                if timer.state == .paused {
                    CircleButton(icon: "play.fill") {
                        timer.resume()
                    }
                }
                
                if timer.state == .running {
                    CircleButton(icon: "pause.fill") {
                        timer.pause()
                    }
                }
                
                if timer.state == .running || timer.state == .paused {
                    CircleButton(icon: "stop.fill") {
                        timer.reset()
                    }
                }
            }
            if displayWarning {
                NotificationsDisabled()
            }
            
            Spacer()
            Button("Change durations") {
                isActive = true
            }
            .foregroundColor(Color("Light"))
            .sheet(isPresented: $isActive, onDismiss: didDismiss) {
                CustomDialog(
                    timer: timer,
                    isActive: $isActive,
                    totalTimeWork: timer.durationWorkInSeconds,
                    totalTimeBreak: timer.durationBreakInSeconds,
                    selectionWork: [timer.durationWorkInSeconds / 3600, (timer.durationWorkInSeconds % 3600) / 60, timer.durationWorkInSeconds % 60],
                    selectionBreak: [timer.durationBreakInSeconds / 3600, (timer.durationBreakInSeconds % 3600) / 60, timer.durationBreakInSeconds % 60]
                    )
                    .presentationCornerRadius(21)
                    .presentationBackground(.thickMaterial)
            }
            .padding(.vertical)
            
        }
        .frame(maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(
            RadialGradient(
                gradient: Gradient(colors: [Color("Light"), Color("Dark")]),
                center: .center,
                startRadius: 5,
                endRadius: 500
            )
        )
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                PomodoroNotification.checkAuthorization { authorized in
                    displayWarning = !authorized
                }
            }
        }
    }
    
    func didDismiss() {
    }
}

#Preview {
    ContentView()
}
