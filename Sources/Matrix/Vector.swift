//
//  Vector.swift
//  
//
//  Created by Anna Münster on 24.05.22.
//

import Foundation

open class Vector: Matrix {
    public init(rows: Int) {
        super.init(rows: rows, columns: 1)
    }
    
    public static func +(left: Vector, right: Vector) throws -> Vector {
        guard left.rows == right.rows else { throw MatrixError.wrongDimensions }
        
        let resultVector = Vector(rows: left.rows)
        
        for row in left.rowRange {
            let sum = left.data[row][0] + right.data[row][0]
            resultVector.updateValue(row: row, column: 0, value: sum)
        }
        return resultVector
    }
    
    public static func -(left: Vector, right: Vector) throws -> Vector {
        guard left.rows == right.rows else { throw MatrixError.wrongDimensions }
        
        let resultVector = Vector(rows: left.rows)
        
        for row in left.rowRange {
            let sum = left.data[row][0] - right.data[row][0]
            resultVector.updateValue(row: row, column: 0, value: sum)
        }
        
        return resultVector
    }
    
    public func copy() -> Vector {
        let destinationVector = Vector(rows: self.rows)
        
        for row in self.rowRange {
            destinationVector.updateValue(row: row, column: 0, value: self.data[row][0])
        }
        return destinationVector
    }
}
