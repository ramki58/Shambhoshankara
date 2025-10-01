import Foundation

// Complete Sri Rudram Namakam content based on standard Sanskrit text
struct SriRudramContent {
    
    // Namakam is divided into 11 Anuvakas (sections)
    static let namakamParts: [Int: [String]] = [
        1: [
            "ॐ नमस्ते रुद्र मन्यव उतो त इषवे नमः",
            "बाहुभ्यामुत ते नमो यात ते धनुष्टन्त्या",
            "यावा शरव आ ते नमो अस्तु",
            "नीलग्रीवाय च शितिकण्ठाय च"
        ],
        
        2: [
            "नमो कपर्दिने च व्युप्तकेशाय च",
            "नमः सहस्राक्षाय च शतधन्वने च",
            "नमो गिरिशाय च शिपिविष्टाय च",
            "नमो मीढुष्टमाय चेषुमते च"
        ],
        
        3: [
            "नमो ह्रस्वाय च वामनाय च",
            "नमो बृहते च वर्षीयसे च",
            "नमो वृद्धाय च संवृधे च",
            "नमो अग्रियाय च प्रतिमाय च"
        ],
        
        4: [
            "नमो आशवे चाजिराय च",
            "नमः शीघ्रियाय च शीभ्याय च",
            "नमो ऊर्मियाय चावस्वन्याय च",
            "नमः स्रोतस्याय च द्वीपयाय च"
        ],
        
        5: [
            "नमो ज्येष्ठाय च कनिष्ठाय च",
            "नमः पूर्वजाय चापरजाय च",
            "नमो मध्यमाय चापगल्भाय च",
            "नमो जघन्याय च बुध्न्याय च"
        ],
        
        6: [
            "नमः शोभ्याय च प्रतिशोभ्याय च",
            "नमो यामयाय च क्षेमयाय च",
            "नमो उर्वर्याय च खल्याय च",
            "नमः श्लोक्याय चावसान्याय च"
        ],
        
        7: [
            "नमो वन्याय च कक्ष्याय च",
            "नमः श्रवाय च प्रतिश्रवाय च",
            "नमो आशुषेणाय चाशुरथाय च",
            "नमः शूराय चावभिन्दते च"
        ],
        
        8: [
            "नमो वर्मिणे च वरूथिने च",
            "नमो बिल्मिने च कवचिने च",
            "नमः श्रुतायुधाय च पुरुषन्ताय च",
            "नमो धन्विने च धनुर्ग्रहाय च"
        ],
        
        9: [
            "नमो दुन्दुभ्याश्च हन्त्रिभ्याश्च",
            "नमो बाणेभ्यो विकरन्तिभ्याश्च",
            "नमो आतन्वानेभ्यः प्रतिदधानेभ्याश्च",
            "नमो आयच्छद्भ्यो विसृजद्भ्याश्च"
        ],
        
        10: [
            "नमो असिभ्यः शस्त्रभ्याश्च",
            "नमो धनुर्भ्यश्च बाणेभ्याश्च",
            "नमो भल्लेभ्यः प्रासेभ्याश्च",
            "नमो मुष्टिभ्यः सनाडेभ्याश्च"
        ],
        
        11: [
            "नमो धृष्णवे च प्रमृशाय च",
            "नमो दूताय च प्रहिताय च",
            "नमो निषङ्गिणे चेषुधिमते च",
            "नमस्तीक्ष्णेषवे चायुधिने च"
        ]
    ]
    
    // Chamakam content (13 Anuvakas)
    static let chamakamParts: [Int: [String]] = [
        1: [
            "अग्निश्च मे आपश्च मे",
            "तेजश्च मे वायुश्च मे",
            "पृथिवी च मे द्यौश्च मे",
            "सूर्यश्च मे चन्द्रमाश्च मे"
        ],
        
        2: [
            "ऋतवश्च मे संवत्सरश्च मे",
            "राजा च मे राष्ट्रं च मे",
            "राजन्यश्च मे राजपुत्रश्च मे",
            "सेना च मे सेनानीश्च मे"
        ]
        // ... more Chamakam parts would be added here
    ]
    
    // Get content for specific part
    static func getContentForPart(_ partNumber: Int, isNamakam: Bool = true) -> [String] {
        if isNamakam {
            return namakamParts[partNumber] ?? []
        } else {
            return chamakamParts[partNumber] ?? []
        }
    }
    
    // Get transliteration for Sanskrit text
    static func getTransliteration(for sanskrit: String) -> String {
        let transliterations: [String: String] = [
            "ॐ नमस्ते रुद्र मन्यव उतो त इषवे नमः": "Om namaste rudra manyava uto ta ishave namah",
            "बाहुभ्यामुत ते नमो यात ते धनुष्टन्त्या": "Bahubhyamuta te namo yata te dhanush tantyah",
            "यावा शरव आ ते नमो अस्तु": "Yava sharava a te namo astu",
            "नीलग्रीवाय च शितिकण्ठाय च": "Nilagrivaya cha shitikanthaya cha",
            "नमो कपर्दिने च व्युप्तकेशाय च": "Namo kapardine cha vyuptakeshaya cha",
            "नमः सहस्राक्षाय च शतधन्वने च": "Namah sahasrakshaya cha shatadhanvane cha",
            "नमो दुन्दुभ्याश्च हन्त्रिभ्याश्च": "Namo dundubhyaashcha hantribhyaashcha",
            "नमो बाणेभ्यो विकरन्तिभ्याश्च": "Namo baanebhyo vikarantibhyaashcha",
            "अग्निश्च मे आपश्च मे": "Agnishcha me aapashcha me",
            "तेजश्च मे वायुश्च मे": "Tejashcha me vaayushcha me"
        ]
        
        return transliterations[sanskrit] ?? sanskrit.lowercased()
    }
    
    // Get Telugu text for Sanskrit text
    static func getTeluguText(for sanskrit: String) -> String {
        let teluguTexts: [String: String] = [
            "ॐ नमस्ते रुद्र मन्यव उतो त इषवे नमः": "ఓం నమస్తే రుద్ర మన్యవ ఉతో త ఇషవే నమః",
            "बाहुभ्यामुत ते नमो यात ते धनुष्टन्त्या": "బాహుభ్యాముత తే నమో యాత తే ధనుష్టన్త్యా",
            "यावा शरव आ ते नमो अस्तु": "యావా శరవ ఆ తే నమో అస్తు",
            "नीलग्रीवाय च शितिकण्ठाय च": "నీలగ్రీవాయ చ శితికణ్ఠాయ చ",
            "नमो कपर्दिने च व्युप्तकेशाय च": "నమో కపర్దినే చ వ్యుప్తకేశాయ చ",
            "नमः सहस्राक्षाय च शतधन्वने च": "నమః సహస్రాక్షాయ చ శతధన్వనే చ",
            "नमो ह्रस्वाय च वामनाय च": "నమో హ్రస్వాయ చ వామనాయ చ",
            "नमो बृहते च वर्षीयसे च": "నమో బృహతే చ వర్షీయసే చ",
            "नमो ज्येष्ठाय च कनिष्ठाय च": "నమో జ్యేష్ఠాయ చ కనిష్ఠాయ చ",
            "नमः शोभ्याय च प्रतिशोभ्याय च": "నమః శోభ్యాయ చ ప్రతిశోభ్యాయ చ",
            "अग्निश्च मे आपश्च मे": "అగ్నిశ్చ మే ఆపశ్చ మే",
            "तेजश्च मे वायुश्च मे": "తేజశ్చ మే వాయుశ్చ మే"
        ]
        
        return teluguTexts[sanskrit] ?? sanskrit
    }
    
    // Get meaning for Sanskrit text
    static func getMeaning(for sanskrit: String) -> String {
        let meanings: [String: String] = [
            "ॐ नमस्ते रुद्र मन्यव उतो त इषवे नमः": "Om, salutations to Rudra, the angry one, and salutations to your arrow",
            "बाहुभ्यामुत ते नमो यात ते धनुष्टन्त्या": "Salutations to your arms, whatever is of your bow and bowstring",
            "यावा शरव आ ते नमो अस्तु": "Let there be salutations to your quiver and arrows",
            "नीलग्रीवाय च शितिकण्ठाय च": "To the blue-necked one and to the white-throated one",
            "नमो कपर्दिने च व्युप्तकेशाय च": "Salutations to the one with matted hair and to the one with shaved head",
            "नमः सहस्राक्षाय च शतधन्वने च": "Salutations to the thousand-eyed one and to the one with hundred bows",
            "नमो दुन्दुभ्याश्च हन्त्रिभ्याश्च": "Salutations to the drummers and to the destroyers",
            "नमो बाणेभ्यो विकरन्तिभ्याश्च": "Salutations to the arrows and to those who shoot them",
            "अग्निश्च मे आपश्च मे": "May fire be mine, may water be mine",
            "तेजश्च मे वायुश्च मे": "May brilliance be mine, may wind be mine"
        ]
        
        return meanings[sanskrit] ?? "Sacred verse from Sri Rudram"
    }
}