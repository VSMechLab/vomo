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
            Text("Favorites")
                .foregroundColor(showFavorites ? Color.white : Color.BODY_COPY)
                .font(._CTALink)
                .padding(7)
                .background(showFavorites ? Color.BODY_COPY : Color.white)
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
            .padding(7)
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
    var body: some View {
        Button(action: {
            self.filters.removeAll()
            self.expandAll.toggle()
            self.showFavorites = false
            self.reset.toggle()
        }) {
            Text("Expand All")
                .foregroundColor(expandAll ? Color.white : Color.BODY_COPY)
                .font(._CTALink)
                .padding(7)
                .background(expandAll ? Color.BODY_COPY : Color.white)
                .cornerRadius(5)
                .padding(1)
                .background(Color.INPUT_FIELDS)
                .cornerRadius(5)
        }
    }
}
