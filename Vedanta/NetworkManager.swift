import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let apiKey = "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"
    private let apiUrl = "https://api-inference.huggingface.co/models/gpt2"

    func getChatbotResponse(inputText: String, completion: @escaping (String?) -> Void) {
        guard !inputText.isEmpty else {
            completion("Error: Input text cannot be empty.")
            return
        }

        let url = URL(string: apiUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "inputs": inputText,
            "parameters": [
                "max_length": 50,
                "top_p": 0.9,
                "temperature": 0.7
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion("Error creating JSON body: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion("Error: No data received.")
                return
            }

            // Log raw response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }

            do {
                // Decode the JSON response
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    // Extract "generated_text" from the first object
                    if let firstItem = jsonArray.first,
                       let generatedText = firstItem["generated_text"] as? String {
                        let cleanedResponse = generatedText
                            .replacingOccurrences(of: "\n", with: " ")
                            .replacingOccurrences(of: "\t", with: "")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        completion(cleanedResponse)
                    } else {
                        completion("Error: Missing 'generated_text' in response.")
                    }
                } else {
                    completion("Error: Unexpected response format.")
                }
            } catch {
                completion("Error parsing response: \(error.localizedDescription)")
            }
        }

        task.resume()
    }





}
