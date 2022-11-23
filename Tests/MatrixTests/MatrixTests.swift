//
//  MatrixTestClassTests.swift
//  MatrixTestClassTests
//
//  Created by Anna Münster on 03.05.22.
//

import XCTest
@testable import Matrix

final class MatrixTests: XCTestCase {
    let matrixA: Matrix = {
        let matrix = Matrix(rows: 3, columns: 3)
        matrix.data = [
            [1,2,3],
            [4,5,6],
            [7,8,9]
        ]
        return matrix
    }()
    
    let matrixB: Matrix = {
        let matrix = Matrix(rows: 3, columns: 3)
        matrix.data = [
            [9,8,7],
            [12,11,10],
            [15,14,13]
        ]
        return matrix
    }()
    
    func testSetData() throws {
        let myMatrix = Matrix(rows: 3, columns: 3)
        try myMatrix.setData(args: 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
        
        let data: [[Double]] = [
            [1,2,3],
            [4,5,6],
            [7,8,9]
        ]
        
        XCTAssertTrue(myMatrix.data == data)
    }
    
    func testSetIdentiy() throws {
        let myMatrix = Matrix(rows: 3, columns: 3)
        try myMatrix.setIdentity()
        
        let data: [[Double]] = [
            [1,0,0],
            [0,1,0],
            [0,0,1]
        ]
        
        XCTAssertTrue(myMatrix.data == data)
    }
    
    func testMatrixAddition() throws {
        XCTAssertTrue(
            
            (try matrixA + matrixA).data
            ==
            [
                [2,4,6],
                [8,10,12],
                [14,16,18]
            ]
        )
        
        XCTAssertTrue(
            (try matrixA + matrixB).data
            ==
            [
                [10,10,10],
                [16,16,16],
                [22,22,22]
            ]
        )
    }
    
    func testMatrixMultiplication() throws {
        XCTAssertTrue(
            (try matrixA * matrixA).data ==
            [
                [30,36,42],
                [66,81,96],
                [102,126,150]
            ]
        )
        
        XCTAssertTrue(
            (try matrixA * matrixB).data
            ==
            [
                [78,72,66],
                [186,171,156],
                [294,270,246]
            ]
        )
        
        
    }
    
    func testMatrixIdentiySubtraction() throws {
        let result = matrixA
        result.subtractFromIdentity()
        
        let data: [[Double]] = [
            [0,-2,-3],
            [-4,-4,-6],
            [-7,-8,-8]
        ]
        
        XCTAssertTrue(result.data == data)
    }
    
    func testMatrixMultiplicationTranspose() throws {
        
        XCTAssertTrue(
            try matrixA.multiplyByTranspose(with: matrixA).data
            ==
            [
                [14,32,50],
                [32,77,122],
                [50,122,194]
            ]
        )
        
        XCTAssertTrue(
            try matrixA.multiplyByTranspose(with: matrixB).data
            ==
            [
                [46,64,82],
                [118,163,208],
                [190,262,334]
            ]
        )
        
    }
    
    func testMatrixEq() throws {
        XCTAssertTrue(matrixA == matrixA)
        
        XCTAssertFalse(matrixA == matrixB)
        
        XCTAssertTrue(matrixB == matrixB)
    }
    
    func testMatrixScale() throws {
        let matrixA = matrixA
        matrixA.scale(2)
        XCTAssertTrue(
            matrixA.data
            ==
            [
                [2,4,6],
                [8,10,12],
                [14,16,18]
            ]
        )
        XCTAssertTrue(
            (matrixA * 5).data
            ==
            [
                [10,20,30],
                [40,50,60],
                [70,80,90]
            ]
        )
    }
    
    func testMatrixSwapRows() throws {
        let matrixA = matrixA
        try matrixA.swapRows(0, 2)
        XCTAssertTrue(
            matrixA.data
            ==
            [
                [7,8,9],
                [4,5,6],
                [1,2,3]
            ]
        )
        
        try matrixA.swapRows(0, 2)
        XCTAssertTrue(matrixA.data == self.matrixA.data)
    }
    
    func testMatrixScaleRows() throws {
        let matrixA = matrixA
        matrixA.scaleRow(0, scalar: 10)
        XCTAssertTrue(
            matrixA.data
            ==
            [
                [10,20,30],
                [4,5,6],
                [7,8,9]
            ]
        )
    }
    
    func testMatrixShearRows() throws {
        let matrixA = matrixA
        try matrixA.shearRow(0, 1, scalar: 10)
        
        XCTAssertTrue(matrixA.data ==
        [
            [41,52,63],
            [4,5,6],
            [7,8,9]
        ]
        )
    }
    
    func testDestructiveInvert() throws {
        let matrixWithDeterminante: Matrix = {
            let matrix = Matrix(rows: 3, columns: 3)
            matrix.data = [
                [3,1,0],
                [-1,3,-1],
                [0,-3,1]
            ]
            return matrix
        }()
        
        let result = try matrixWithDeterminante.destructiveInvert()
        result.round()
        
        
        XCTAssertTrue(result.data ==
                      [
                        [0,-1,-1],
                        [1,3,3],
                        [3,9,10]
                      ]
        )
    }
}
