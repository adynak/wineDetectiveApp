import UIKit

var str = "Hello, playground"

extension Array where Element: Equatable{
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}

var array = [["Name1","Apple","Fresh"],["Name2","Orange","Rotten"],["Name3","Pear","Fresh"],["Name4","Grape","Rotten"]]

let matches = array.filter { !$0[1].contains("Apple") }

print(matches)


//let barcode = "Apple"
//var receivedList = [["Name1","Apple","Fresh"],["Name2","Orange","Rotten"],["Name3","Pear","Fresh"],["Name4","Grape","Rotten"]]
//
//func filter(keyword: String)-> [[String]] {
//    return receivedList.filter({ (stringArr) -> Bool in
//        for value in stringArr {
//            if value.lowercased().contains(keyword.lowercased()) {
//                return false
//            }
//        }
//        return true
//    })
//    
//    
//}
//var filtered = filter(keyword: barcode ?? "") //Here you will get filtered values
//
//print(filtered)
//
//
////for i in array.indices{
////    print(array[i])
////    array[i].removeAll(where: { $0 == "gammaz" })
////}
////print(array)
