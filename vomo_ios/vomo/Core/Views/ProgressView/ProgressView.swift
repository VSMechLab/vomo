//
//  ProgressView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import Foundation
import AVFAudio

struct ProgressView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @ObservedObject var settings = Settings.shared

    @State var filters: [String] = []
    @State var filteredList: [Element] = []
    @State var deletionTarget: (Date, String) = (.now, "")
    @State private var thresholdPopUps: (Bool, Bool, Bool) = (false, false, false)
    @State private var showFilter = false
    @State private var expandAll = false
    @State private var deletePopUp = false
    @State private var showFavorites = false
    @State var reset = false
    @State var showBaseline = (false, 0)
    @State var tappedRecording: Date = .now
    
    @State var showRecordDetails = false
    
    @State var audioPlayer: AVAudioPlayer!
    
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Graphic(thresholdPopUps: $thresholdPopUps, tappedRecording: $tappedRecording, showBaseline: self.$showBaseline, deletionTarget: $deletionTarget)
                
                if showFilter {
                    VStack(spacing: 0) {
                        Filter(filters: $filters, showFilter: $showFilter)
                        
                        Spacer()
                    }
                    .transition(.slideUp)
                } else {
                    HStack(alignment: .top, spacing: 0) {
                        bodySection
                    }
                }
            }
            
            popUpSection
        }
        .onAppear() {
            refilter()
            initializeThresholds()
        }
        .onChange(of: showFilter) { _ in
            refilter()
        }
        .onChange(of: reset) { _ in
            refilter()
            self.reset = false
        }
        .onChange(of: tappedRecording) { _ in
            targetItem()
        }
        .onChange(of: showRecordDetails) { change in
            Logging.defaultLog.notice("ShowRecordingDetails state: \(change)")
        }
    }
}

/// Views
extension ProgressView {
    private var deletePopUpSection: some View {
        ZStack {
            Color.white
                .frame(width: svm.content_width * 0.7, height: 200)
                .shadow(color: Color.gray, radius: 1)
            
            VStack(alignment: .leading) {
                Text("Confim you would like to delete this entry")
                    .font(._bodyCopyLargeMedium)
                    .multilineTextAlignment(.leading)
                Text("\(deletionTarget.1) at: \(deletionTarget.0.toStringDay())")
                    .font(._bodyCopy)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        deletionTarget.0 = .now
                        deletionTarget.1 = ""
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color.red)
                            .font(._bodyCopyMedium)
                    }
                    Spacer()
                    Button(action: {
                        deleteAtDate(createdAt: deletionTarget.0)
                        deletionTarget.0 = .now
                        deletionTarget.1 = ""
                    }) {
                        Text("Yes")
                            .foregroundColor(Color.green)
                            .font(._bodyCopyMedium)
                    }
                    Spacer()
                }
                .padding()
            }.padding(5)
            .frame(width: svm.content_width * 0.7, height: 200)
        }
    }
    
    private var bodySection: some View {
        VStack(alignment: .center) {
            bodyTitle
            
            ScrollView(showsIndicators: false) {
                if showBaseline.0 {
                    BaselineRecording(deletionTarget: $deletionTarget, showing: showBaseline.1)
                }
                
                if filters.count != 0 {
                    filterSection
                }
                
                listSection
            }
        }
        .frame(width: svm.content_width * 1.075)
    }
    
    private var listSection: some View {
        VStack(spacing: 0) {
            ForEach(filteredList.reversed(), id: \.self) { item in
                if item.preciseDate.contains(tappedRecording){
                    DayList(element: item, isExpandedList: true, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                        .background(Color.HEADLINE_COPY.opacity(0.75))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                } else if !expandAll {
                    DayList(element: item, isExpandedList: false, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                        .background(Color.HEADLINE_COPY.opacity(0.75))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                } else if expandAll || !filters.isEmpty {
                    DayList(element: item, isExpandedList: true, deletionTarget: $deletionTarget, showRecordDetails: $showRecordDetails, audioPlayer: $audioPlayer)
                        .background(Color.HEADLINE_COPY.opacity(0.75))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                }
            }
        }
    }
    
    private var filterSection: some View {
        ZStack {
            if filters.count >= 3 {
                VStack {
                    HStack {
                        ForEach(0..<(filters.count-3), id: \.self) { index in
                            Button(action: {
                                delete(element: filters[index])
                                refilter()
                            }) {
                                HStack {
                                    Text(filters[index])
                                        .font(._CTALink)
                                    Image(svm.exit_button)
                                        .resizable()
                                        .frame(width: 7.5, height: 7.5)
                                        .padding(.leading, 2)
                                }
                                .padding(2.5)
                                .background(Color.INPUT_FIELDS)
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        ForEach((filters.count-3)..<(filters.count), id: \.self) { index in
                            Button(action: {
                                delete(element: filters[index])
                                refilter()
                            }) {
                                HStack {
                                    Text(filters[index])
                                        .font(._CTALink)
                                    Image(svm.exit_button)
                                        .resizable()
                                        .frame(width: 7.5, height: 7.5)
                                        .padding(.leading, 2)
                                }
                                .padding(2.5)
                                .background(Color.INPUT_FIELDS)
                            }
                        }
                        Button(action: {
                            filters.removeAll()
                            refilter()
                        }) {
                            Text("Clear All")
                                .font(._CTALink)
                                .underline()
                        }
                        Spacer()
                    }
                }
            } else {
                HStack {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            delete(element: filter)
                            refilter()
                        }) {
                            HStack {
                                Text(filter)
                                    .font(._CTALink)
                                Image(svm.exit_button)
                                    .resizable()
                                    .frame(width: 7.5, height: 7.5)
                                    .padding(.leading, 2)
                            }
                            .padding(2.5)
                            .background(Color.INPUT_FIELDS)
                        }
                    }
                    Button(action: {
                        filters.removeAll()
                        refilter()
                    }) {
                        Text("Clear All")
                            .font(._CTALink)
                            .underline()
                    }
                    Spacer()
                }
            }
        }
    }
    
    private var bodyTitle: some View {
        HStack {
            Text("Entries")
                .font(._title1)
            Spacer()
            ShowFavoritesButton(filters: $filters, showFavorites: self.$showFavorites, expandAll: $expandAll, reset: self.$reset)
            ExpandAllButton(filters: $filters, expandAll: $expandAll, showFavorites: $showFavorites, reset: $reset, showRecordDetails: $showRecordDetails)
            
            // show baseline button
            
            if audioRecorder.recordings.isNotEmpty {
                Button(action: {
                    self.showBaseline.0.toggle()
                    self.showBaseline.1 = 0
                }) {
                    Text(self.showBaseline.0 ? "Baseline" : "Baseline")
                        .foregroundColor(showBaseline.0 ? Color.white : Color.BODY_COPY)
                        .font(._CTALink)
                        .padding(.horizontal, 2.5)
                        .padding(4.5)
                        .background(showBaseline.0 ? Color.BODY_COPY : Color.white)
                        .cornerRadius(5)
                        .padding(1)
                        .background(Color.INPUT_FIELDS)
                        .cornerRadius(5)
                }
            }
            
            Button(action: {
                withAnimation() {
                    self.showFilter.toggle()
                }
            }) {
                FilterButton()
            }
        }
        .padding(.top, 5)
        .padding(.bottom, -2.5)
    }
    
    private var popUpSection: some View {
        ZStack {
            if thresholdPopUps.0 && settings.pitchThreshold.count != 0 {
                SetThreshold(popUp: $thresholdPopUps.0, selection: $settings.pitchThreshold[0], min: $settings.pitchThreshold[1], max: $settings.pitchThreshold[2])
            } else if thresholdPopUps.1 && settings.durationThreshold.count != 0 {
                SetThreshold(popUp: $thresholdPopUps.1, selection: $settings.durationThreshold[0], min: $settings.durationThreshold[1], max: $settings.durationThreshold[2])
            } else if thresholdPopUps.2 && settings.qualityThreshold.count != 0 {
                SetThreshold(popUp: $thresholdPopUps.2, selection: $settings.qualityThreshold[0], min: $settings.qualityThreshold[1], max: $settings.qualityThreshold[2])
            }
            if deletionTarget.1 != "" {
                deletePopUpSection
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(AudioRecorder())
            .environmentObject(Entries())
    }
}
