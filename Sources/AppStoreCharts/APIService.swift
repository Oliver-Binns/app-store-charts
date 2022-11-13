import AppStoreConnect_Swift_SDK
import Foundation
import Gzip

protocol APIService {
    func fetchDownloadStatistics() async throws -> [DatePoint]
}

final class AppStoreConnectAPIService: APIService {
    var privateKey: String {
        """
        """
    }
    
    var configuration: APIConfiguration {
        .init(issuerID: "",
              privateKeyID: "",
              privateKey: privateKey.components(separatedBy: .newlines)
            .filter { !$0.isEmpty && !$0.contains("-----") }
            .joined())
    }
    
    lazy var provider = APIProvider(configuration: configuration)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    let appName: String
    
    init(appName: String) {
        self.appName = appName
    }
    
    private func request(for date: String) -> Request<Data> {
        APIEndpoint.v1.salesReports
            .get(parameters: .init(filterFrequency: [.daily],
                                   filterReportDate: [date],
                                   filterReportSubType: [.summary],
                                   filterReportType: [.sales],
                                   filterVendorNumber: [""],
                                   filterVersion: ["1_0"]))
    }
    
    private func makeRequest(for date: String) async throws -> [[Substring]]? {
        let data = try await provider.request(request(for: date)).gunzipped()
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
            .split(separator: "\n")
            .map { $0.split(separator: "\t") }
    }
    
    private func getUnits(for date: String) async throws -> Int? {
        guard let table = try? await makeRequest(for: date),
              let titleIndex = table[0].firstIndex(of: "Title"),
              let unitIndex = table[0].firstIndex(of: "Units") else {
            return 0
        }
        return table
            .filter { $0[titleIndex] == appName }
            .map { String($0[unitIndex]) }
            .compactMap(Int.init)
            .reduce(0, +)
    }
    
    func fetchDownloadStatistics() async throws -> [DatePoint] {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()),
              let range = Calendar.current.range(of: .day, in: .month, for: lastMonth) else {
            return []
        }
        
        let components = Calendar.current.dateComponents([.year, .month], from: lastMonth)
        
        let dates = range
            .compactMap({
                DateComponents(calendar: .current, timeZone: .current,
                               year: components.year,
                               month: components.month,
                               day: $0, hour: 1)
            })
            .compactMap(Calendar.current.date)
        
        return try await withThrowingTaskGroup(of: DatePoint.self,
                                                        returning: [DatePoint].self) { group in
            dates.forEach { date in
                group.addTask { [unowned self] in
                    let units = try await self.getUnits(for: dateFormatter.string(from: date)) ?? 0
                    return DatePoint(date: date, units: units)
                }
            }
            
            return try await group.reduce(into: [DatePoint]()) {
                $0.append($1)
            }.sorted(by: { $0.date < $1.date })
        }
    }
}

struct DatePoint: Identifiable {
    let id = UUID()
    let date: Date
    let units: Int
}