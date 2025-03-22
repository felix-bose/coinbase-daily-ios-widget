//
//  widgetBundle.swift
//  widget
//
//  Created by Felix Schaipp on 22.02.25.
//

import WidgetKit
import SwiftUI

@main
struct widgetBundle: WidgetBundle {
    var body: some Widget {
        CoinbaseWidget()
        widgetControl()
        widgetLiveActivity()
    }
}
