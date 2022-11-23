# Matrix Calculation Package

This repository contains some basic mathematical implementations for matrix math wrapped in a Swift Package.

It is made by **[HYPERLINK Group](https://www.hyperlink.eu)**! We make great software with ♥️ in Berlin.

---

## Content
- [Features](#features)
- [Installation](#installation)
- [How to Use](#how-to-use)


## Features
- [x] Comparison
- [x] Addition
- [x] Subtraction
- [x] Multiplication
- [ ] Division
- [ ] Power
- [ ] Square Root
- [x] Scaling
- [x] Rounding
- [x] Shearing
- [x] Multiplication with Destructive Inverse
- [x] Multiplication with Transpose
- [x] Error Handling

---

## Installation
##### Requirements
- iOS 14.0+ / macOS 10.14+
- Xcode 13+
- Swift 5+

##### Swift Package Manager
In Xcode, go to `File > Add Packages` and add `https://github.com/hyperlinkgroup/swift-matrix`. Add the package to all your targets.


## How to Use
```Swift
import Matrix

let A = Matrix(rows: 3, columns: 2,
               data: [1, 2.5,
                      3, 4.5,
                      5, 6]) // A.data = [[1.0, 2.5], [3.0, 4.5], [5.0, 6.0]]
        
let B = Matrix(rows: 2, columns: 2) // B.data = [[1, 0], [0, 1]]
try B.setData([1.0]) // throws MatrixError.wrongDimension -> Needed 4, got 1
try B.setData([7.0, 8,
                9, 10]) // B.data = [[7.0, 8.0], [9.0, 10.0]]
        
let v = Vector(rows: 3)
try v.setData(args: 1, 2, 3.0) // v.data = [[1.0], [2.0]. [3.0]]
        
let AxB = try? A * B // AxB.data = [[29.0,33.0], [61.5, 69.0], [89.0, 100.0]]
```
