import Foundation

@main
struct Runner {
    static func main() async throws {
        do {
            let privateKey = PrivateKey(keyID: "",
                                        issuerID: "",
                                        rawKey: """
                                        """)
            let configuration = AppStoreConnectAPIService.Configuration
                .init(privateKey: privateKey,
                      vendorNumber: "",
                      appName: "")
            
            let downloads = try await AppStoreConnectAPIService(configuration: configuration)
                .fetchDownloadStatistics()

            let url = FileManager.default.temporaryDirectory.appending(components: "downloads.png")
            await ChartService(title: "Downloads of \(appName) in October 2022",
                               data: downloads,
                               size: .init(width: 700, height: 400))
                .write(to: url)

            print(url.absoluteString)
        } catch {
            print("error", error)
        }
    }
}
