//
//  MatrixError.swift
//  
//
//  Created by Anna Münster on 24.05.22.
//

import Foundation

public enum MatrixError: LocalizedError {
    case    indexNotExisting(index: Int, count: Int),
            inputMising(needed: Int, got: Int),
            notInvertable,
            notSquarish,
            wrongDimensions(needed: Int, got: Int)
    case unimplemented(method: String)
    
    public var errorDescription: String? {
        switch self {
        case .indexNotExisting(let index, let count): return "Matrix Error: Row index not existing. Asked for index \(index), but we only have \(count)"
        case .inputMising(let needed, let got): return "Matrix Error: Number of Input data is not suitable for Matrix dimensions. Needed \(needed), got \(got)"
        case .notInvertable: return "Matrix Error: Input is not invertable"
        case .notSquarish: return "Matrix Error: Number of rows and columns need to be equal."
        case .wrongDimensions(let needed, let got): return "Matrix Error: Input has wrong dimensions. Needed \(needed), got \(got)"
        
        case .unimplemented(let method): return "Matrix Error: Method unimplemented \(method)"
        
        }
    }
}
