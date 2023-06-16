//
//  FilterButton.swift
//  VoMo
//
//  Created by Neil McGrogan on 10/27/22.
//

import SwiftUI

struct ShowFavoritesButton: View {
    @Binding var filters: [String]
    @Binding var showFavorites: Bool
    @Binding var expandAll: Bool
    @Binding var reset: Bool
    let svm = SharedViewModel()
    var body: some View {
        Button(action: {
            self.showFavorites.toggle()
            self.reset.toggle()
            self.expandAll = false
            if !filters.contains("Favorite") {
                self.filters.append("Favorite")
            } else {
                self.filters.removeAll()
            }
        }) {
            Image(showFavorites ? svm.heart_img : svm.heart_gray_img)
                .resizable()
                .scaledToFit()
                .frame(height: 17.5)
                .padding(.horizontal, 2.5)
                .padding(4.5)
                .background(showFavorites ? Color.INPUT_FIELDS : Color.INPUT_FIELDS)
                .cornerRadius(5)
                .padding(1)
                .background(Color.INPUT_FIELDS)
                .cornerRadius(5)
        }
    }
}

struct FilterButton: View {
    var body: some View {
        Text("Filter")
            .foregroundColor(Color.BODY_COPY)
            .font(._CTALink)
            .padding(.horizontal, 2.5)
            .padding(4.5)
            .background(Color.white)
            .cornerRadius(5)
            .padding(1)
            .background(Color.INPUT_FIELDS)
            .cornerRadius(5)
    }
}

struct ExpandAllButton: View {
    @Binding var filters: [String]
    @Binding var expandAll: Bool
    @Binding var showFavorites: Bool
    @Binding var reset: Bool
    @Binding var showRecordDetails: Bool
    var body: some View {
        Button(action: {
            self.expandAll.toggle()
            self.showFavorites = false
            self.reset.toggle()
            if expandAll {
                self.showRecordDetails = true
            } else {
                self.showRecordDetails = false
            }
        }) {
            Text("Expand")
                .foregroundColor(expandAll ? Color.white : Color.BODY_COPY)
                .font(._CTALink)
                .padding(.horizontal, 2.5)
                .padding(4.5)
                .background(expandAll ? Color.BODY_COPY : Color.white)
                .cornerRadius(5)
                .padding(1)
                .background(Color.INPUT_FIELDS)
                .cornerRadius(5)
        }
    }
}
