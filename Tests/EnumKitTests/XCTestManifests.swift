import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CaseAccessibleLabelsTests.allTests),
        testCase(CaseAccessibleMatchingTests.allTests),
        testCase(CaseAccessibleExtractionTests.allTests),
        testCase(CaseAccessiblePatternExtrctionTests.allTests),
        testCase(CaseAccessibleUpdateTests.allTests),
        testCase(CaseAccessibleSequenceTests.allTests),
        testCase(CombineFilterTests.allTests),
        testCase(CombineExcludeTests.allTests),
        testCase(CombineMapTests.allTests),
    ]
}
#endif
