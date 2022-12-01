//
//  CustomSlider.swift
//  VoMo
//
//  Created by Neil McGrogan on 11/30/22.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var position: Int
    
    @State var slider: Float = 0
    @State var dragGestureTranslation: CGFloat = 0
    @State var lastDragValue: CGFloat = 0
    
    // Slider Draggable Control Settings
    var sliderWidth: CGFloat = 28
    var sliderPadding: CGFloat = 0 // This adds padding to each side
    
    // Stepped Increment
    @State var steppedSlider: Bool = false
    @State var step: Int = 8
    @State var stepInterval: CGFloat = 0
    
    let svm = SharedViewModel()
    
    func interval(width: CGFloat, increment: Int) -> CGFloat {
        print("Screen Width: \(width)")
        let result = width * CGFloat(increment) / CGFloat(step)
        return result
    }
    
    func roundToFactor(value: CGFloat, factor: CGFloat) -> CGFloat {
        return factor * round(value / factor)
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                // Slider Bar
                ZStack (alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.clear)
                } // End of Slider Bar
                .frame(width: geometry.size.width * 0.9, height: 3)
                .padding(.horizontal, 7.5)
                .padding(.vertical, 15) // Padding to centre the bar
                
                // Slider Stacker
                ZStack (alignment: .top) {
                    if steppedSlider {
                        // Step - Minused the SliderWidth so that it is evenly spaced
                        ForEach(0...step, id: \.self) { number in
                            Rectangle()
                                .frame(width: 2, height: 10)
                                .offset(x: interval(width: (geometry.size.width - sliderWidth), increment: number), y: 46)
                            
                            Text("\(number)")
                                .fontWeight(.bold)
                                .offset(x: interval(width: (geometry.size.width - sliderWidth), increment: number), y: 64)
                        }
                    }
                    
                    // Draggable Slider
                    ZStack {
                        Image(svm.select_img)
                            .resizable()
                            .frame(width: sliderWidth, height: 28)
                    }
                    .offset(x: CGFloat(slider))
                    .padding(.horizontal, sliderPadding)
                } // End of Slider ZStack
                .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ dragValue in
                                let translation = dragValue.translation
                                
                                dragGestureTranslation = CGFloat(translation.width) + lastDragValue
                                
                                // Set the start marker of the slider
                                dragGestureTranslation = dragGestureTranslation >= 0 ? dragGestureTranslation : 0
                                
                                // Set the end marker of the slider
                                dragGestureTranslation = dragGestureTranslation > (geometry.size.width - sliderWidth - sliderPadding * 2) ? (geometry.size.width - sliderWidth - sliderPadding * 2) :  dragGestureTranslation
                                
                                // Set the slider value (Stepped)
                                if steppedSlider {
                                    // Getting the stepper interval (where to place the marks)
                                    stepInterval = roundToFactor(value: dragGestureTranslation, factor: (geometry.size.width - sliderWidth - (sliderPadding * 2)) / CGFloat(step))
                                    
                                    // Get the increments for the stepepdInterval
                                    self.slider = min(max(0, Float(stepInterval)), Float(stepInterval))
                                } else {
                                    // Set the slider value (Fluid)
                                    self.slider = min(max(0, Float(dragGestureTranslation)), Float(dragGestureTranslation))
                                }

                            })
                            .onEnded({ dragValue in
                                // Set the start marker of the slider
                                dragGestureTranslation = dragGestureTranslation >= 0 ? dragGestureTranslation : 0
                                
                                // Set the end marker of the slider
                                dragGestureTranslation = dragGestureTranslation > (geometry.size.width - sliderWidth - sliderPadding * 2) ? (geometry.size.width - sliderWidth - sliderPadding * 2) : dragGestureTranslation
                                
                                // Storing last drag value
                                lastDragValue = dragGestureTranslation
                            })
                ) // End of DragGesture
            } // End of GeometryReader
            Text("")
            //Text("Slider: \(slider)")
                .onChange(of: slider) { _ in
                    position = Int((slider / 271) * 10)
                    print(position)
                }
        } // End of VStack
        .padding()
        .onAppear() {
            slider = Float(position * 271) / 10
        }
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider(position: .constant(3))
    }
}
