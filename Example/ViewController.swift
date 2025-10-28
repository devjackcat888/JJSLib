//
//  ViewController.swift
//  Example
//
//  Created by SharkAnimation on 2023/5/14.
//

import UIKit
import JJSLib
//import WCDBSwift
import AVFoundation

//final class Sample: TableCodable {
//    var identifier: Int? = nil
//    var description: String? = nil
//    var offset: Int = 0
//    var username: String = "啦啦啦"
//    var debugDescription: String? = nil
//        
//    enum CodingKeys: String, CodingTableKey {
//        typealias Root = Sample
//        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
//            BindColumnConstraint(identifier, isPrimary: true)
//        }
//        case identifier = "id"
//        case description
//        case offset = "db_offset"
//        case username = "username2"
//    }
//    
//    var isAutoIncrement: Bool = false // 用于定义是否使用自增的方式插入
//    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值
//}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.jjs_setBackgroundColor(.white)
        
        UIButton()
            .jjs_setTitle("Test")
            .jjs_setTitleColor(.black)
            .jjs_setBackgroundColor(.random)
            .jjs_enlargeEdge(10, 10, 10, 10)
            .jjs_layout(superView: view) { make in
                make.center.equalToSuperview()
            }
            .jjs_clickBlock { [weak self] in
                self?.videoAniTest()
//                Test.test()
            }
    }
    
    func test() {
//        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
//            return
//        }
//        print("---path = \(path)")
//        let databasePath = "\(path)/sample.db"
//
//        let database = Database(at: URL(fileURLWithPath: databasePath))
//        try? database.create(table: "Sample", of: Sample.self)
        
        UIAlertController(title: "友情提示".jjs_localizable(), message: "确认删除所选作品吗？", style: .alert, cancelTitle: "取消".jjs_localizable(), confirmTitle: "确认".jjs_localizable(), confirmAction: { sender in
            
        }).show()
    }
    
}

extension ViewController {
    func videoAniTest() {
        
        // 添加视频和音频轨道的内容，这里只是示例，您需要替换为实际的视频和音频资源
        let path = Bundle.main.url(forResource: "target.mp4", withExtension: nil)!
        let videoAsset = AVURLAsset(url: path)
        
        let videoTrack = videoAsset.tracks(withMediaType: .video).first!
        
        let videoSize = videoTrack.naturalSize
        
        // 创建AVMutableVideoComposition
        let videoComposition = AVMutableVideoComposition(propertiesOf: videoAsset)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30) // 帧速率
        videoComposition.renderSize = videoSize // 视频尺寸
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(origin: .zero, size: CGSize(width: videoSize.width, height: videoSize.height))
        
        let videoLayer = CALayer()
        videoLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(videoLayer)
        
        // 创建Core Animation 图层
        let animationLayer = CALayer()
        animationLayer.allowsEdgeAntialiasing = true
        animationLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(animationLayer)

        let textAniLayer = CALayer()
        textAniLayer.backgroundColor = UIColor.red.cgColor
        textAniLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let basicAnimation = CAKeyframeAnimation(keyPath: "opacity")
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fillMode = .both
        basicAnimation.autoreverses = false
        basicAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
        basicAnimation.duration = 3
        basicAnimation.values = [0,0.25,0.5,0.75,1]
        basicAnimation.keyTimes = [0,0.25,0.5,0.75,1]
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.calculationMode = .discrete
        textAniLayer.add(basicAnimation, forKey: "ani")

        let textAniLayer2 = CALayer()
        textAniLayer2.backgroundColor = UIColor.red.cgColor
        textAniLayer2.frame = CGRect(x: 200, y: 0, width: 100, height: 100)
        
        animationLayer.addSublayer(textAniLayer)
        animationLayer.addSublayer(textAniLayer2)

        if animationLayer.contentsAreFlipped() {
            animationLayer.isGeometryFlipped = true
        }
    
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        // 创建AVAssetExportSession来导出合成的视频
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = URL(fileURLWithPath: "\(docPath)/output_video.mp4")
        exportSession?.videoComposition = videoComposition
        
        // 开始导出
        exportSession?.exportAsynchronously {
            if let error = exportSession?.error {
                print("Export failed with error: \(error)")
            } else {
                print("Export successful")
            }
        }
        
    }
}

