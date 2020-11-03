//
//  Copyright © 2020 Curato Research BV. All rights reserved.
//

import Foundation
import Quick

func given(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
    describe("Given \(description)", flags: flags, closure: closure)
}

func when(_ description: String, closure: @escaping QCKDSLEmptyBlock) {
    context("When \(description)", closure)
}

func and(_ description: String, closure: @escaping QCKDSLEmptyBlock) {
    context("And \(description)", closure)
}

func then(_ description: String, flags: FilterFlags = [:], file: String = #file, line: UInt = #line, closure: @escaping () -> Void) {
    it("Then \(description)", flags: flags, file: file, line: line, closure: closure)
}
