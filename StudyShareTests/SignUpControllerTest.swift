//
//  SignUpControllerTest.swift
//  StudyShareTests
//
//  Unit Test for the SignUpViewController.
//  Created by Zac Seales on 21/09/22.
//

import XCTest
import Firebase

@testable import StudyShare
/**
 Performs testing on the sign up view contoller
 */
class SignUpControllerTest: XCTestCase {

    private var firstName: String = ""
    private var lastName: String = ""
    private var password: String = ""
    private var email: String = ""
    
    // set up some test data
    override func setUpWithError() throws {
        self.firstName = "fnameTest"
        self.lastName = "lnameTest"
        self.email = "email@test.com"
        self.password = "passTest1?"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /** Tests a few of the validateFields method cases when input fields are left empty,
     *  to ensure method is detecting and managing invalid input correctly.
     */
    func test_validateFields_failure() throws {
        let errorMessage = "Please fill in all fields"
        // set up test instance
        let vm = SignUpViewController()
        
        // first ensure no error message is shown
        XCTAssertEqual(vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), nil)
        
        //test no email
        self.email = ""
        XCTAssertEqual(vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        // test no first name
        self.firstName = ""
        self.email = "email@test.com"
        XCTAssertEqual(vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        // test no password
        self.firstName = "fNameTest"
        self.password = ""
        XCTAssertEqual(vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        //test no last name
        self.lastName = ""
        self.password = "passTest1?"
        XCTAssertEqual(vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), errorMessage)
        
        // add back in the missing value and test valid case
        // to further validate this test method
        self.lastName = "lnameTest"
        XCTAssertEqual(vm.validateFields(fname: self.firstName, lname: self.lastName, email: self.email, password: self.password), nil)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
