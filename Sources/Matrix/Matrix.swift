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
    
    // MARK: - Init + Data
    
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        self.setIdentity()
    }
    
    public init(rows: Int, columns: Int, data: [Double]) {
        self.rows = rows
        self.columns = columns
        setData(data)
    }
    
    public func setData(_ args: [Double]) {
        guard args.count == rows * columns else { return }
        
        for row in 0..<rows {
            for column in 0..<columns {
                let value = args[row*columns + column]
                updateValue(row: row, column: column, value: value)
            }
        }
    }
    
    public func setData(_ args: [Float]) {
        let doubleValues = args.compactMap { Double($0) }
        self.setData(doubleValues)
    }
    
    
    public func setData(args: Double...) {
        setData(args)
    }
    public func setData(args: Float...) {
        setData(args)
    }
    
    
    public func setIdentity() {
        guard rows == columns else { return }
        
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
    
    static public func +(left: Matrix, right: Matrix) -> Matrix {
        let resultMatrix = Matrix(rows: left.rows, columns: left.columns)

        for row in 0..<left.rows {
            for column in 0..<left.columns {
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
    
    
    public static func *(left: Matrix, right: Matrix) -> Matrix {
        guard left.columns == right.rows else { fatalError() }

        let resultMatrix = Matrix(rows: left.rows, columns: right.columns)

        let rows = resultMatrix.rows
        let columns = resultMatrix.columns

        for row in 0..<rows {
            for column in 0..<columns {
                resultMatrix.updateValue(row: row, column: column, value: 0)

                for rowColumn in 0..<left.columns {
                    let value = resultMatrix.data[row][column] + left.data[row][rowColumn] * right.data[rowColumn][column]
                    resultMatrix.updateValue(row: row, column: column, value: value)
                }
            }
        }
        return resultMatrix
    }
    
    
    public static func *(matrix: Matrix, vector: Vector) -> Vector {
        guard matrix.columns == vector.rows else { fatalError() }
        
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
    
    
    public func multiplyByTranspose(with secondMatrix: Matrix) -> Matrix {
        guard self.columns == secondMatrix.columns else { fatalError() }
        
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
        
        for row in 0..<left.rows {
            for column in 0..<left.columns {
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
    
    
    public func swapRows(_ row1: Int, _ row2: Int) {
        guard row1 != row2 else { return }
        let tmp = data[row1]
        data[row1] = data[row2]
        data[row2] = tmp
    }
    
    
    public func scaleRow(_ row: Int, scalar: Double) {
        guard row < rows else { return }
        
        for column in 0..<columns {
            updateValue(row: row, column: column, value: data[row][column] * scalar)
        }
    }
    
    
    public func shearRow(_ row1: Int, _ row2: Int, scalar: Double) {
        guard row1 != row2,
              row1 < rows && row2 < rows else { return }
        
        for column in 0..<columns {
            updateValue(row: row1, column: column, value: data[row1][column] + data[row2][column] * scalar)
        }
    }
    
    
    
    public func destructiveInvert() -> Matrix? {
        guard self.columns == self.rows else {
            return nil
        }
        
        let outputMatrix = Matrix(rows: columns, columns: rows)
        
        outputMatrix.setIdentity()
        
        var scalar: Double = 0
        
        for row in 0..<self.rows {
            if self.data[row][row] == 0 { // we have to swap rows here to make nonzero diagonal
                for inputRow in row..<self.rows where self.data[inputRow][inputRow] != 0.0 {
                    break
                }
                
                // if (ri == mtxin.rows) { return false } // can't get inverse matrix -> should never happen I guess?
                
                // swapRows(r, ri)
                self.swapRows(row, self.rows-1)
                outputMatrix.swapRows(row, self.rows-1)
            }
            
            scalar = 1 / self.data[row][row]
            self.scaleRow(row, scalar: scalar)
            outputMatrix.scaleRow(row, scalar: scalar)
            
            // shearing for rows but currentRow in loop
            // in original code this is split to two loops but I think this is not necessary
            for shearingRow in 0..<self.rows where shearingRow != row {
                scalar = -self.data[shearingRow][row]
                self.shearRow(shearingRow, row, scalar: scalar)
                outputMatrix.shearRow(shearingRow, row, scalar: scalar)
            }
        }
        
        return outputMatrix
    }
}
