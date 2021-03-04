import CommonCrypto
import Foundation

/** Maps client-side IDs to server-side IDs. */
public protocol IDMap {
  
  /// Produces a deterministic UUID string given an input value.
  /// Collision of returned values when given different input should
  /// be the same as generating new UUIDs. The generated UUIDs are
  /// not necessarily cryptographically secure.
  func deterministicUUIDString(value: String?) -> String

  /// Given a client-side user ID, generate a log user ID which
  /// is used to track the the current session without exposing
  /// the underlying user ID.
  func logUserID(userID: String?) -> String

  /// Given a client-side ID, generate a server-side impression ID.
  func impressionID(clientID: String?) -> String
  
  /// Generates a new click ID.
  func clickID() -> String
}

/**
 DO NOT INSTANTIATE. Base class for IDMap implementation.
 The `impressionID(clientID:)` and `logUserID(userID:)` methods would
 ideally be in the protocol extension, but doing so prevents
 FakeIDMap from overriding them for tests.
 */
open class AbstractIDMap: IDMap {

  public init() {}

  open func deterministicUUIDString(value: String?) -> String {
    return ""
  }

  open func logUserID(userID: String?) -> String {
    return UUID().uuidString
  }

  open func impressionID(clientID: String?) -> String {
    return deterministicUUIDString(value: clientID)
  }
  
  open func clickID() -> String {
    return UUID().uuidString
  }
}

/** SHA1-based deterministic UUID generation. */
public class SHA1IDMap: AbstractIDMap {
  
  public static let instance = SHA1IDMap()
  
  private override init() {}
  
  public override func deterministicUUIDString(value: String?) -> String {
    if let s = value { return SHA1IDMap.sha1(s) }
    return "00000000-0000-0000-0000-000000000000"
  }

  static func sha1(_ value: String) -> String {
    var context = CC_SHA1_CTX()
    CC_SHA1_Init(&context)
    _ = value.withCString { (cString) in
      CC_SHA1_Update(&context, cString, CC_LONG(strlen(cString)))
    }
    var array = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
    CC_SHA1_Final(&array, &context)
    array[6] = (array[6] & 0x0F) | 0x50 // set version number nibble to 5
    array[8] = (array[8] & 0x3F) | 0x80 // reset clock nibbles
    let uuid = UUID(uuid: (array[0], array[1], array[2], array[3],
                           array[4], array[5], array[6], array[7],
                           array[8], array[9], array[10], array[11],
                           array[12], array[13], array[14], array[15]))
    return uuid.uuidString
  }
}
