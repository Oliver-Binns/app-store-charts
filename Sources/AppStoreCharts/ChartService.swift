import Charts
import SwiftUI

struct ChartService {
    let title: String
    let data: [DatePoint]
    let size: CGSize

    var barChart: some View {
        VStack {
            Text(title)
            Chart(data) {
                BarMark(x: .value("Date", $0.date, unit: .day),
                        y: .value("Units", $0.units))
            }
            .chartXAxisLabel("Date", alignment: .center)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.day(.defaultDigits))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(width: size.width, height: size.height)
        }.padding()
    }

    func write(to url: URL) async {
        await ImageRenderer(content: barChart).cgImage?
            .write(to: url)

    }
}
