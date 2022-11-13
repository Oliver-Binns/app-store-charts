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
            print(downloads)
        } catch {
            print("error", error)
        }
    }
}
