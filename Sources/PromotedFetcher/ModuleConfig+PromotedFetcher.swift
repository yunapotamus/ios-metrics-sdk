import Foundation

#if !COCOAPODS
import PromotedCore
#endif

public extension ModuleConfig {
  @objc static func fetcherConfig() -> ModuleConfig {
    let config = coreConfig()
    config.useFetcher()
    return config
  }

  @objc func useFetcher() {
    networkConnection = GTMSessionFetcherConnection()
  }
}
