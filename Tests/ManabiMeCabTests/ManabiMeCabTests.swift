import XCTest
@testable import ManabiMeCab

final class ManabiMeCabTests: XCTestCase {
    
    func testParseSimpleWord() {
        let nodes = MeCabUtil.sharedInstance().parseToNode(with: "学校") as? [MeCabNode]
        XCTAssertNotNil(nodes)
        XCTAssertFalse(nodes!.isEmpty)
        XCTAssertEqual(nodes?.first?.surface, "学校")
    }
    
    func testParseMultipleWords() {
        let nodes = MeCabUtil.sharedInstance().parseToNode(with: "私は学生です") as? [MeCabNode]
        XCTAssertNotNil(nodes)
        XCTAssertGreaterThan(nodes!.count, 1)
        let surfaces = nodes?.compactMap { $0.surface }
        XCTAssertEqual(surfaces?.joined(), "私は学生です")
    }
    
    func testEmptyStringReturnsEmpty() {
        let nodes = MeCabUtil.sharedInstance().parseToNode(with: "") as? [MeCabNode]
        XCTAssertNotNil(nodes)
        XCTAssertTrue(nodes!.isEmpty)
    }
    
    func testFeatureExtraction() {
        let nodes = MeCabUtil.sharedInstance().parseToNode(with: "食べる") as? [MeCabNode]
        XCTAssertNotNil(nodes)
        guard let firstFeature = nodes?.first?.feature else {
            XCTFail("Missing feature")
            return
        }
        XCTAssertTrue(firstFeature.contains("動詞") || firstFeature.contains(",動詞,"))
    }
    
    func testFeatureFieldExtraction() {
        guard let nodes = MeCabUtil.sharedInstance().parseToNode(with: "食べる") as? [MeCabNode],
              let node = nodes.first else {
            XCTFail("No parsed nodes")
            return
        }
        
        XCTAssertEqual(node.partOfSpeech(), "動詞")
        XCTAssertNotNil(node.partOfSpeechSubtype1)
        XCTAssertNotNil(node.partOfSpeechSubtype2)
        XCTAssertNotNil(node.partOfSpeechSubtype3)
        XCTAssertNotNil(node.inflection)
        XCTAssertNotNil(node.useOfType)
        XCTAssertNotNil(node.originalForm)
        XCTAssertNotNil(node.reading)
        XCTAssertNotNil(node.pronunciation)
    }
    
    func testFeatureMissingFields() {
        let node = MeCabNode()
        node.feature = "名詞,一般"
        XCTAssertEqual(node.partOfSpeech(), "名詞")
        XCTAssertEqual(node.partOfSpeechSubtype1(), "一般")
        XCTAssertNil(node.partOfSpeechSubtype2())
        XCTAssertNil(node.partOfSpeechSubtype3())
        XCTAssertNil(node.inflection())
        XCTAssertNil(node.useOfType())
        XCTAssertNil(node.originalForm())
        XCTAssertNil(node.reading())
        XCTAssertNil(node.pronunciation())
    }
}
