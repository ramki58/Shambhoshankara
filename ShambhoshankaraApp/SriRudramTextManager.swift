import Foundation

struct TextSegment {
    let startTime: TimeInterval
    let endTime: TimeInterval
    let telugu: String
    let sanskrit: String
    let transliteration: String
    let meaning: String?
    let imageName: String?
}

struct TrackText {
    let trackFileName: String
    let segments: [TextSegment]
}

class SriRudramTextManager {
    static let shared = SriRudramTextManager()
    
    private init() {}
    
    func getTextForTrack(_ fileName: String) -> [TextSegment] {
        // Extract part number from fileName (P01, P02, etc.)
        if fileName.contains("RudraNamakam") {
            if let range = fileName.range(of: "_P\\d+_", options: .regularExpression) {
                let partStr = String(fileName[range]).replacingOccurrences(of: "_P", with: "").replacingOccurrences(of: "_", with: "")
                if let partNum = Int(partStr) {
                    return getNamakamPartText(partNum)
                }
            }
        }
        
        if fileName.contains("RudraChamakam") {
            return getChamakamText()
        }
        
        return []
    }
    
    private func getNamakamPartText(_ partNumber: Int) -> [TextSegment] {
        // Always use image for Part 1
        if partNumber == 1 {
            return getPart1Text()
        }
        
        let content = SriRudramContent.getContentForPart(partNumber, isNamakam: true)
        
        if content.isEmpty {
            return getGenericNamakamText(partNumber)
        }
        
        var segments: [TextSegment] = []
        let segmentDuration: TimeInterval = 60.0 // Each verse gets ~60 seconds
        
        for (index, sanskrit) in content.enumerated() {
            let startTime = TimeInterval(index) * segmentDuration
            let endTime = startTime + segmentDuration
            
            let segment = TextSegment(
                startTime: startTime,
                endTime: endTime,
                telugu: SriRudramContent.getTeluguText(for: sanskrit),
                sanskrit: sanskrit,
                transliteration: SriRudramContent.getTransliteration(for: sanskrit),
                meaning: SriRudramContent.getMeaning(for: sanskrit),
                imageName: nil
            )
            segments.append(segment)
        }
        
        return segments
    }
    

    
    private func getChamakamText() -> [TextSegment] {
        // Extract Chamakam part number from filename if possible
        let chamakamPart = 1 // Default to part 1, could be extracted from filename
        let content = SriRudramContent.getContentForPart(chamakamPart, isNamakam: false)
        
        if content.isEmpty {
            // Fallback content
            return [
                TextSegment(
                    startTime: 0,
                    endTime: 30,
                    telugu: "అగ్నిశ్చ మే ఆపశ్చ మే",
                    sanskrit: "अग्निश्च मे आपश्च मे",
                    transliteration: "Agnishcha me aapashcha me",
                    meaning: "May fire be mine, may water be mine",
                    imageName: nil
                ),
                TextSegment(
                    startTime: 30,
                    endTime: 60,
                    telugu: "తేజశ్చ మే వాయుశ్చ మే",
                    sanskrit: "तेजश्च मे वायुश्च मे",
                    transliteration: "Tejashcha me vaayushcha me",
                    meaning: "May brilliance be mine, may wind be mine",
                    imageName: nil
                )
            ]
        }
        
        var segments: [TextSegment] = []
        let segmentDuration: TimeInterval = 45.0 // Chamakam verses are typically longer
        
        for (index, sanskrit) in content.enumerated() {
            let startTime = TimeInterval(index) * segmentDuration
            let endTime = startTime + segmentDuration
            
            let segment = TextSegment(
                startTime: startTime,
                endTime: endTime,
                telugu: SriRudramContent.getTeluguText(for: sanskrit),
                sanskrit: sanskrit,
                transliteration: SriRudramContent.getTransliteration(for: sanskrit),
                meaning: SriRudramContent.getMeaning(for: sanskrit),
                imageName: nil
            )
            segments.append(segment)
        }
        
        return segments
    }
    
    func getCurrentSegment(for fileName: String, at currentTime: TimeInterval) -> TextSegment? {
        let segments = getTextForTrack(fileName)
        return segments.first { segment in
            currentTime >= segment.startTime && currentTime < segment.endTime
        }
    }
    
    private func getGenericNamakamText(_ lessonNumber: Int) -> [TextSegment] {
        // Use actual Telugu text for specific parts
        if lessonNumber == 1 {
            return getPart1Text()
        } else if lessonNumber == 2 {
            return getPart2Text()
        } else if lessonNumber == 3 {
            return getPart3Text()
        } else if lessonNumber == 4 {
            return getPart4Text()
        } else if lessonNumber == 5 {
            return getPart5Text()
        }
        
        // Fallback for parts not yet added
        return getGenericPartText(lessonNumber)
    }
    
    private func getPart1Text() -> [TextSegment] {
        return [
            TextSegment(
                startTime: 0,
                endTime: 999,
                telugu: "",
                sanskrit: "",
                transliteration: "",
                meaning: nil,
                imageName: "Namakam_lesson_1"
            )
        ]
    }
    
    private func getPart2Text() -> [TextSegment] {
        return getGenericPartText(2)
    }
    
    private func getPart3Text() -> [TextSegment] {
        return getGenericPartText(3)
    }
    
    private func getPart4Text() -> [TextSegment] {
        return getGenericPartText(4)
    }
    
    private func getPart5Text() -> [TextSegment] {
        return getGenericPartText(5)
    }
    
    private func getGenericPartText(_ partNumber: Int) -> [TextSegment] {
        return [
            TextSegment(
                startTime: 0,
                endTime: 60,
                telugu: "నమస్తే రుద్ర మన్యవ ఉతో త ఇషవే నమః",
                sanskrit: "नमस्ते रुद्र मन्यव उतो त इषवे नमः",
                transliteration: "Namaste rudra manyava uto ta ishave namah",
                meaning: "Salutations to Rudra, the angry one, and to your arrow - Part \(partNumber)",
                imageName: nil
            )
        ]
    }
}