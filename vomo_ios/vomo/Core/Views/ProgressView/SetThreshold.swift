//
//  SetThreshold.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/1/22.
//

import SwiftUI

struct SetThreshold: View {
    @ObservedObject var settings = Settings.shared
    @Binding var popUp: Bool
    @Binding var selection: Int
    @Binding var min: Int
    @Binding var max: Int
    
    let content_width = 285.0
    let svm = SharedViewModel()
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack {
            header
            
            HStack {
                lessThan
                
                middle
                
                moreThan
            }
            .padding(.vertical, 5)
            .font(._bodyCopy)
            .foregroundColor(Color.BODY_COPY)
        }
        .frame(width: content_width, height: 175).opacity(0.95)
        .background(Color.white.shadow(color: Color.black.opacity(0.2), radius: 5))
        .onChange(of: focused) { focus in
            settings.keyboardShown = focus
        }
        .focused($focused)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") {
                    focused = false
                }
                .font(._subHeadline)
                .foregroundColor(Color.DARK_PURPLE)
            }
        }
    }
}

extension SetThreshold {
    private var lessThan: some View {
        VStack {
            Button(action: {
                selection = 1
            }) {
                Image(selection == 1 ? svm.min_img : svm.gray_min_img)
                    .thresholdImg()
            }
            
            VStack(alignment: .center, spacing: 0) {
                Text("Less than")
                TextField("XX", value: $min, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .font(._bodyCopy)
                    .focused($focused)
            }
        }
        .frame(width: content_width / 3)
    }
    
    private var middle: some View {
        VStack {
            Button(action: {
                selection = 2
            }) {
                Image(selection == 2 ? svm.mid_img : svm.gray_mid_img)
                    .thresholdImg()
            }
            
            VStack(alignment: .center, spacing: 0) {
                Text("Between")
                
                HStack(spacing: -20) {
                    TextField("XX", value: $min, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .font(._bodyCopy)
                        .focused($focused)
                    TextField("XX", value: $max, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .font(._bodyCopy)
                        .focused($focused)
                }
            }
        }
        .frame(width: content_width / 3)
    }
    
    private var moreThan: some View {
        VStack {
            Button(action: {
                selection = 3
            }) {
                Image(selection == 3 ? svm.max_img : svm.gray_max_img)
                    .thresholdImg()
            }
            
            VStack(alignment: .center, spacing: 0) {
                Text("More than")
                TextField("XX", value: $max, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .font(._bodyCopy)
                    .focused($focused)
            }
        }
        .frame(width: content_width / 3)
    }
    
    private var header: some View {
        ZStack {
            Text("Choose your acceptable\nscore range:")
                .multilineTextAlignment(.center)
                .font(._recordingPopUp)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.popUp.toggle()
                    }) {
                        Image(svm.exit_button)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.trailing, 10)
        }
    }
}

struct SetThreshold_Previews: PreviewProvider {
    static var previews: some View {
        SetThreshold(popUp: .constant(true), selection: .constant(0), min: .constant(0), max: .constant(100))
            .environmentObject(Entries())
            .environmentObject(AudioRecorder())
    }
}
