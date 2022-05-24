//
//  Matrix.swift
//  Quartermile
//
//  Created by Anna Münster on 24.11.21.
//

import Foundation

open class Matrix {
    public let rows: Int
    public let columns: Int
    public var data = [[Double]]() // multidimensional array with the size of given rows and columns -> fixed array sizes are not yet supported in Swift
    
    lazy var rowRange = 0..<rows
    lazy var columnRange = 0..<columns
    
    // MARK: - Init + Data
    
    public init(rows: Int, columns: Int, data: [Double]? = nil) {
        self.rows = rows
        self.columns = columns
        
        
        do {
            if let data = data {
                try setData(data)
            } else {
                // if matrix is quadratic, we set the identity matrix, otherwise it is filled with zeros
                try setIdentity()
            }
        } catch {
            for row in 0..<rows {
                for column in 0..<columns {
                    self.updateValue(row: row, column: column, value: 0)
                }
            }
        }
        
    }
    
    public func setData(_ args: [Double]) throws {
        guard args.count == rows * columns else { throw MatrixError.wrongDimensions }
        
        for row in 0..<rows {
            for column in 0..<columns {
                let value = args[row*columns + column]
                updateValue(row: row, column: column, value: value)
            }
        }
    }
    
    public func setData(_ args: [Float]) throws {
        let doubleValues = args.compactMap { Double($0) }
        try self.setData(doubleValues)
    }
    
    
    public func setData(args: Double...) throws {
        try setData(args)
    }
    public func setData(args: Float...) throws {
        try setData(args)
    }
    
    
    public func setIdentity() throws {
        guard rows == columns else { throw MatrixError.wrongDimensions }
        
        for row in 0..<rows {
            for column in 0..<columns {
                updateValue(row: row, column: column, value: 0)
            }
            updateValue(row: row, column: row, value: 1)
        }
    }
    
    public func round() {
        for row in 0..<rows {
            for column in 0..<columns {
                updateValue(row: row, column: column, value: data[row][column].rounded())
            }
        }
    }
    
    func updateValue(row: Int, column: Int, value: Double) {
        guard rowRange.contains(row),
              columnRange.contains(column) else {
                  // we don't need to throw an error here, nothing happens
                  return
              }
        
        var newRow = [Double]()
        if row < data.count {
            newRow = data[row]
            if column+1 <= newRow.count {
                newRow[column] = value
            } else if column < newRow.count {
                var columnCount = newRow.count
                while columnCount < column {
                    newRow.append(0)
                    columnCount += 1
                }
                newRow.append(value)
            } else {
                newRow.append(value)
            }
        } else {
            var columnCount = newRow.count
            while columnCount < column {
                newRow.append(0)
                columnCount += 1
            }
            newRow.append(value)
        }
        
        if data.count <= row {
            var rowCount = data.count
            while rowCount <= row {
                data.append([])
                rowCount += 1
            }
        }
        
        data[row] = newRow
    }
    
    // MARK: - Functions
    
    static public func +(left: Matrix, right: Matrix) throws -> Matrix {
        guard
            left.rows == right.rows,
            left.columns == right.columns else {
            throw MatrixError.wrongDimensions
        }
        
        let resultMatrix = Matrix(rows: left.rows, columns: left.columns)
        
        for row in left.rowRange {
            for column in left.columnRange{
                let sum = left.data[row][column] + right.data[row][column]
                resultMatrix.updateValue(row: row, column: column, value: sum)
            }
        }
        return resultMatrix
    }
    
    /// identityMatrix - self
    public func subtractFromIdentity() {
        for row in 0..<rows {
            for columnA in 0..<row {
                updateValue(row: row, column: columnA, value: -data[row][columnA])
            }
            updateValue(row: row, column: row, value: 1 - data[row][row])
            for columnB in row+1..<columns {
                updateValue(row: row, column: columnB, value: -data[row][columnB])
            }
        }
    }
    
    
    public static func *(left: Matrix, right: Matrix) throws -> Matrix {
        guard left.columns == right.rows else { throw MatrixError.wrongDimensions }
        
        let resultMatrix = Matrix(rows: left.rows, columns: right.columns)
        
        let rows = resultMatrix.rows
        let columns = resultMatrix.columns
        
        for row in 0..<rows {
            for column in 0..<columns {
                resultMatrix.updateValue(row: row, column: column, value: 0)
                
                for rowColumn in left.columnRange{
                    let value = resultMatrix.data[row][column] + left.data[row][rowColumn] * right.data[rowColumn][column]
                    resultMatrix.updateValue(row: row, column: column, value: value)
                }
            }
        }
        return resultMatrix
    }
    
    
    public static func *(matrix: Matrix, vector: Vector) throws -> Vector {
        guard matrix.columns == vector.rows else { throw MatrixError.wrongDimensions }
        
        let resultVector = Vector(rows: matrix.rows)
        
        let rows = resultVector.rows
        let columns = resultVector.columns
        
        for row in 0..<rows {
            for column in 0..<columns {
                resultVector.updateValue(row: row, column: column, value: 0)
                
                for rowColumn in 0..<matrix.columns {
                    let value = resultVector.data[row][column] + matrix.data[row][rowColumn] * vector.data[rowColumn][column]
                    resultVector.updateValue(row: row, column: column, value: value)
                }
            }
        }
        return resultVector
    }
    
    
    public func multiplyByTranspose(with secondMatrix: Matrix) throws -> Matrix {
        guard self.columns == secondMatrix.columns else { throw MatrixError.wrongDimensions }
        
        let resultMatrix = Matrix(rows: self.rows, columns: secondMatrix.rows)
        
        for row in 0..<resultMatrix.rows {
            for column in 0..<resultMatrix.columns {
                resultMatrix.updateValue(row: row, column: column, value: 0)
                
                for rowColumn in 0..<self.columns {
                    let value = resultMatrix.data[row][column] + self.data[row][rowColumn] * secondMatrix.data[column][rowColumn]
                    resultMatrix.updateValue(row: row, column: column, value: value)
                }
            }
        }
        
        return resultMatrix
    }
    
    
    public static func ==(left: Matrix, right: Matrix) -> Bool {
        if left.rows != right.rows || left.columns != right.columns {
            return false
        }
        
        for row in left.rowRange {
            for column in left.columnRange {
                if left.data[row][column] - right.data[row][column] == 0 {
                    continue
                }
                return false
            }
        }
        return true
    }
    
    
    public func scale(_ scalar: Double) {
        for row in 0..<rows {
            for column in 0..<columns {
                updateValue(row: row, column: column, value: data[row][column] * scalar)
            }
        }
    }
    
    public static func *(matrix: Matrix, scalar: Double) -> Matrix {
        let resultMatrix = matrix
        resultMatrix.scale(scalar)
        return resultMatrix
    }
    
    
    public func swapRows(_ row1: Int, _ row2: Int) throws {
        guard row1 != row2 else { return }
        
        guard rowRange.contains(row1),
              rowRange.contains(row2) else {
                  throw MatrixError.wrongDimensions
              }
        
        let tmp = data[row1]
        data[row1] = data[row2]
        data[row2] = tmp
    }
    
    
    public func scaleRow(_ row: Int, scalar: Double) {
        guard row < rows,
              rowRange.contains(row) else { return }
        
        for column in 0..<columns {
            updateValue(row: row, column: column, value: data[row][column] * scalar)
        }
    }
    
    
    public func shearRow(_ row1: Int, _ row2: Int, scalar: Double) throws {
        guard row1 != row2 else { return }
        
        guard rowRange.contains(row1),
              rowRange.contains(row2) else {
                  throw MatrixError.wrongDimensions
              }
        
        for column in 0..<columns {
            updateValue(row: row1, column: column, value: data[row1][column] + data[row2][column] * scalar)
        }
    }
    
    
    
    public func destructiveInvert() throws -> Matrix {
        guard self.columns == self.rows else { throw MatrixError.wrongDimensions }
        
        let outputMatrix = Matrix(rows: columns, columns: rows)
        
        var scalar: Double = 0
        
        for row in rowRange {
            if self.data[row][row] == 0 { // we have to swap rows here to make nonzero diagonal
                for inputRow in row..<self.rows where self.data[inputRow][inputRow] != 0.0 {
                    break
                }
                
                // if (ri == mtxin.rows) { return false } // can't get inverse matrix -> should never happen I guess?
                
                // swapRows(r, ri)
                try self.swapRows(row, self.rows-1)
                try outputMatrix.swapRows(row, self.rows-1)
            }
            
            let value = self.data[row][row]
            guard value != 0 else {
                throw MatrixError.notInvertable
            }
            
            scalar = 1 / value
            self.scaleRow(row, scalar: scalar)
            outputMatrix.scaleRow(row, scalar: scalar)
            
            // shearing for rows but currentRow in loop
            // in original code this is split to two loops but I think this is not necessary
            for shearingRow in rowRange where shearingRow != row {
                scalar = -self.data[shearingRow][row]
                try self.shearRow(shearingRow, row, scalar: scalar)
                try outputMatrix.shearRow(shearingRow, row, scalar: scalar)
            }
        }
        
        return outputMatrix
    }
}
