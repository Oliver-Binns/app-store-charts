@main
struct Runner {
    static func main() async throws {
        do {
            let downloads = try await AppStoreConnectAPIService(appName: "General Election 2019")
                .fetchDownloadStatistics()
            print(downloads)
        } catch {
            print("error", error)
        }
    }
}
