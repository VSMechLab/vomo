//
//  Font.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI
import Foundation

extension Font {
    /// Title, Size 30, Bold
    static var _large_title: Font {
        Font.custom("Roboto-Bold", size: 35)
    }
    /// Title, Size 30, Bold
    static var _title: Font {
        Font.custom("Roboto-Bold", size: 30)
    }
    /// Title, Size 24, Bold
    static var _title1: Font {
        Font.custom("Roboto-Bold", size: 24)
    }
    /// Countdown, Size 75, Bold
    static var _countdown: Font {
        Font.custom("Roboto-Bold", size: 75)
    }
    /// Subtitle, Size 17, Regular
    static var _subTitle: Font {
        Font.custom("Roboto-light", size: 19)
    }
    /// Subtitle, Size 12, Regular
    static var _tabTitle: Font {
        Font.custom("Roboto-Regular", size: 16)
    }
    /// Subtitle, Size 12, Regular
    static var _tabTitleBold: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    /// Bar Graph Bar Label
    static var _barLabel: Font {
        Font.custom("Roboto-Light", size: 16)
    }
    /// Medium Bar Graph Bar Label
    static var _barLabelBold: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    /// Tab bar font size 14, medium
    static var _tabBarFont: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    static var _subHeadline: Font {
        Font.custom("Roboto-Bold", size: 21)
    }
    static var _subsubHeadline: Font {
        Font.custom("Roboto-Bold", size: 16)
    }
    static var _bodyCopy: Font {
        Font.custom("Roboto-Light", size: 16)
    }
    static var _bodyCopyLargeBold: Font {
        Font.custom("Roboto-Bold", size: 18)
    }
    static var _bodyCopyLargeMedium: Font {
        Font.custom("Roboto-Medium", size: 18)
    }
    static var _bodyCopyBold: Font {
        Font.custom("Roboto-Bold", size: 16)
    }
    static var _bodyCopyMedium: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    static var _bodyCopyBoldLower: Font {
        Font.custom("Roboto-Bold", size: 16)
    }
    static var _bodyCopyUnBold: Font {
        Font.custom("Roboto-light", size: 16)
    }
    static var _BTNCopy: Font {
        Font.custom("Roboto-Medium", size: 20)
    }
    static var _BTNCopyUnbold: Font {
        Font.custom("Roboto-Light", size: 20)
    }
    static var _recordingPopUp: Font {
        Font.custom("Roboto-Medium", size: 18)
    }
    static var _stats: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    static var _statsLabel: Font {
        Font.custom("Roboto-Light", size: 16)
    }
    static var _CTALink: Font {
        Font.custom("Roboto-Regular", size: 16)
    }
    static var _day: Font {
        Font.custom("Roboto-Light", size: 14)
    }
    static var _surveyNormalLabel: Font {
        Font.custom("Roboto-Bold", size: 12)
    }
    static var _date: Font {
        Font.custom("Roboto-Regular", size: 38)
    }
    static var _lastUsed: Font {
        Font.custom("Roboto-Regular", size: 16)
    }
    static var _question: Font {
        Font.custom("Roboto-Light", size: 19)
    }
    static var _scale: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    static var _scaleCopy: Font {
        Font.custom("Roboto-Light", size: 16)
    }
    static var _fieldCopyRegular: Font {
        Font.custom("Roboto-Light", size: 14)
    }
    static var _fieldCopyMedium: Font {
        Font.custom("Roboto-Medium", size: 14)
    }
    static var _fieldCopyBold: Font {
        Font.custom("Roboto-Bold", size: 14)
    }
    static var _fieldCopyItalic: Font {
        Font.custom("Roboto-LightItalic", size: 16)
    }
    static var _fieldLabel: Font {
        Font.custom("Roboto-Bold", size: 19)
    }
    static var _disclaimerLink: Font {
        Font.custom("Roboto-Bold", size: 16)
    }
    static var _disclaimerCopy: Font {
        Font.custom("Roboto-Regular", size: 16)
    }
    static var _buttonFieldCopy: Font {
        Font.custom("Roboto-Medium", size: 16)
    }
    static var _buttonFieldCopyLarger: Font {
        Font.custom("Roboto-Regular", size: 18)
    }
    static var _subCopy: Font {
        Font.custom("Roboto-Regular", size: 15)
    }
    /// Navigation between pages
    static var _pageNavLink: Font {
        Font.custom("Roboto-Regular", size: 21)
    }
    static var questionnaireScale: Font {
        Font.custom("Roboto-Regular", size: 16)
    }
    static var _BTNCopyLarge: Font {
        Font.custom("Roboto-Regular", size: 22)
    }
}

struct FontView: View {
    var body: some View {
        VStack {
            Group {
                Text("Hi, Victoria")
                    .font(._title)
                Text("Track your voice over time and share vocal health information with your clinical provider all in one place")
                    .font(._bodyCopy)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.BODY_COPY)
            }
            
            
            Text("LOGIN")
                .font(._BTNCopy)
            
            Text("Some at home voice therapy today will keep the doctor away")
                .font(._recordingPopUp)
                .multilineTextAlignment(.center)
            
            Group {
                Text("26")
                    .font(._stats)
                
                Text("RECORDINGS")
                    .font(._statsLabel)
            }
            
            Text("Details")
                .font(._CTALink)
            
            Group {
                Text("MON")
                    .font(._day)
                
                Text("08")
                    .font(._date)
                
                Text("2 Days Ago")
                    .font(._lastUsed)
            }
            
            Text("My voice makes it difficult for people to hear me")
                .font(._question)
                .foregroundColor(.BODY_COPY)
            
            Text("4")
                .font(._scale)
            
            Text("Always")
                .font(._scaleCopy)
        }
    }
}

struct FontView_Previews: PreviewProvider {
    static var previews: some View {
        FontView()
    }
}
