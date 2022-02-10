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


