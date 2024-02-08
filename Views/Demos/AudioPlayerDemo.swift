//
//  SwiftUIView.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct AudioPlayerDemo: View {
    var audioPlayer = PomodoroAudio()
    var body: some View {
        VStack {
            Button("play done") {
                audioPlayer.play(.done)
            }
            Button("play tick") {
                audioPlayer.play(.tick)
            }
        }
    }
}

#Preview {
    AudioPlayerDemo()
}
