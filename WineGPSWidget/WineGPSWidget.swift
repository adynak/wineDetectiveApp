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
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WineGPSWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack{
                            Image("logo").resizable()
                            .frame(width: 25.0, height: 25.0)
                            
                                
                        Text("WineGPS").font(.headline)
                        }
                        Text("251 Bottles").font(.subheadline).foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    
                    Spacer()
                    Spacer()
                    HStack {
                        RedWineView()
                            .cornerRadius(8)

                        Spacer()
                        WhiteWineView()
                            .cornerRadius(8)
                    }
                }
            }
            
            .padding()
            .frame(width: 340, height: 155)
//            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(24)
            .padding()
        }
}

struct RedWineView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reds").font(.subheadline)
                .padding(.horizontal,5)
            Text("222").font(.headline)
                .padding(.horizontal,15)
        }.frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading)
            .background(Color(UIColor.secondarySystemBackground))

    }
}

struct WhiteWineView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Whites").font(.subheadline)
                .padding(.horizontal,5)
            Text("29").font(.headline)
                .padding(.horizontal,15)
            Spacer()
        }.frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading)
        .background(Color(UIColor.secondarySystemBackground))
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
        .supportedFamilies([.systemMedium])
        .description("WineGPS widget.")
    }
}

struct WineGPSWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        WineGPSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")
    }
}

struct WineGPSWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        WineGPSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium")
            .environment(\.colorScheme, .light)
    }
}

struct WineGPSWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        WineGPSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large")
    }
}

