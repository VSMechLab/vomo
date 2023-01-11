//
//  ProgressView.swift
//  VoMo
//
//  Created by Neil McGrogan on 9/2/22.
//

import SwiftUI
import Foundation

struct ProgressView: View {
    @EnvironmentObject var entries: Entries
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var settings: Settings
    
    @State var filters: [String] = []
    @State var filteredList: [Element] = []
    @State var deletionTarget: (Date, String) = (.now, "")
    
    @State private var thresholdPopUps: (Bool, Bool, Bool) = (false, false, false)
    @State private var showFilter = false
    @State private var expandAll = false
    @State private var deletePopUp = false
    @State private var showFavorites = false
    @State var reset = false
    
    let svm = SharedViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Graphic(thresholdPopUps: $thresholdPopUps)
                
                if showFilter {
                    VStack(spacing: 0) {
                        Filter(filters: $filters, showFilter: $showFilter)
                        
                        Spacer()
                    }
                    .transition(.slideUp)
                } else {
                    bodySection
                }
                
                Spacer()
            }
            
            popUpSection
        }
        
        
        /*
        // do something on deletion of data
        .onChange(of: audioRecorder.processedData) { _ in
            print("data has changed")
        }*/
        // do something on the appearance of the use of this data
        .onAppear() {
            // Show the different createdAt
            for recording in audioRecorder.recordings {
                print("Recording: \(recording.createdAt.toStringDay())")
            }
            for processing in audioRecorder.processedData {
                print("Processing: \(processing.createdAt.toStringDay()), \(processing.duration)")
            }
            // SYNC data
            audioRecorder.syncEntries()
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
        .onChange(of: expandAll) { _ in
            refilter()
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
            
            if filters.count != 0 {
                filterSection
            }
            
            listSection
        }
        .frame(width: svm.content_width)
    }
    
    private var listSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(filteredList.reversed(), id: \.self) { item in
                    Color.DARK_PURPLE.frame(height: 5).opacity(0.6)
                    if expandAll || !filters.isEmpty {
                        DayList(element: item, isExpandedList: true, deletionTarget: $deletionTarget)
                    } else if filters.isEmpty {
                        DayList(element: item, isExpandedList: false, deletionTarget: $deletionTarget)
                    }
                }
            }
        }
    }
    
    private var filterSection: some View {
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
    
    private var bodyTitle: some View {
        HStack {
            Text("Entries")
                .font(._title1)
            Spacer()
            ShowFavoritesButton(filters: $filters, showFavorites: self.$showFavorites, expandAll: $expandAll, reset: self.$reset)
            ExpandAllButton(filters: $filters, expandAll: $expandAll, showFavorites: $showFavorites, reset: $reset)
            Button(action: {
                withAnimation() {
                    self.showFilter.toggle()
                }
            }) {
                FilterButton()
            }
        }
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
            .environmentObject(Settings())
    }
}
