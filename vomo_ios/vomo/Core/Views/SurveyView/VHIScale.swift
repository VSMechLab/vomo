//
//  Scale.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/7/22.
//

import SwiftUI
import UIKit

struct VHIScale: View {
    @Binding var responses: [Double]
    let prompt: String
    let index: Int
    
    let svm = SharedViewModel()
    
    @State private var position: Double = -1.0
    
    let dotSize = 35.0
    
    var body: some View {
        ZStack {
            background
            textPrompt
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    if position == -1 {
                        HStack(spacing: 0) {
                            // 0. Never
                            Button(action: {
                                self.position = 0
                            }) {
                                Image(position == 0 ? svm.select_img : "").resizable().frame(width: dotSize, height: dotSize)
                                    .shadow(color: .gray, radius: 5)
                            }
                            
                            Spacer()
                            
                            // 1. Almost Never
                            Button(action: {
                                self.position = 1
                            }) {
                                Image(position == 1 ? svm.select_img : "").resizable().frame(width: dotSize, height: dotSize)
                                    .shadow(color: .gray, radius: 5)
                            }
                            
                            Spacer()
                            
                            // 2. Sometimes
                            Button(action: {
                                self.position = 2
                            }) {
                                Image(position == 2 ? svm.select_img : "").resizable().frame(width: dotSize, height: dotSize)
                                    .shadow(color: .gray, radius: 5)
                            }
                            
                            Spacer()
                            
                            // 3. Almost Always
                            Button(action: {
                                self.position = 3
                            }) {
                                Image(position == 3 ? svm.select_img : "").resizable().frame(width: dotSize, height: dotSize)
                                    .shadow(color: .gray, radius: 5)
                            }
                            
                            Spacer()
                            
                            // 4. Always
                            Button(action: {
                                self.position = 4
                            }) {
                                Image(position == 4 ? svm.select_img : "").resizable().frame(width: dotSize, height: dotSize)
                                    .shadow(color: .gray, radius: 5)
                            }
                        }
                        .padding(.bottom, 25)
                        .onChange(of: self.position) { selection in
                            if responses.count > 0 {
                                self.responses[index] = selection
                            }
                        }
                    } else {
                        UISliderView(value: $position, minValue: 0.0, maxValue: 4.0, thumbColor: .purple, minTrackColor: .clear, maxTrackColor: .clear)
                            .shadow(color: .gray, radius: 5)
                            .padding(.bottom, 25)
                    }
                }
            }
        }
        .padding(1.0)
        .onChange(of: self.position) { selection in
            if responses.count > 0 {
                self.responses[index] = selection
            }
        }
    }
}

extension VHIScale {
    private var background: some View {
        Image(svm.scale_img)
            .resizable()
            .scaledToFit()
            .shadow(color: Color.gray.opacity(0.9), radius: 1)
    }
    
    private var textPrompt: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(prompt)
                    .font(._question)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 0.1)
                Spacer()
            }
            Spacer()
        }.padding(7.5)
    }
}

struct VHIScale_Previews: PreviewProvider {
    static var previews: some View {
        VHIScale(responses: .constant([1]), prompt: "test", index: 0)
    }
}

struct UISliderView: UIViewRepresentable {
     @Binding var value: Double
 
     var minValue = 0.0
     var maxValue = 4.0
     var thumbColor: UIColor = .white
     var minTrackColor: UIColor = .blue
     var maxTrackColor: UIColor = .lightGray
 
    class Coordinator: NSObject {
        var value: Binding<Double>

        init(value: Binding<Double>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            let roundedValue = round(sender.value / 1) * 1
            sender.value = roundedValue
            
            self.value.wrappedValue = Double(sender.value)//Double(Int(sender.value))
        }
    }

    func makeCoordinator() -> UISliderView.Coordinator {
        Coordinator(value: $value)
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        slider.setThumbImage(UIImage(named: "VM_11-select-btn-ds")?.resized(to: CGSize(width: 35, height: 35)), for: .normal)
        slider.setThumbImage(UIImage(named: "VM_11-select-btn-ds")?.resized(to: CGSize(width: 35, height: 35)), for: .highlighted)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
