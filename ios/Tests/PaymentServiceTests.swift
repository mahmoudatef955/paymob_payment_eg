import XCTest
import PaymobSDK
@testable import paymob_payment_eg

class MockPaymobSDK: PaymobSDK {
    var presentPayVCCalled = false
    
    override func presentPayVC(VC: UIViewController, PublicKey: String, ClientSecret: String) throws {
        presentPayVCCalled = true
    }
}

class PaymentServiceTests: XCTestCase {
    func testPaymentConfiguration() {
        let mockSDK = MockPaymobSDK()
        let service = PaymentService(paymob: mockSDK)
        
        let config = PaymentConfiguration(
            appName: "Test App",
            buttonBackgroundColor: .black,
            buttonTextColor: .white,
            saveCardDefault: false,
            showSaveCard: true,
            savedCard: nil
        )
        
        service.configure(with: config)
        
        let credentials = PaymentCredentials(
            publicKey: "test_key",
            clientSecret: "test_secret"
        )
        
        try? service.startPayment(
            viewController: UIViewController(),
            credentials: credentials
        )
        
        XCTAssertTrue(mockSDK.presentPayVCCalled)
    }
} 