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
        SimpleEntry(date: Date(), configuration: SelectVarietalIntent(), totalBottles: 0, wineCountRed: 0, wineCounts: ["totalBottles":0], wineVarietal: "Not Logged On")
    }

    func getSnapshot(for configuration: SelectVarietalIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, totalBottles: 0, wineCountRed: 0, wineCounts: ["totalBottles":0], wineVarietal: "")
        completion(entry)
    }

    
    func getTimeline(
        for configuration: SelectVarietalIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        
        for refreshInterval in stride(from: 0, to: 40, by: 10) {
            
            let wineCounts = API.load()

            let entryDate = Calendar.current.date(byAdding: .minute, value: refreshInterval, to: currentDate)!
            let totalBottles = wineCounts["totalBottles"]
            let wineCountRed = wineCounts["Red"]

            let entry = SimpleEntry(date: entryDate, configuration: configuration, totalBottles: totalBottles!, wineCountRed: wineCountRed!, wineCounts: wineCounts, wineVarietal: "Cabernet Sauvignon")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SelectVarietalIntent
    let totalBottles: Int
    let wineCountRed: Int
    let wineCounts: [String: Int]
    let wineVarietal: String
}

struct WineGPSWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        SmallWidgetView(entry: entry)
//
//    HStack {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading) {
//                HStack{
//                    Image("logo").resizable().frame(width: 25.0, height: 25.0)
//                    Text("WineGPS").font(.headline)
//                }
//                TotalBottlesView(entry: entry)
//            }.padding(.leading, 15)
//
//            Spacer()
//            Spacer()
//            HStack{
//                SmallWidgetView(entry: entry)
//            }
////                    HStack {
////                        RedWineView(entry: entry).cornerRadius(8)
////                        Spacer()
////                        WhiteWineView(entry: entry).cornerRadius(8)
////                    }
//            .padding([.leading, .trailing], 8)
//        }
//    }
//
//    .padding()
//    .frame(width: 340, height: 155)
////            .background(Color(UIColor.secondarySystemBackground))
//    .cornerRadius(24)
//    .padding()
}
}

struct WineVarietalView: View {
    var entry: Provider.Entry
        
    var wineType = "Cabernet Sauvignon"

    var body: some View {
//        let wineCount = String(entry.wineCounts["Red"]!)
        let wineCount = "123"


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

struct SmallWidgetView: View {
    var entry: Provider.Entry

    var body: some View {

        VStack(alignment: .leading) {
            HStack{
                Image("logo").resizable().frame(width: 25.0, height: 25.0)
                Text("WineGPS").font(.headline)
            }
            Text(entry.wineVarietal)
                .font(.system(.caption2))
                .foregroundColor(.black)
                .bold()
            Text("19")
                .font(.system(.caption2))
                .foregroundColor(.black)
                .padding(.horizontal,15)

        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
    }

}


struct RedWineView: View {
    var entry: Provider.Entry
    
    var wineType = NSLocalizedString("wineRed", comment: "textfield label: red (wines)")

    var body: some View {
//        let wineCount = String(entry.wineCounts["Red"]!)
        let wineCount = "123"


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

//@main
struct WineGPSWidget: Widget {
    let kind: String = "WineGPSWidget"
    
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectVarietalIntent.self,
            provider: Provider()
        ) { entry in
            WineGPSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Select Varietal")
        .supportedFamilies([.systemSmall])
        .description("Choose the one varietal to display in this widget.")
    }
}

struct WineGPSWidgetPlaceholderView: View {
    var body: some View {
        Color(UIColor.systemIndigo)
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

