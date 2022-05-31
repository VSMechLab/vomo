//
//  ProfileView.swift
//  VoMo
//
//  Created by Neil McGrogan on 3/8/22.
//

import SwiftUI
import UIKit
import Foundation
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ProfileView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var recordingState: RecordingState
    
    @State private var name = UserDefaults.standard.string(forKey: "name") ?? ""
    @State private var gender = UserDefaults.standard.string(forKey: "gender") ?? ""
    @State private var dob = UserDefaults.standard.string(forKey: "dob") ?? ""
    @State private var voice_onset = UserDefaults.standard.bool(forKey: "voiceOnset")
    @State private var current_smoker = UserDefaults.standard.bool(forKey: "currentSmoker")
    @State private var have_reflux = UserDefaults.standard.bool(forKey: "haveReflux")
    @State private var have_asthma = UserDefaults.standard.bool(forKey: "haveAsthma")
    @State private var fteProfile = false
    @State private var focusSelection = UserDefaults.standard.integer(forKey: "focus_selection")
    
    let genderKey = "gender", dobKey = "dob"
    let voiceOnsetKey = "voiceOnset", currentSmokerKey = "currentSmoker"
    let haveRefluxKey = "haveReflux", haveAsthmaKey = "haveAsthma"
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    let entry_img = "VM_12-entry-field"
    let button_img = "VM_Gradient-Btn"
    let fieldWidth =  UIScreen.main.bounds.width - 50
    let toggleHeight: CGFloat = 37 * 0.95
    let img_selected = "VM_Prpl-Square-Btn copy"
    let img_unselected = "VM_Prpl-Check-Square-Btn"
    let prompt = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Care", "the Vocal Fold/Paresis", "no"]
    
    let content_width = 317.5
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Profile")
                .font(._headline)
            
            ScrollView(showsIndicators: false) {
                Text("Please enter the address assosciated with\nyour account")
                    .font(._bodyCopy)
                    .foregroundColor(Color.BODY_COPY)
                    .multilineTextAlignment(.center)
                
                ProfilePicturePicker()
                
                VStack(alignment: .leading) {
                    Group {
                        Text("Name")
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(height: toggleHeight)
                                .cornerRadius(7)
                            
                            HStack {
                                TextField(self.name.isEmpty ? "First and Last Name" : self.name, text: self.$name)
                                    .font(self.name.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            }.padding(.horizontal, 5)
                        }.frame(height: toggleHeight)
                        
                        Text("Gender")
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(height: toggleHeight)
                                .cornerRadius(7)
                            
                            HStack {
                                TextField(self.gender.isEmpty ? "Gender" : self.gender, text: self.$gender)
                                    .font(self.gender.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            }.padding(.horizontal, 5)
                        }.frame(height: toggleHeight)
                        
                        Text("Date of Birth")
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(height: toggleHeight)
                                .cornerRadius(5)
                            
                            HStack {
                                TextField(self.dob.isEmpty ? "00/00/0000" : self.dob, text: self.$dob)
                                    .font(self.dob.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            }.padding(.horizontal, 7)
                        }.frame(height: toggleHeight)
                    }
                    
                    Group {
                        Text("Voice Onset")
                        
                        HStack(spacing: 0) {
                            Button("") { self.voice_onset = true }.buttonStyle(YesButton(selected: voice_onset))
                            Spacer()
                            Button("") { self.voice_onset = false }.buttonStyle(NoButton(selected: voice_onset))
                        }
                        
                        
                        Text("Current Smoker / Vaper?")
                        
                        HStack(spacing: 0) {
                            Button("") { self.current_smoker = true }.buttonStyle(YesButton(selected: current_smoker))
                            Spacer()
                            Button("") { self.current_smoker = false }.buttonStyle(NoButton(selected: current_smoker))
                        }
                        
                        Text("Currently Have Reflux?")
                        
                        HStack(spacing: 0) {
                            Button("") { self.have_reflux = true }.buttonStyle(YesButton(selected: have_reflux))
                            Spacer()
                            Button("") { self.have_reflux = false }.buttonStyle(NoButton(selected: have_reflux))
                        }
                        
                        
                        Text("Currently Have Asthma?")
                        
                        HStack(spacing: 0) {
                            Button("") { self.have_asthma = true }.buttonStyle(YesButton(selected: have_asthma))
                            Spacer()
                            Button("") { self.have_asthma = false }.buttonStyle(NoButton(selected: have_asthma))
                        }
                    }
                }
                .font(._coverBodyCopy)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 0) {
                        Text("You are on \(prompt[focusSelection]) track ")
                            .font(._bodyCopy)
                            .foregroundColor(Color.BODY_COPY)
                        Button(action: {
                            viewRouter.currentPage = .voiceQuestionView
                        }) {
                            Text("Edit.")
                                .underline()
                                .font(._bodyCopy)
                                .foregroundColor(Color.DARK_PURPLE)
                        }
                        Spacer()
                    }
                    
                    
                    HStack {
                        Spacer()
                        Button("") { save() }.buttonStyle(SubmissionButton(label: "Update"))
                            .padding(.bottom, 80)
                        Spacer()
                    }
                    .frame(width: content_width)
                }.frame(width: content_width)
            }
            .frame(width: content_width)
        }.padding(.vertical)
    }
    
    func save() {
        UserDefaults.standard.set(self.name, forKey:  "name")
        UserDefaults.standard.set(self.dob, forKey:  "dob")
        UserDefaults.standard.set(self.gender, forKey:  "gender")
        UserDefaults.standard.set(self.voice_onset, forKey:  voiceOnsetKey)
        UserDefaults.standard.set(self.current_smoker, forKey: currentSmokerKey)
        UserDefaults.standard.set(self.have_reflux, forKey: haveRefluxKey)
        UserDefaults.standard.set(self.have_asthma, forKey: haveAsthmaKey)
    }
}

struct ProfilePicturePicker: View {
    
    let profile_placeholder = "VM_3-Profile-Picture-Input-Btn"
    @State private var image: Image?
    @State private var filterIntensity = 0.5

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?

    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    @State private var showingFilterSheet = false

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    if image == nil {
                        Image(profile_placeholder)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } else {
                        image?
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                //Button("Save", action: save)
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }


        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func save() {
        guard let processedImage = processedImage else { return }

        let imageSaver = ImageSaver()

        imageSaver.successHandler = {
            print("Success!")
        }

        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

/*
 
 var body: some View {
     VStack {
         Button("load Image now") {
             loadImage()
         }
         
         ZStack {
             
             if image == nil {
                 Text("Tap to select a picture")
                     .foregroundColor(.white).font(.headline).padding()
                     .background(Color.gray).cornerRadius(10)
             } else {
                 image?
                     .resizable()
                     .frame(width: 150, height: 150)
                     .clipShape(Circle())
                     .onAppear() {
                         print("image default is: \(String(describing: image))")
                     }
             }
         }
         .onTapGesture {
             showingImagePicker = true
         }

         /*
         HStack {
             Text("Intensity")
             Slider(value: $filterIntensity)
                 .onChange(of: filterIntensity) { _ in applyProcessing() }
         }
         .padding(.vertical)
          */
         
         HStack {
             /*
             Button("Change Filter") {
                 showingFilterSheet = true
             }
             */

             Spacer()

             Button("Save", action: save)
             
             Spacer()
         }
     }
     .onAppear() {
         self.loadImage()
     }
     .padding([.horizontal, .bottom])
     .navigationTitle("Instafilter")
     .onChange(of: inputImage) { _ in loadImage() }
     .sheet(isPresented: $showingImagePicker) {
         ImagePicker(image: $inputImage)
     }
     /*
     .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
         Button("Crystallize") { setFilter(CIFilter.crystallize()) }
         Button("Edges") { setFilter(CIFilter.edges()) }
         Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
         Button("Pixellate") { setFilter(CIFilter.pixellate()) }
         Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
         Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
         Button("Vignette") { setFilter(CIFilter.vignette()) }
         Button("Cancel", role: .cancel) { }
     }*/
 }
     
 func loadImage() {
     guard let inputImage = inputImage else { return }


     let beginImage = CIImage(image: inputImage)
     currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
     applyProcessing()
 }

 func save() {
     guard let processedImage = processedImage else { return }

     let imageSaver = ImageSaver()

     imageSaver.successHandler = {
         print("Success!")
     }

     imageSaver.errorHandler = {
         print("Oops! \($0.localizedDescription)")
     }

     imageSaver.writeToPhotoAlbum(image: processedImage)
 }

 func applyProcessing() {
     let inputKeys = currentFilter.inputKeys

     if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
     if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
     if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

     guard let outputImage = currentFilter.outputImage else { return }

     if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
         let uiImage = UIImage(cgImage: cgimg)
         image = Image(uiImage: uiImage)
         processedImage = uiImage
     }
 }

 func setFilter(_ filter: CIFilter) {
     currentFilter = filter
     loadImage()
 }
 */
