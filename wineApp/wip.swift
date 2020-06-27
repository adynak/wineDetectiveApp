//import UIKit
//struct Level0 {
//    var producer: String
//    var bottleCount: Int
//    var isExpanded: Bool = false
//    var label: [bottleDetail]
//    var storage: [Level1]
//}
//
//struct Level1 {
//    var location: String
//    var bin: String
//    var barcode: String
//    var binSort: String
//}
//
//struct bottleDetail {
//    var vvp: String
//    var vintage: String
//    var varietal: String
//    var producer: String
//    var linear: Float
//}
//
//struct Bottle {
//    let producer: String
//    let varietal: String
//    let location: String
//    let bin: String
//    let vintage: String
//    let iWine: String
//    let barcode: String
//    var bottleSort: String
//    var binSort: String
//    var linear: String
//}
//
//var wines: [Bottle] = []
//var level0: [Level0] = []
//var level1: [Level1] = []
//var label: [bottleDetail] = []
//var bottle: Bottle
//
//bottle = Bottle(producer: "Natalies", varietal: "Cabernet Sauvignon", location: "Cellar", bin: "E", vintage: "2014", iWine: "3100463", barcode: "123", bottleSort: "", binSort: "", linear: "101.990684931507")
//bottle.binSort = bottle.location + bottle.bin
//bottle.bottleSort = bottle.vintage + bottle.varietal + bottle.producer
//wines.append(bottle)
//
//bottle = Bottle(producer: "Kiona", varietal: "Cabernet Sauvignon", location: "Tall", bin: "H", vintage: "2016", iWine: "3599013", barcode: "456", bottleSort: "", binSort: "", linear: "1.38735849056604")
//bottle.binSort = bottle.location + bottle.bin
//bottle.bottleSort = bottle.vintage + bottle.varietal + bottle.producer
//wines.append(bottle)
//
//bottle = Bottle(producer: "Kiona", varietal: "Cabernet Sauvignon", location: "Tall", bin: "G", vintage: "2016", iWine: "3599013", barcode: "789", bottleSort: "", binSort: "", linear: "1.38735849056604")
//bottle.binSort = bottle.location + bottle.bin
//bottle.bottleSort = bottle.vintage + bottle.varietal + bottle.producer
//wines.append(bottle)
//
//
//extension String {
//    var floatValue: Float {
//        return (self as NSString).floatValue
//    }
//}
//
//var producer: String = ""
//let groupLevel0 = Dictionary(grouping: wines, by: { $0.bottleSort })
//for (item0) in groupLevel0{
//    let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.binSort })
//    for (item1) in groupLevel1{
//        for (detail) in item1.value {
//            level1.append(Level1(
//                location: detail.location,
//                bin: detail.bin,
//                barcode: detail.barcode,
//                binSort: detail.binSort))
//        }
//        level1 =  level1.sorted(by: {
//            ($0.binSort.lowercased()) < ($1.binSort.lowercased())
//        })
//    }
//    for (item) in item0.value {
//        label.append(bottleDetail(vvp: item.vintage + item.varietal + item.producer,
//                                  vintage: item.vintage,
//                                  varietal: item.varietal,
//                                  producer: item.producer,
//                                  linear: item.linear.floatValue))
//        break
//    }
//    level0.append(Level0(producer: producer, bottleCount: level1.count, label: label, storage: level1))
//    level1.removeAll()
//    label.removeAll()
//}
//
//level0 = level0.sorted(by: {
//    ($0.label[0].vvp.lowercased()) > ($1.label[0].vvp.lowercased())
//})
//
//dump(level0)
//print("")
//
//level0 = level0.sorted(by: {
//    ($0.label[0].linear) > ($1.label[0].linear)
//})
//dump(level0)
//
//
//
//
//
