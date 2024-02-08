//
//  NotificationDemo.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct NotificationDemo: View {
    @State private var showWarning = false
    @Environment (\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            Button("send notification") {
                PomodoroNotification.scheduleNotification(seconds: 5, title: "This is the title", body: "Some message")
            }
            
            if showWarning {
                VStack {
                    Text("Notifications are disabled")
                    Button("Enable") {
                        DispatchQueue.main.async {
                            // open settings
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                PomodoroNotification.checkAuthorization { authorized in
                    showWarning = !authorized
                }
            }
        }
    }
}

#Preview {
    NotificationDemo()
}
