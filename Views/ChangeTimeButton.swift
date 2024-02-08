//
//  ChangeTimeButton.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct ChangeTimeButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
           action()
        } label: {
            Text("Change Durations")
        }
    }
}

#Preview {
    ChangeTimeButton() {
        print("hey")
    }
}
