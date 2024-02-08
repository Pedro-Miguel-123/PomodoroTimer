//
//  NotificationsDisabled.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct NotificationsDisabled: View {
    var body: some View {
        VStack {
            Text("Notification are disabled.")
                .font(.headline)
            Text("To be notified when a pomodoro period is over, enable notifications.")
                .font(.subheadline)
            Button("Open Settings") {
                openSettings()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color("Light"))
        .foregroundColor(Color("Dark"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    private func openSettings() {
        DispatchQueue.main.async {
            // open settings
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    VStack {
        NotificationsDisabled()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("Dark"))
}
