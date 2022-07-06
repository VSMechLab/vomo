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
    @EnvironmentObject var recordingState: RecordState
    
    @ObservedObject var userSettings = UserSettings()
    
    @State private var gender = UserDefaults.standard.string(forKey: "gender") ?? ""
    
    
    
    @State private var fteProfile = false
    
    var genders = ["other", "male", "female", "prefer not to say"]
    
    let genderKey = "gender", dobKey = "dob"
    let voiceOnsetKey = "voiceOnset", currentSmokerKey = "currentSmoker"
    let haveRefluxKey = "haveReflux", haveAsthmaKey = "haveAsthma"
    let select_img = "VM_Select-Btn-Prpl-Field"
    let unselect_img = "VM_Unselect-Btn-Gry-Field"
    let entry_img = "VM_12-entry-field"
    let button_img = "VM_Gradient-Btn"
    let toggleHeight: CGFloat = 37 * 0.95
    let img_selected = "VM_Prpl-Square-Btn copy"
    let img_unselected = "VM_Prpl-Check-Square-Btn"
    let prompt = ["a custom", "the Spasmodic Dysphonia", "the Recurrent Pappiloma", "the Parkinson's Disease", "the Gender-Affirming Care", "the Vocal Fold/Paresis", "the default"]
    
    @State private var svm = SharedViewModel()
    
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
                        Text("First Name")
                            .font(._fieldLabel)
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(width: svm.content_width, height: toggleHeight)
                                .cornerRadius(7)
                            
                            HStack {
                                TextField(self.userSettings.firstName.isEmpty ? "First Name" : self.userSettings.firstName, text: $userSettings.firstName)
                                    .font(self.userSettings.firstName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            }.padding(.horizontal, 5)
                        }.frame(width: svm.content_width, height: toggleHeight)
                        
                        Text("Last Name")
                            .font(._fieldLabel)
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(width: svm.content_width, height: toggleHeight)
                                .cornerRadius(7)
                            
                            HStack {
                                TextField(self.userSettings.lastName.isEmpty ? "Last Name" : self.userSettings.lastName, text: $userSettings.lastName)
                                    .font(self.userSettings.lastName.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            }.padding(.horizontal, 5)
                        }.frame(width: svm.content_width, height: toggleHeight)
                        
                        Text("Gender")
                            .font(._fieldLabel)
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(height: toggleHeight)
                                .cornerRadius(7)
                            
                            HStack {
                                Menu {
                                    Picker("choose", selection: $gender) {
                                        ForEach(genders, id: \.self) { gend in
                                            Text("\(gend)")
                                                .font(._fieldCopyRegular)
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(InlinePickerStyle())

                                } label: {
                                    Text("\(gender == "" ? "Select gender" : gender)")
                                        .font(._fieldCopyRegular)
                                }
                                .frame(maxHeight: 400)
                                Spacer()
                                
                                /*
                                HStack(spacing: 0) {
                                    Menu {
                                        Picker("choose", selection: $selectedVisit) {
                                            ForEach(visitTypes, id: \.self) { type in
                                                Text(type)
                                                    .font(._fieldCopyRegular)
                                            }
                                        }
                                        .labelsHidden()
                                        .pickerStyle(InlinePickerStyle())
                                    } label: {
                                        Text("\(selectedVisit == "" ? "Select appointment type" : selectedVisit)")
                                            .font(._fieldCopyRegular)
                                    }
                                    .frame(maxHeight: 400)
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                .frame(height: 40)
                                .background(Color.white)
                                .cornerRadius(12)*/
                                
                                
                                /*
                                Picker("pick here", selection: $gender) {
                                    ForEach(genders, id: \.self) {
                                        Text($0)
                                            .foregroundColor(.gray)
                                    }.foregroundColor(.gray)
                                }.foregroundColor(.gray)
                                .frame(maxHeight: 400)
                                .foregroundColor(.red)
                                Spacer()*/
                            }.padding(.horizontal, 5)
                        }
                        .frame(height: toggleHeight)
                        .transition(.slide)
                        
                        Text("Date of Birth")
                            .font(._fieldLabel)
                        
                        ZStack {
                            Image(entry_img)
                                .resizable()
                                .frame(height: toggleHeight)
                                .cornerRadius(5)
                            
                            HStack {
                                TextField(self.userSettings.dob.isEmpty ? "00/00/0000" : self.userSettings.dob, text: $userSettings.dob)
                                    .font(self.userSettings.dob.isEmpty ? ._fieldCopyItalic : ._fieldCopyRegular)
                            }.padding(.horizontal, 7)
                        }.frame(height: toggleHeight)
                    }
                    
                    Group {
                        Text("Voice Onset")
                            .font(._fieldLabel)
                        
                        HStack(spacing: 0) {
                            Button("") { self.userSettings.voice_onset = true }.buttonStyle(YesButton(selected: userSettings.voice_onset))
                            Spacer()
                            Button("") { self.userSettings.voice_onset = false }.buttonStyle(NoButton(selected: userSettings.voice_onset))
                        }
                        
                        
                        Text("Current Smoker / Vaper?")
                            .font(._fieldLabel)
                        
                        HStack(spacing: 0) {
                            Button("") { self.userSettings.current_smoker = true }.buttonStyle(YesButton(selected: userSettings.current_smoker))
                            Spacer()
                            Button("") { self.userSettings.current_smoker = false }.buttonStyle(NoButton(selected: userSettings.current_smoker))
                        }
                        
                        Text("Currently Have Reflux?")
                            .font(._fieldLabel)
                        
                        HStack(spacing: 0) {
                            Button("") { self.userSettings.have_reflux = true }.buttonStyle(YesButton(selected: userSettings.have_reflux))
                            Spacer()
                            Button("") { self.userSettings.have_reflux = false }.buttonStyle(NoButton(selected: userSettings.have_reflux))
                        }
                        
                        
                        Text("Currently Have Asthma?")
                            .font(._fieldLabel)
                        
                        HStack(spacing: 0) {
                            Button("") { self.userSettings.have_asthma = true }.buttonStyle(YesButton(selected: userSettings.have_asthma))
                            Spacer()
                            Button("") { self.userSettings.have_asthma = false }.buttonStyle(NoButton(selected: userSettings.have_asthma))
                        }
                    }
                }
                .font(._coverBodyCopy)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 0) {
                        Text("You are on \(prompt[userSettings.focusSelection]) track ")
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
                    .padding(.vertical, 5)
                    
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            save()
                        }) {
                            SubmissionButton(label: "SAVE")
                        }
                        .padding(.bottom, 80)
                        Spacer()
                    }
                    .frame(width: svm.content_width)
                }.frame(width: svm.content_width)
            }
            .frame(width: svm.content_width)
        }.padding(.vertical)
    }
    
    func save() {
        UserDefaults.standard.set(self.gender, forKey:  "gender")
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
