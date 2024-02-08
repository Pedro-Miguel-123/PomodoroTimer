//
//  ThreeWayPicker.swift
//  PomodoroTimer
//
//  Created by Pedro Miguel Santos on 07/02/2024.
//

import SwiftUI

struct PickerView: UIViewRepresentable {
    var data: [[String]]
    
    @Binding var selections: [Int]
    
    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
            for i in 0...(self.selections.count - 1) {
                view.selectRow(self.selections[i], inComponent: i, animated: false)
            }
            context.coordinator.parent = self // fix
        }
        
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView
        
        //init(_:)
        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }
        
        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }
        
        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }
        
        //pickerView(_:titleForRow:forComponent:)
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[component][row]
        }
        
        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
    }
}

struct ThreeWayPicker: View {
    private let data: [[String]] = [
        Array(0...24).map {"\($0)"},
        Array(0...59).map {"\($0)"},
        Array(0...59).map {"\($0)"}
    ]
    
    @State private var selections: [Int] = [5, 10, 50]
    
    var body: some View {
        VStack {
            PickerView(data: self.data, selections: self.$selections)

            Text("\(self.data[0][self.selections[0]]) \(self.data[1][self.selections[1]]) \(self.data[2][self.selections[2]])")
        } //VStack
    }
}

#Preview {
    ThreeWayPicker()
}
