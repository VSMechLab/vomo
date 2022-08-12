//
//  Font.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI
import Foundation

extension Font {
    static var _headline: Font {
        Font.custom("Roboto-Bold", size: 30)
    }
    static var _subHeadline: Font {
        Font.custom("Roboto-Bold", size: 21)
    }
    static var _subsubHeadline: Font {
        Font.custom("Roboto-Bold", size: 14)
    }
    static var _bodyCopy: Font {
        Font.custom("Roboto-Light", size: 12)
    }
    static var _bodyCopyBoldLower: Font {
        Font.custom("Roboto-Bold", size: 12)
    }
    static var _bodyCopyBold: Font {
        Font.custom("Roboto-Bold", size: 14)
    }
    static var _BTNCopy: Font {
        Font.custom("Roboto-Medium", size: 20)
    }
    static var _BTNCopyUnbold: Font {
        Font.custom("Roboto-Light", size: 20)
    }
    static var _coverBodyCopy: Font {
        Font.custom("Roboto-Bold", size: 16)
    }
    static var _stats: Font {
        Font.custom("Roboto-Medium", size: 10)
    }
    static var _statsLabel: Font {
        Font.custom("Roboto-Light", size: 7)
    }
    static var _CTALink: Font {
        Font.custom("Roboto-Regular", size: 10)
    }
    static var _day: Font {
        Font.custom("Roboto-Regular", size: 10)
    }
    static var _date: Font {
        Font.custom("Roboto-Regular", size: 32)
    }
    static var _lastUsed: Font {
        Font.custom("Roboto-Regular", size: 6)
    }
    static var _recordStateStatus: Font {
        Font.custom("Roboto-Light", size: 15)
    }
    static var _question: Font {
        Font.custom("Roboto-Light", size: 12)
    }
    static var _scale: Font {
        Font.custom("Roboto-Medium", size: 12)
    }
    static var _scaleCopy: Font {
        Font.custom("Roboto-Light", size: 7)
    }
    static var _fieldCopyRegular: Font {
        Font.custom("Roboto-Light", size: 10)
    }
    static var _fieldCopyItalic: Font {
        Font.custom("Roboto-LightItalic", size: 10)
    }
    static var _fieldLabel: Font {
        Font.custom("Roboto-Bold", size: 12)
    }
    static var _disclaimerLink: Font {
        Font.custom("Roboto-Bold", size: 10)
    }
    static var _disclaimerCopy: Font {
        Font.custom("Roboto-Regular", size: 10)
    }
    static var _buttonFieldCopy: Font {
        Font.custom("Roboto-Medium", size: 10)
    }
    static var _buttonFieldCopyLarger: Font {
        Font.custom("Roboto-Regular", size: 14)
    }
    static var _subCopy: Font {
        Font.custom("Roboto-Regular", size: 8)
    }
    static var _pageNavLink: Font {
        Font.custom("Roboto-Regular", size: 12)
    }
    static var questionnaireScale: Font {
        Font.custom("Roboto-Regular", size: 8)
    }
}

struct FontView: View {
    var body: some View {
        VStack {
            Group {
                Text("Hi, Victoria")
                    .font(._headline)
                Text("Track your voice over time and share vocal health information with your clinical provider all in one place")
                    .font(._bodyCopy)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.BODY_COPY)
            }
            
            
            Text("LOGIN")
                .font(._BTNCopy)
            
            Text("Some at home voice therapy today will keep the doctor away")
                .font(._coverBodyCopy)
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
