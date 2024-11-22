//
//  CGPoint+Extension.swift
//  App
//
//  Created by Gaorui Hou on 2024/9/11.
//

import UIKit

public extension CGPoint {
    /// pointer是否在points组成的矩形框内
    func InPointsRect(points: [CGPoint]?) -> Bool {
        guard let points else {
            return false
        }
        if points.count < 4 {
            return false
        }
        var minX = points[0].x
        var maxX = points[0].x
        var minY = points[0].y
        var maxY = points[0].y
        for point in points {
            minX = min(minX, point.x)
            maxX = max(maxX, point.x)
            minY = min(minY, point.y)
            maxY = max(maxY, point.y)
        }
        if self.x > minX, self.x < maxX,
           self.y > minY, self.y < maxY {
            return true
        }
        return false
    }
}
