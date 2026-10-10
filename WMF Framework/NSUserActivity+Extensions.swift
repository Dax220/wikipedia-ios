import Foundation
import CoreLocation

public extension NSUserActivity {
    @objc var shouldSkipOnboarding: Bool {
        guard let path = webpageURL?.wikiResourcePath,
              let languageCode = webpageURL?.wmf_languageCode else {
            return false
        }

        let namespaceAndTitle = path.namespaceAndTitleOfWikiResourcePath(with: languageCode)
        let namespace = namespaceAndTitle.0
        let title = namespaceAndTitle.1

        return namespace == .special && title == "ReadingLists"
    }
}

public extension NSUserActivity {
    var wmf_placesCoordinate: CLLocationCoordinate2D? {
        guard let latitude = (userInfo?["WMFLatitude"] as? String).flatMap(Double.init),
              let longitude = (userInfo?["WMFLongitude"] as? String).flatMap(Double.init) else {
            return nil
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return CLLocationCoordinate2DIsValid(coordinate) ? coordinate : nil
    }
}
