//
//  ActivityDialog.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 08/02/2024.
//

import SwiftUI

struct ActivityDialog: View {
    @State var timer: PomodoroTimer
    @Binding var showDialog: Bool
    @State private var offset: CGFloat = 1000
    
    @State var mainActivityName = ""
    @State var breakActivityName = ""
    
    var body: some View {
        ZStack {
            Color(.clear)
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            VStack {
                Text("Current Main Activity: \(timer.workActivityName)")
                    .font(.title2)
                    .padding()
                
                
                
                Text("Current Break Activity: \(timer.breakActivityName)")
                    .font(.title2)
                    .padding()
                
                Button {
                    close()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("Dark"))
                        
                        Text("Submit")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color("Light"))
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.black)
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding()
            .offset(x:0, y: offset)
            .onAppear {
                withAnimation(.spring(bounce: 0.3)) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            showDialog = false
        }
    }
}

#Preview {
    ActivityDialog(timer: PomodoroTimer(workInSeconds: 10, breakInSeconds: 5), showDialog: .constant(true))
}
