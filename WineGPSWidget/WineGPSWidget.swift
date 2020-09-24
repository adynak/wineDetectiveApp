//
//  WineGPSWidget.swift
//  WineGPSWidget
//
//  Created by adynak on 9/18/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
        
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), totalBottles: 0, wineCountRed: 0, wineCounts: ["totalBottles":0])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, totalBottles: 0, wineCountRed: 0, wineCounts: ["totalBottles":0])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        let currentDate = Date()
        
        for refreshInterval in stride(from: 0, to: 40, by: 10) {
            
            let wineCounts = API.load()

            let entryDate = Calendar.current.date(byAdding: .minute, value: refreshInterval, to: currentDate)!
            let totalBottles = wineCounts["totalBottles"]
            let wineCountRed = wineCounts["Red"]

            let entry = SimpleEntry(date: entryDate, configuration: configuration, totalBottles: totalBottles!, wineCountRed: wineCountRed!, wineCounts: wineCounts)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let totalBottles: Int
    let wineCountRed: Int
    let wineCounts: [String: Int]
}

struct WineGPSWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack{
                            Image("logo").resizable().frame(width: 25.0, height: 25.0)
                            Text("WineGPS").font(.headline)
                        }
                        TotalBottlesView(entry: entry)
                    }.padding(.leading, 15)
                    
                    Spacer()
                    Spacer()
                    HStack {
                        RedWineView(entry: entry).cornerRadius(8)
                        Spacer()
                        WhiteWineView(entry: entry).cornerRadius(8)
//                        WineTypesView(entry: entry)
                    }
                    .padding([.leading, .trailing], 8)
                }
            }
            
            .padding()
            .frame(width: 340, height: 155)
//            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(24)
            .padding()
        }
}

struct WineTypesView: View {
    var entry: Provider.Entry
    
    var otherViews : [String] = ["Red", "Rosé","White", "White - Sparkling"]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<otherViews.count) { index in
                Text(otherViews[index])
            }
        }
    }

}

struct RedWineView: View {
    var entry: Provider.Entry
    
    var wineType = NSLocalizedString("wineRed", comment: "textfield label: red (wines)")

    var body: some View {
        let wineCount = String(entry.wineCounts["Red"]!)

        VStack(alignment: .leading) {
            Text(wineType).font(.subheadline).padding(.horizontal,5)
            Text(wineCount).font(.headline).padding(.horizontal,15)
        }.frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading)
            .background(Color(UIColor.lightGray))

    }
}

struct TotalBottlesView: View {
    var entry: Provider.Entry

    let format = NSLocalizedString("totalBottlesWidget", comment: "replace 'bottle' with its singular or plural")

    var body: some View {
        let wineCount = entry.wineCounts["totalBottles"]
        let message = String.localizedStringWithFormat(format, wineCount!)
        Text(message).font(.headline).padding(.horizontal,5)
        .frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading)
//            .background(Color(UIColor.secondarySystemBackground))

    }
}

struct WhiteWineView: View {
    var entry: Provider.Entry

    var wineType = NSLocalizedString("wineWhite", comment: "textfield label: white (wines)")
    
    var body: some View {
        let wineCount = entry.totalBottles - entry.wineCountRed

        VStack(alignment: .leading) {
            Text(wineType).font(.subheadline).padding(.horizontal,5)
            Text(String(wineCount)).font(.headline).padding(.horizontal,15)
            Spacer()
        }.frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading)
        .background(Color(UIColor.lightGray))
    }
}

@main
struct WineGPSWidget: Widget {
    let kind: String = "WineGPSWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WineGPSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WineGPS")
        .supportedFamilies([.systemMedium, .systemLarge])
        .description("WineGPS widget.")
    }
}

//struct WineGPSWidgetSmall_Previews: PreviewProvider {
//    static var previews: some View {
//        WineGPSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), totalBottles: 249))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//            .previewDisplayName("Small")
//    }
//}

//struct WineGPSWidgetMedium_Previews: PreviewProvider {
//    static var previews: some View {
//        WineGPSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), totalBottles: 247, wineCountRed: 199, wineCounts: ["totalBottles":247]))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//            .previewDisplayName("Medium")
//            .environment(\.colorScheme, .light)
//    }
//}

//struct WineGPSWidgetLarge_Previews: PreviewProvider {
//    static var previews: some View {
//        WineGPSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), totalBottles: 247, wineCountRed: 199, wineCounts: ["totalBottles":247]))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
//            .previewDisplayName("Large")
//    }
//}

