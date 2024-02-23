//
//  ContentView.swift
//  ShortPath
//
//  Created by Sandhya on 2/23/24.
//


import SwiftUI

// SwiftUI View for the user interface
struct ContentView: View {
    @State private var inputText: String = ""
    @State private var result: String = ""

    var body: some View {
        VStack {
            Text("Enter grid rows:")
            TextField("e.g., 1 2 3 4 5", text: $inputText)
                .padding()
            
            Button("Calculate Path") {
                calculatePath()
            }
            .padding()
            
            Text(result)
                .padding()
        }
        .padding()
    }

    // Function triggered when the "Calculate Path" button is tapped
    func calculatePath() {
        // Split input text into rows
        let rows = inputText.components(separatedBy: "\n")
        var matrix = [[Int]]()

        // Convert input rows into a matrix of integers
        for row in rows {
            let values = row.components(separatedBy: " ").compactMap { Int($0) }
            matrix.append(values)
        }

        // Call the function to find and format the path
        if let pathResult = findPath(matrix: matrix) {
            result = pathResult
        } else {
            result = "Invalid input"
        }
    }

    // Function to find the path of least cost through the given matrix
    func findPath(matrix: [[Int]]) -> String? {
        let numberOfRows = matrix.count
        let numberOfColumns = matrix.first?.count ?? 0

        // Initialize a matrix to store cumulative costs
        var dp = Array(repeating: Array(repeating: 0, count: numberOfColumns), count: numberOfRows)

        // Initialize the first column with the same values as the input matrix
        for i in 0..<numberOfRows {
            dp[i][0] = matrix[i][0]
        }

        // Calculate cumulative costs
        for j in 1..<numberOfColumns {
            for i in 0..<numberOfRows {
                let left = dp[i][j - 1]
                let up = dp[(i - 1 + numberOfRows) % numberOfRows][j - 1]
                let down = dp[(i + 1) % numberOfRows][j - 1]

                // Calculate the cumulative cost for each cell
                dp[i][j] = matrix[i][j] + min(left, min(up, down))
            }
        }

        // Find the minimum cost path
        var minCost = Int.max
        var minCostRow = -1

        for i in 0..<numberOfRows {
            if dp[i][numberOfColumns - 1] < minCost {
                minCost = dp[i][numberOfColumns - 1]
                minCostRow = i
            }
        }

        // Reconstruct the path
        var path = [minCostRow]
        var totalCost = minCost

        for j in (1..<numberOfColumns).reversed() {
            let left = dp[minCostRow][j - 1]
            let up = dp[(minCostRow - 1 + numberOfRows) % numberOfRows][j - 1]
            let down = dp[(minCostRow + 1) % numberOfRows][j - 1]

            let minCostValue = min(left, min(up, down))

            // Determine the direction of the minimum cost and update the path
            if minCostValue == left {
                path.append(minCostRow)
            } else if minCostValue == up {
                minCostRow = (minCostRow - 1 + numberOfRows) % numberOfRows
                path.append(minCostRow)
            } else if minCostValue == down {
                minCostRow = (minCostRow + 1) % numberOfRows
                path.append(minCostRow)
            }
        }

        path.reverse()

        // Format the result string
        return formatResult(totalCost, path)
    }

    // Function to format the result string
    func formatResult(_ totalCost: Int, _ path: [Int]) -> String {
        let pathString = path.map { String($0 + 1) }.joined(separator: " ")
        return """
            Yes
            \(totalCost)
            \(pathString)
            """
    }
}

// Preview for SwiftUI view
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
