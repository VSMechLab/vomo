//
//  ShareButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 6/6/23.
//

import SwiftUI
import Foundation
import simd
import AVFAudio

struct ShareButtonByDate: View {
    
    @ObservedObject var audioRecorder = AudioRecorder.shared

    @State private var selectedFiles = [URL]()
    
    var date: Date
    
    let svm = SharedViewModel()
    
    var body: some View {
        Button(action: {
            print("Sharing the file from this time: \(date)")
            print(date)
            
            /*
             selectedFiles = audioRecorder.allFiles()
             
             var filesToShare = [Any]()
             for fileURL in selectedFiles {
                 do {
                     let data = try Data(contentsOf: fileURL)
                     let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileURL.lastPathComponent)
                     try data.write(to: tempURL)
                     filesToShare.append(tempURL)
                 } catch {
                     print(error.localizedDescription)
                 }
             }
                 
                 
             if !filesToShare.isEmpty {
                 let activityVC = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                 UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
             }
             */
            
            selectedFiles.removeAll()
            
            for target in audioRecorder.recordings {
                if date == target.createdAt {
                    
                    selectedFiles.append( target.fileURL )
                    
                    var filesToShare = [Any]()
                    for fileURL in selectedFiles {
                        do {
                            let data = try Data(contentsOf: fileURL)
                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileURL.lastPathComponent)
                            try data.write(to: tempURL)
                            filesToShare.append(tempURL)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                        
                        
                    if !filesToShare.isEmpty {
                        let activityVC = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
                    }
                    
                    
                }
            }
        }) {
            Image(svm.share_button)
                .resizable()
                .frame(width: 18, height: 20)
        }
    }
}
