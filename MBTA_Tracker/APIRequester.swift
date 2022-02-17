import Foundation

struct APIResponse: Codable {
	var data: [Prediction]
}

struct Prediction: Codable, Hashable {
	var attributes: PredictionAttributes
	
	struct PredictionAttributes: Codable, Hashable {
		var arrival_time: Date
		var departure_time: Date
	}
}

struct Weather: Decodable {
    var main: PredictionAttributes
    var weather: [PredictionAttributes2]
    let name: String
    struct PredictionAttributes: Decodable {
        var temp: Double
    }
    struct PredictionAttributes2: Decodable {
        var description: String
    }
}


func harv_Predictions() -> [Prediction]? {
	let urlString = "https://api-v3.mbta.com/predictions?filter%5Bstop%5D=70130"

	guard let url = URL(string: urlString) else { return nil } // Valid URL

	guard let data = try? Data(contentsOf: url) else { return nil } // Got response

	let decoder = JSONDecoder()
	decoder.dateDecodingStrategy = .iso8601

	return try? decoder.decode(APIResponse.self, from: data).data
}

func blan_Predictions() -> [Prediction]? {
    let urlString = "https://api-v3.mbta.com/predictions?filter%5Bstop%5D=70149"

    guard let url = URL(string: urlString) else { return nil } // Valid URL

    guard let data = try? Data(contentsOf: url) else { return nil } // Got response

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return try? decoder.decode(APIResponse.self, from: data).data
}


func get_temp() -> Double{
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=BOSTON&APPID=9581e38eae9390c82ece6c4d09f43b8f&units=imperial"
    guard let url = URL(string: urlString) else { return -1 } // Valid URL
    guard let data = try? Data(contentsOf: url) else { return -1 } // Got response
    let decoder = JSONDecoder()
    let launch = try? decoder.decode(Weather.self, from: data)
    return launch!.main.temp
}

func get_desc() -> String {
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=BOSTON&APPID=9581e38eae9390c82ece6c4d09f43b8f&units=imperial"
    guard let url = URL(string: urlString) else { return "" } // Valid URL
    guard let data = try? Data(contentsOf: url) else { return "" } // Got response
    let decoder = JSONDecoder()
    let launch = try? decoder.decode(Weather.self, from: data).weather[0]
    return launch!.description
}



