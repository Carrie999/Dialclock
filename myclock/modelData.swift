//
//  modelData.swift
//  myclock
//
//  Created by  玉城 on 2024/4/22.
//

import Foundation
import SwiftUI
import CoreLocation

struct Landmark: Codable,Identifiable {
    var id: Int
    var name: String
//    var park: String
//    var state: String
//    var description: String
//    var isFavorite: Bool
//    var isFeatured: Bool
    var themeBackgroundColor: String
      var themeBgSecondColor: String
      var themeTextColor: String

//    var category: Category
//    enum Category: String, CaseIterable, Codable {
//        case lakes = "Lakes"
//        case rivers = "Rivers"
//        case mountains = "Mountains"
//    }
//
//    private var imageName: String
//    var image: Image {
//        Image(imageName)
//    }
//
//    private var coordinates: Coordinates
//    var locationCoordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(
//            latitude: coordinates.latitude,
//            longitude: coordinates.longitude)
//    }
//
//    struct Coordinates: Hashable, Codable {
//        var latitude: Double
//        var longitude: Double
//    }
}


@Observable
class ModelData {
    var landmarks: [Landmark] = load("landmarkData.json")
//    var hikes: [Hike] = load("hikeData.json")
//    var profile = Profile.default
//
//    var features: [Landmark] {
//        landmarks.filter { $0.isFeatured }
//    }
//
//    var categories: [String: [Landmark]] {
//        Dictionary(
//            grouping: landmarks,
//            by: { $0.category.rawValue }
//        )
//    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
