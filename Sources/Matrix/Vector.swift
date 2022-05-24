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
    
    public static func +(left: Vector, right: Vector) -> Vector {
        guard left.rows == right.rows else { fatalError() }
        
        let resultVector = Vector(rows: left.rows)
        
        for row in 0..<left.rows {
            for column in 0..<left.columns {
                let sum = left.data[row][column] + right.data[row][column]
                resultVector.updateValue(row: row, column: column, value: sum)
            }
        }
        return resultVector
    }
    
    public static func -(left: Vector, right: Vector) -> Vector {
        guard left.rows == right.rows else { fatalError() }
        
        let resultVector = Vector(rows: left.rows)
        
        for row in 0..<left.rows {
            for column in 0..<left.columns {
                let sum = left.data[row][column] - right.data[row][column]
                resultVector.updateValue(row: row, column: column, value: sum)
            }
        }
        
        return resultVector
    }
    
    public func copy() -> Vector {
        let destinationVector = Vector(rows: rows)
        
        for row in 0..<self.rows {
            for column in 0..<self.columns {
                destinationVector.updateValue(row: row, column: column, value: self.data[row][column])
            }
        }
        return destinationVector
    }
}
