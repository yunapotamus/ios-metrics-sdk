import Foundation
import XCTest

@testable import PromotedCore

final class ClientConfigTests: XCTestCase {

  func testValue() {
    var config = ClientConfig()
    config.disableAssertInValidationForTesting()
    let mirror = Mirror(reflecting: config)
    for child in mirror.children {
      guard let name = child.label else {
        XCTFail("Child with no label: \(String(describing: child))")
        return
      }
      if name == "assertInValidation" { continue }
      XCTAssertNotNil(config.value(forKey: name))
    }
  }

  func testSetValue() {
    var config = ClientConfig()
    // Don't call config.disableAssertInValidationForTesting().
    // If this test trips the assert, you need to add support
    // for your new property in value()/setValue().
    let mirror = Mirror(reflecting: config)
    for child in mirror.children {
      guard let name = child.label else {
        XCTFail("Child with no label: \(String(describing: child))")
        return
      }
      if name == "assertInValidation" { continue }
      config.setValue(child.value, forKey: name)
    }
  }

  func testBound() {
    var config = ClientConfig()
    config.disableAssertInValidationForTesting()
    config.loggingFlushInterval = -1.0
    XCTAssertEqual(1.0, config.loggingFlushInterval, accuracy: 0.001)
  }

  func testBadEnumValues() {
    var config = ClientConfig()
    config.disableAssertInValidationForTesting()

    config.setValue("invalid", forKey: "metricsLoggingWireFormat")
    XCTAssertEqual(.binary, config.metricsLoggingWireFormat)

    config.setValue("invalid", forKey: "xrayLevel")
    XCTAssertEqual(.none, config.xrayLevel)

    config.setValue("invalid", forKey: "osLogLevel")
    XCTAssertEqual(.none, config.osLogLevel)

    config.setValue("invalid", forKey: "metricsLoggingErrorHandling")
    XCTAssertEqual(.none, config.metricsLoggingErrorHandling)
  }

  func testPassByValue() {
    var config1 = ClientConfig()
    config1.metricsLoggingURL = "https://fake.promoted.ai/hippo/potamus"
    var config2 = config1
    config2.metricsLoggingURL = "https://fake.promoted.ai/rhino/cerous"
    XCTAssertEqual(
      "https://fake.promoted.ai/hippo/potamus",
      config1.metricsLoggingURL
    )
    XCTAssertEqual(
      "https://fake.promoted.ai/rhino/cerous",
      config2.metricsLoggingURL
    )
  }
}
