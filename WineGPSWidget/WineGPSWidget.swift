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
    
    let totalBottles = NSLocalizedString("totalBottles", comment: "plural : total bottles")
        
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), configuration: SelectVarietalIntent(), totalBottles: 0, varietalCount: 0, wineCounts: [totalBottles:0], wineVarietal: "Not Logged On", deepLinkURL: nil)
    }

    func getSnapshot(for configuration: SelectVarietalIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, totalBottles: 0, varietalCount: 0, wineCounts: [totalBottles:0], wineVarietal: "", deepLinkURL: nil)
        completion(entry)
    }

    func getTimeline(
        for configuration: SelectVarietalIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        
        for refreshInterval in stride(from: 0, to: 40, by: 120) {
            
            let wineCounts = WidgetAPI.load()

            let entryDate = Calendar.current.date(byAdding: .minute, value: refreshInterval, to: currentDate)!
            let totalBottleCount = wineCounts[totalBottles]

            let varietalDetails = lookupVarietalDetails(for: configuration)

            let entry = SimpleEntry(date: entryDate, configuration: configuration, totalBottles: totalBottleCount!, varietalCount: wineCounts[varietalDetails.name.trimmingCharacters(in: .whitespacesAndNewlines)]!, wineCounts: wineCounts, wineVarietal: varietalDetails.name, deepLinkURL: varietalDetails.url)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func lookupVarietalDetails(for configuration: SelectVarietalIntent) -> VarietalDetails {
      guard let varietalId = configuration.varietal?.identifier,
         let varietal = VarietalProvider.all().first(where: { varietal in
          varietal.id == varietalId
         })
      else {
        return VarietalProvider.random()
      }
      return varietal
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SelectVarietalIntent
    let totalBottles: Int
    let varietalCount: Int
    let wineCounts: [String: Int]
    let wineVarietal: String
    let deepLinkURL: URL?
}

struct WineGPSWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let wineVarietal = entry.wineVarietal
        let totalBottles = NSLocalizedString("totalBottles", comment: "plural : total bottles")

        if wineVarietal == totalBottles {
            SmallWidgetViewTotalBottles(entry: entry)
        } else {
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    let format = NSLocalizedString("totalBottlesWidget", comment: "replace 'bottle' with its singular or plural")

    var body: some View {
        
        let wineCount = entry.varietalCount
        let wineVarietal = entry.wineVarietal
        
        let bottleCount = String.localizedStringWithFormat(format, wineCount)
        
        let appName = NSLocalizedString("productName", comment: "app name: WineGPS")
        
        VStack(alignment: .leading) {
            Image("logo")
                .resizable()
                .frame(width: 25.0, height: 25.0)
            Text(appName)
                .font(.caption)
                .padding(.vertical,-35)
                .padding(.horizontal,30)
                .fixedSize()
                .frame(width: 100)
            TotalBottlesView(entry: entry)
            Spacer()
            Text(wineVarietal)
                .font(.system(.caption2))
                .foregroundColor(.black)
                .bold()
                .padding(.bottom, 1)
            Text(bottleCount)
                .font(.system(.headline))
                .foregroundColor(.black)
                .padding(.horizontal,10)

            Spacer()

        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white,.white, .purple]), startPoint: .top, endPoint: .bottom))
    }

}

struct SmallWidgetViewTotalBottles: View {
    var entry: Provider.Entry
    
    let format = NSLocalizedString("totalBottlesWidget", comment: "replace 'bottle' with its singular or plural")

    var body: some View {
        
        let wineCount = entry.varietalCount
        let wineVarietal = NSLocalizedString("totalBottles", comment: "plural : total bottles")

        let bottleCount = String.localizedStringWithFormat(format, wineCount)
        
        let appName = NSLocalizedString("productName", comment: "app name: WineGPS")
        
        VStack(alignment: .leading) {
            Image("logo")
                .resizable()
                .frame(width: 25.0, height: 25.0)
            Text(appName)
                .font(.caption)
                .padding(.vertical,-35)
                .padding(.horizontal,30)
                .fixedSize()
                .frame(width: 100)
            Spacer()
            Text(wineVarietal)
                .font(.system(.caption2))
                .foregroundColor(.black)
                .bold()
                .padding(.bottom, 1)
            Text(bottleCount)
                .font(.system(.headline))
                .foregroundColor(.black)
                .padding(.horizontal,10)
                .fixedSize()
                .frame(width: 100)

            Spacer()

        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white,.white, .purple]), startPoint: .top, endPoint: .bottom))
    }

}


struct TotalBottlesView: View {
    var entry: Provider.Entry

    let format = NSLocalizedString("totalBottlesWidget", comment: "replace 'bottle' with its singular or plural")
    let totalBottles = NSLocalizedString("totalBottles", comment: "plural : total bottles")

    var body: some View {
        let wineCount = entry.wineCounts[totalBottles]
        let message = String.localizedStringWithFormat(format, wineCount!)
        Text(message)
            .font(.caption2)
            .padding(.vertical,-28)
            .padding(.horizontal,30)
            .fixedSize()
    }
}

//@main
struct WineGPSWidget: Widget {
    let kind: String = "WineGPSWidget"
    
    let selectHeading = NSLocalizedString("selectVarietal", comment: "heading in a selection window of wine varietals")
    
    let selectDescription = NSLocalizedString("selectDescription", comment: "help text in a selection window of wine varietals")
    
    
    var body: some WidgetConfiguration {
        
        IntentConfiguration(
            kind: kind,
            intent: SelectVarietalIntent.self,
            provider: Provider()
        ) { entry in
            WineGPSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(selectHeading)
        .supportedFamilies([.systemSmall])
        .description(selectDescription)
    }
}

struct WineGPSWidgetPlaceholderView: View {
    var body: some View {
        Color(UIColor.systemIndigo)
    }
}
