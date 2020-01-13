import Foundation

extension String {
    var nsRange: NSRange {
        NSRange(self.startIndex..., in: self)
    }
}
