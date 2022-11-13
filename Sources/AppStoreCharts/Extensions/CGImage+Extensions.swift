import CoreGraphics
import Foundation
import ImageIO

extension CGImage {
    @discardableResult
    func write(to url: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, self, nil)
        return CGImageDestinationFinalize(destination)
    }
}
