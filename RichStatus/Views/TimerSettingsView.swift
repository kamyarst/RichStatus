//
//  TimerSettingsView.swift
//  RichStatus
//
//  Created by Kamyar on 18/01/2023.
//

import SwiftUI

struct TimerSettingsView: View {
    
    @State var isOn = AppData.featureTimer
    @State var timerHasAlert = AppData.timerHasAlert
    @State var string: String = "\(Int(AppData.timerRemaining / 60))"
    
    var body: some View {
        List {
            Toggle("Show in Menu", isOn: $isOn)
                .toggleStyle(.switch)
            Divider()
            Toggle("Alert on finish", isOn: $timerHasAlert)
                .toggleStyle(.switch)
            Divider()
            HStack {
                Text("Default Timer")
                Spacer()
                HStack {
                    TextField("", text: $string, onCommit: {
                        let value = Double(self.string.filter { $0.isNumber }) ?? 45
                        AppData.timerRemaining = value * 60
                    })
                        .textContentType(.oneTimeCode)
                        
                        .frame(width: 30)
                        .cornerRadius(4)
                        
                    Text("min")
                }
                .padding(8)
                .background(.selection)
                .cornerRadius(8)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(8)
        .padding(16)
        .listStyle(.inset)
    }
}

struct TimerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingsView(isOn: true, timerHasAlert: true, string: "45")
    }
}
