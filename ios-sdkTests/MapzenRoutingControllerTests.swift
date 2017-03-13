//
//  MapzenRoutingControllerTests.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/13/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import XCTest
@testable import ios_sdk
@testable import OnTheRoad

class MapzenRoutingControllerTests : XCTestCase {

  let testSessionManager : TestUrlSession = TestUrlSession()
  var router : MapzenRoutingController? = nil

  override func setUp() {
    MapzenManager.sharedManager.apiKey = "testKey"
    try? router = MapzenRoutingController.controller(sessionManager: testSessionManager)
  }

  func testRouterSendCurrentLocaleLanguageByDefault() {
    let loc1 = OTRRoutingPoint()
    let loc2 = OTRRoutingPoint()
    let _ = router?.requestRoute(withLocations: [loc1, loc2], costingModel: .auto, costingOption: nil, directionsOptions: nil) { (result, any, error) in
      //
    }
    let directionsOptions = testSessionManager.queryParameters?["directions_options"]
    XCTAssertNotNil(directionsOptions)
    let optionsLanguage = directionsOptions!["language"] as AnyObject
    let localeLanguage = Locale.current.languageCode! as String
    XCTAssertEqual(optionsLanguage as? String, localeLanguage)
  }

  func testPassingDirectionsOptionsSendsCorrectLanguage() {
    let loc1 = OTRRoutingPoint()
    let loc2 = OTRRoutingPoint()
    let options = ["language" : "fr"]
    let _ = router?.requestRoute(withLocations: [loc1, loc2], costingModel: .auto, costingOption: nil, directionsOptions: options as [String : NSObject]?) { (result, any, error) in
      //
    }
    let directionsOptions = testSessionManager.queryParameters?["directions_options"]
    XCTAssertNotNil(directionsOptions)
    let optionsLanguage = directionsOptions!["language"] as AnyObject
    XCTAssertEqual(optionsLanguage as? String, "fr")
  }

  func testUpdatingLocaleSendsCorrectLanguage() {
    let loc1 = OTRRoutingPoint()
    let loc2 = OTRRoutingPoint()
    let locale = Locale.init(identifier: "fr-FR")
    router?.updateLocale(locale)
    let _ = router?.requestRoute(withLocations: [loc1, loc2], costingModel: .auto, costingOption: nil, directionsOptions: nil) { (result, any, error) in
      //
    }
    let directionsOptions = testSessionManager.queryParameters?["directions_options"]
    XCTAssertNotNil(directionsOptions)
    let optionsLanguage = directionsOptions!["language"] as AnyObject
    XCTAssertEqual(optionsLanguage as? String, locale.languageCode)
  }

}

