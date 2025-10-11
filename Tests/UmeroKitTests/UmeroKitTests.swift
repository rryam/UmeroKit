import Testing
@testable import UmeroKit

@Suite("UmeroKit Basic Tests")
struct UmeroKitTests {
    @Test("Basic test")
    func basicTest() {
        #expect("Testing, ok?" == "Testing, ok?")
    }
}
