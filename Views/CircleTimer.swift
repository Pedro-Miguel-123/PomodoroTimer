//
//  CircleTimer.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct CircleTimer: View {
    let fraction: Double
    let primaryText: String
    let secondaryText: String
    let duration: String
    var body: some View {
        ZStack {
            //background circle
            Circle()
                .fill(Color("Dark")).opacity(0.5)
            
            //timer circle
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(Color("Light"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .opacity(0.8)
                .rotationEffect(.init(degrees: -90))
                .padding()
                .animation(.easeInOut, value: fraction)
            
            //primary text

            Text(primaryText)
                .font(.system(size: 50, weight: .semibold, design: .rounded))
                .foregroundColor(Color("Light"))
                
            //secondary text
            Text("\(secondaryText) for \(duration)")
                .font(.system(size: 30, weight: .light, design: .rounded))
                .foregroundColor(Color("Light"))
                .offset(y: 50)
            
        }
        .padding()
    }
}

#Preview {
    CircleTimer(
        fraction: 0.5, primaryText: "12:23", secondaryText: "Work", duration: "05:00"
    )
}
