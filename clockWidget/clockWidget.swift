//
//  clockWidget.swift
//  clockWidget
//
//  Created by  玉城 on 2024/4/23.
//

import WidgetKit
import SwiftUI


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 10 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
            
        }
        
        return Timeline(entries: entries, policy: .atEnd)
        
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct FlipClockNumberView :View{
    var number: Int
    var body: some View{
        //        clock4SwiftUIView(num:number,num2:number,num3:number,num4:number)
        Text("\(number)")
            .font(.system(size: 180,weight: .bold,design: .default))
            .foregroundColor(.white)
            .frame(width: 160,height: 180)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
        
        
    }
}

struct TimeView: View {
    //    private let timer = Timer.publish(every:1,on:.main, in:.common).autoconnect()
    var entry: Provider.Entry
    
    var body: some View {
        Text("\(entry.date, style: .time)").offset(y:6).offset(x:-6).foregroundColor(.white)
    }
}
struct DateView: View {
    var entry: Provider.Entry
    var body: some View {
        Text("\(entry.date, style: .date)").foregroundColor(.white)
    }
}
struct WeekView: View {
    var entry: Provider.Entry
    let dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    var body: some View {
        let formattedDate = dateFormatter1.string(from: entry.date).prefix(3)
        return Text(String(formattedDate)).foregroundColor(.white)
    }
}



struct clockWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    //    private let timer = Timer.publish(every:1,on:.main, in:.common).autoconnect()
    
    let entry: Provider.Entry
    
    @State private var flag = false
    var body: some View {
        
        
        VStack(){
            switch widgetFamily {
            case .systemLarge:
                
                
                TimeView(entry:entry).font(Font.custom("Bebas Neue", size:160))
                HStack{
                    DateView(entry:entry).font(Font.custom("Bebas Neue", size:24))
                    WeekView(entry:entry).font(Font.custom("Bebas Neue", size:24))
                }.offset(y:-16)
                Text(entry.configuration.favoriteEmoji).foregroundColor(.white).font(Font.custom("Bebas Neue", size:24))
                Spacer().frame(height:20)
            case .systemMedium:
                
                Spacer().frame(height: 20)
                Text(Date().getCurrentDayStart(true), style: .timer).font(Font.custom("Bebas Neue", size:100)).foregroundColor(.white)
                HStack{
                    DateView(entry:entry).font(Font.custom("Bebas Neue", size:20))
                    WeekView(entry:entry).font(Font.custom("Bebas Neue", size:20))
                }.offset(y:-16)
                Spacer().frame(height:6)
                //                }
                //
                
            case .systemSmall:
                VStack{
//                    TimeView(entry:entry).font(Font.custom("Bebas Neue", size:60))
                    Text(Date().getCurrentDayStart(true), style: .timer).font(Font.custom("Bebas Neue", size:44)).foregroundColor(.white)
                    DateView(entry:entry).font(Font.custom("Bebas Neue", size:20)).offset(x:2)
                    WeekView(entry:entry).font(Font.custom("Bebas Neue", size:20)).offset(x:2)
                }
            default:
                VStack{
                    TimeView(entry:entry).font(Font.custom("Bebas Neue", size:70))
                    DateView(entry:entry).font(Font.custom("Bebas Neue", size:20)).offset(x:2)
                    WeekView(entry:entry).font(Font.custom("Bebas Neue", size:20)).offset(x:2)
                }
            }
            
        }
    }
    
    
}

struct clockWidget: Widget {
    let kind: String = "clockWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            clockWidgetEntryView(entry: entry)
                .containerBackground(Color.black, for: .widget)
        }
        .supportedFamilies([.systemLarge,.systemSmall,.systemMedium])
        //        .configurationDisplayName("My Widget")
        //        .description("this is a sample widget")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "less is more"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "less is more"
        return intent
    }
}

extension Date {
    func getCurrentDayStart(_ isDayOf24Hours: Bool)-> Date {
        let calendar:Calendar = Calendar.current;
        let year = calendar.component(.year, from: self);
        let month = calendar.component(.month, from: self);
        let day = calendar.component(.day, from: self);
        
        let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        return Calendar.current.date(from: components)!
    }
}

#Preview(as: .systemLarge) {
//    #Preview(as: .systemMedium) {
    //    #Preview(as: .systemSmall) {
    clockWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}






