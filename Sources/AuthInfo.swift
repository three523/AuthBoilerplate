
import Foundation

enum InsertPosition {
    case front
    case back
}

protocol AuthInfo {
    func setup(plistDict: NSMutableDictionary) -> NSMutableDictionary
}
