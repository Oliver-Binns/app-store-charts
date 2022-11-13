import Charts
import SwiftUI

struct ChartService {
    let data: [DatePoint]
    
    var barChart: some View {
        Chart {
            ForEach(data) { date in
                BarMark(x: .value("Date", date.date),
                        y: .value("Units", date.units))
            }
        }
    }
    
    
}
