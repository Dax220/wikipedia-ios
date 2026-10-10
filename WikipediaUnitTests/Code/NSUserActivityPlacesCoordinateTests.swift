
import Testing
import CoreLocation
@testable import WMF

struct NSUserActivityPlacesCoordinateTests {

    @Test(arguments: [
        ("wikipedia://places?lat=90&lon=-180", 90.0, -180.0),
        ("wikipedia://places?lat=-90&lon=180", -90.0, 180.0),
        ("wikipedia://places?lat=52.3676&lon=4.9041", 52.3676, 4.9041)
    ])
    func placesURLWithBoundaryCoordinates(_ string: String, latitude: Double, longitude: Double) throws {
        let url = try #require(URL(string: string))
        let activity = try #require(NSUserActivity.wmf_activity(forWikipediaScheme: url))

        #expect(activity.wmf_type() == .places)
        let coordinate = try #require(activity.wmf_placesCoordinate)
        #expect(coordinate.latitude == latitude)
        #expect(coordinate.longitude == longitude)
    }

    @Test(arguments: [
        "wikipedia://places",
        "wikipedia://places?lat=52.3676",
        "wikipedia://places?lon=4.9041",
        "wikipedia://places?lat=abc&lon=4.9041",
        "wikipedia://places?lat=52.3676&lon=abc",
        "wikipedia://places?lat=91&lon=0",
        "wikipedia://places?lat=0&lon=181"
    ])
    func placesURLWithoutValidCoordinates(_ string: String) throws {
        let url = try #require(URL(string: string))
        let activity = try #require(NSUserActivity.wmf_activity(forWikipediaScheme: url))

        #expect(activity.wmf_type() == .places)
        #expect(activity.wmf_placesCoordinate == nil)
    }

    @Test func placesURLWithArticleKeepsWorking() throws {
        let url = try #require(URL(string: "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/wiki/Amsterdam"))
        let activity = try #require(NSUserActivity.wmf_activity(forWikipediaScheme: url))

        #expect(activity.wmf_type() == .places)
        #expect(activity.webpageURL?.absoluteString == "https://en.wikipedia.org/wiki/Amsterdam")
        #expect(activity.wmf_placesCoordinate == nil)
    }
}
