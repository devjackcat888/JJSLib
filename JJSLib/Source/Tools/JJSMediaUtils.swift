//
//  VideoCompress.swift
//  UUUU
//
//  Created by SharkAnimation on 2023/5/19.
//

import UIKit
import AVFoundation

open class JJSMediaUtils {
    
    /// 合成格式
    public enum CompositeMediaFormat {
        case mp4
        case m4a
    }
    
    /// 裁剪区域
    public struct ClipRange {
        var startTime: TimeInterval
        var endTime: TimeInterval
        public init(startTime: TimeInterval, endTime: TimeInterval) {
            self.startTime = startTime
            self.endTime = endTime
        }
    }
    
    /// 将N个图片和N个音视频文件合成为一个视频
    public class func compositeVideo(images: [UIImage], assets: [URL], videoSize: CGSize, videoDuration: TimeInterval = 0, fps: Int = 30, complete:@escaping ((_ success: Bool, _ videoPath: String?) -> Void)) {
        
        // 没数据
        if images.count == 0, assets.count == 0 {
            complete(false, nil)
            return
        }
        
        // 合成的视频时长
        var resultDuration = videoDuration
        if resultDuration == 0 {
            for url in assets {
                let asset = AVURLAsset(url: url)
                resultDuration = max(resultDuration, CMTimeGetSeconds(asset.duration))
            }
        }
        
        if images.count > 0 {
            // 先将图片合成视频
            compositeVideo(images: images, videoSize: videoSize, videoDuration: resultDuration) { success, tempVideoPath in
                if success, let tempVideoPath {
                    let videoAssetUrl = URL(fileURLWithPath: tempVideoPath)
                    let urls = assets + [videoAssetUrl]
                    compositeMedia(assets: urls) { success, videoPath in
                        // 合成之后将临时视频删除
                        try? FileManager.default.removeItem(atPath: tempVideoPath)
                        if success, let videoPath {
                            complete(true, videoPath)
                        } else {
                            complete(false, nil)
                        }
                    }
                } else {
                    complete(false, nil)
                }
            }
        } else {
            compositeMedia(assets: assets) { success, videoPath in
                if success, let videoPath {
                    complete(true, videoPath)
                } else {
                    complete(false, nil)
                }
            }
        }
    }
    
    /// 图片合成视频
    public class func compositeVideo(images: [UIImage], videoSize: CGSize, videoDuration: TimeInterval, fps: Int = 30, complete:@escaping ((_ success: Bool,_ videoPath: String?) -> Void)) {
        
        // 设置 mov 路径
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            complete(false, nil)
            return
        }
        
        let videoPath = (documentPath as NSString).appendingPathComponent("target.mp4")
        // 先删除已有文件
        if FileManager.default.fileExists(atPath: videoPath) {
            try? FileManager.default.removeItem(atPath: videoPath)
        }
        
        // 转成 UTF-8 编码
        unlink((videoPath as NSString).utf8String)
        
        // AVAssetWriter 类可以将图像和音频写成一个完整的视频文件
        guard let videoWriter = try? AVAssetWriter(url: URL(fileURLWithPath: videoPath), fileType: .mp4) else {
            complete(false, nil)
            return
        }
        videoWriter.movieFragmentInterval = CMTimeMakeWithSeconds(1.0, preferredTimescale: 1000);
        // mov 格式的设置：编码格式、宽度、高度
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoSize.width,
            AVVideoHeightKey: videoSize.height,
//            AVVideoCompressionPropertiesKey: [
//                AVVideoExpectedSourceFrameRateKey: fps,
//            ]
        ]
        
        // AVAssetWriterInput
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        writerInput.expectsMediaDataInRealTime = true
//        writerInput.mediaTimeScale = fps
        let sourcePixelBufferAttributesDictionary: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB
        ]
        
        // BufferAdaptor
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        
        guard videoWriter.canAdd(writerInput) else {
            complete(false, nil)
            return
        }
        
        videoWriter.add(writerInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        // 合成多张图片为一个视频文件
        let dispatchQueue = DispatchQueue(label: "mediaInputQueue")
        var frame = 0
        // 总视频帧数
        let frameCount = Int(videoDuration * TimeInterval(fps))
        
        writerInput.requestMediaDataWhenReady(on: dispatchQueue) {
            while writerInput.isReadyForMoreMediaData {
                if frame >= frameCount {
                    writerInput.markAsFinished()
                    videoWriter.finishWriting {
                        complete(true, videoPath)
                    }
                    break
                }
                
                var buffer: CVPixelBuffer? = nil
                let idx = frame / (frameCount / images.count)
                if idx < images.count {
                    buffer = pixelBufferFromImage(image: images[idx])
                    if let buffer = buffer {
                        let presentationTime = CMTimeMake(value: Int64(CGFloat(frame * 1000) / CGFloat(fps)), timescale: 1000);
                        if adaptor.append(buffer, withPresentationTime: presentationTime) {
//                            print("insert buffer success \(presentationTime.value)")
                        } else {
                            print("insert buffer failure")
                        }
                    }
                }
                
                frame += 1
            }
        }
    }
    
    /// 将若干个音视频文件合称为一个视频
    public class func compositeMedia(assets:[URL], isConcat: Bool = false, format: CompositeMediaFormat = .mp4, complete:@escaping ((_ success: Bool,_ mediaPath: String?) -> Void)){
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            complete(false, nil)
            return
        }
        
        // 创建组合对象
        let composition = self.makeComposition(assets: assets, isConcat: isConcat)
    
        let distPath = documentPath + "/dist." + (format == .mp4 ? "mp4" : "m4a")
        if FileManager.default.fileExists(atPath: distPath) {
            try? FileManager.default.removeItem(atPath: distPath)
        }

        // 执行合并轨道对象会话
        var presetName = ""
        if format == .mp4 {
            presetName = AVAssetExportPresetHighestQuality
        } else {
            presetName = AVAssetExportPresetAppleM4A
        }
        if let exportSession = AVAssetExportSession(asset: composition, presetName: presetName) {
            exportSession.outputURL = URL(fileURLWithPath: distPath)
            if format == .mp4 {
                exportSession.outputFileType = .mp4
            } else {
                exportSession.outputFileType = .m4a
            }
            exportSession.exportAsynchronously {
                if exportSession.status == .completed {
                    complete(true, distPath)
                } else {
                    complete(false, nil)
                }
            }
        } else {
            complete(false, nil)
        }
    }
    
    public class func makePlayerItem(assets: [URL], isConcat: Bool) -> AVPlayerItem {
        let composition = self.makeComposition(assets: assets, isConcat: isConcat)
        let playerItem = AVPlayerItem.init(asset: composition)
        return playerItem
    }
    
    class func makeComposition(assets: [URL], isConcat: Bool) -> AVMutableComposition {
        let composition = AVMutableComposition()
        var start: CMTime = .zero
        for url in assets {
            let asset = AVURLAsset(url: url)
            let timeRange = CMTimeRangeMake(start: .zero, duration: asset.duration)
            
            if let track = asset.tracks(withMediaType: .audio).first {
                let audioComTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                try? audioComTrack?.insertTimeRange(timeRange, of: track, at: start)
            }
            if let track = asset.tracks(withMediaType: .video).first {
                let videoComTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                try? videoComTrack?.insertTimeRange(timeRange, of: track, at: start)
            }
            if isConcat {
                // 按顺序拼接
                start = CMTimeAdd(start, asset.duration)
            }
        }
        return composition
    }
    
    /// 音视频裁剪
    public class func clipAudio(audioUrl: URL, clipRange: ClipRange, complete:@escaping ((_ success: Bool,_ mediaPath: String?) -> Void)) {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            complete(false, nil)
            return
        }
        
        let asset = AVURLAsset(url: audioUrl)
        
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
            // 没有音频轨道
            complete(false,nil)
            return
        }
        
        let assetTime = asset.duration
        
        // 开始与结束时间
        let inPoint = CMTimeMake(value: Int64(clipRange.startTime * TimeInterval(assetTime.timescale)), timescale: assetTime.timescale)
        var endPoint = CMTimeMake(value: Int64(clipRange.endTime * TimeInterval(assetTime.timescale)), timescale: assetTime.timescale)
        if endPoint.value > assetTime.value {
            endPoint = assetTime
        }
    
        // 创建组合对象
        let composition = AVMutableComposition()
        let newAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? newAudioTrack?.insertTimeRange(CMTimeRangeMake(start: inPoint, duration: CMTimeSubtract(endPoint, inPoint)), of: audioTrack, at: .zero)
        
        let distPath = documentPath + "/dist.wav"
        if FileManager.default.fileExists(atPath: distPath) {
            try? FileManager.default.removeItem(atPath: distPath)
        }

        // 执行合并轨道对象会话
        if let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) {
            exportSession.outputURL = URL(fileURLWithPath: distPath)
            exportSession.outputFileType = .m4a
            
            exportSession.exportAsynchronously {
                if exportSession.status == .completed {
                    DispatchQueue.main.async {
                        complete(true, distPath)
                    }
                } else {
                    DispatchQueue.main.async {
                        complete(false, nil)
                    }
                }
            }
        } else {
            complete(false, nil)
        }
    }
    
    /// m4a 转化为 wav
    public class func convertM4aToWav(originalPath: String, outPath: String, success block: @escaping (String) -> Void) {
        if FileManager.default.fileExists(atPath: outPath) {
            try? FileManager.default.removeItem(atPath: outPath)
        }
        
        let originalUrl = URL(fileURLWithPath: originalPath)
        let outPutUrl = URL(fileURLWithPath: outPath)
        
        guard let songAsset = AVURLAsset(url: originalUrl, options: nil) as AVAsset? else {
            return
        }
        
        // Create the export session
        guard let exportSession = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetPassthrough) else {
//            completion(false, nil)
            return
        }
        
        exportSession.outputFileType = AVFileType.wav
        exportSession.outputURL = outPutUrl
        
        // Perform the export
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
//                completion(true, nil)
                print("---- 成功")
            case .failed, .cancelled:
//                completion(false, exportSession.error)
                print("----error = \(exportSession.error)")
            default:
                break
            }
        }
        
//        var error: NSError?
//        guard let assetReader = try? AVAssetReader(asset: songAsset) else {
//            print("error: \(error)")
//            return
//        }
//        
//        let assetReaderOutput = AVAssetReaderAudioMixOutput(audioTracks: songAsset.tracks,
//                                                            audioSettings: nil)
//        
//        guard assetReader.canAdd(assetReaderOutput) else {
//            print("can't add reader output... die!")
//            return
//        }
//        
//        assetReader.add(assetReaderOutput)
//        
//        guard let assetWriter = try? AVAssetWriter(outputURL: outPutUrl,
//                                                   fileType: AVFileType.caf) else {
//            print("error: \(error)")
//            return
//        }
//        
//        var channelLayout = AudioChannelLayout()
//        memset(&channelLayout, 0, MemoryLayout.size(ofValue: channelLayout))
//        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
//        
//        let outputSettings: [String: Any] = [
//            AVFormatIDKey: kAudioFormatLinearPCM,
//            AVSampleRateKey: 44100.0,
//            AVNumberOfChannelsKey: 2,
//            AVChannelLayoutKey: NSData(bytes: &channelLayout, length: MemoryLayout.size(ofValue: channelLayout)),
//            AVLinearPCMBitDepthKey: 16,
//            AVLinearPCMIsNonInterleaved: NSNumber(value: false),
//            AVLinearPCMIsFloatKey: NSNumber(value: false),
//            AVLinearPCMIsBigEndianKey: NSNumber(value: false)
//        ]
//        
//        let assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
//        
//        if assetWriter.canAdd(assetWriterInput) {
//            assetWriter.add(assetWriterInput)
//        } else {
//            print("can't add asset writer input... die!")
//            return
//        }
//        
//        assetWriterInput.expectsMediaDataInRealTime = false
//        
//        do {
//            try assetWriter.startWriting()
//        } catch {
//            print("error: \(error)")
//            return
//        }
//        
//        assetReader.startReading()
//        
//        guard let soundTrack = songAsset.tracks.first else {
//            return
//        }
//        
//        let startTime = CMTimeMake(value: 0, timescale: soundTrack.naturalTimeScale)
//        assetWriter.startSession(atSourceTime: startTime)
//        
//        var convertedByteCount: UInt64 = 0
//        
//        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
//        assetWriterInput.requestMediaDataWhenReady(on: mediaInputQueue) {
//            while assetWriterInput.isReadyForMoreMediaData {
//                guard let nextBuffer = assetReaderOutput.copyNextSampleBuffer() else {
//                    assetWriterInput.markAsFinished()
//                    assetWriter.finishWriting {
//                        // Completion Handler
//                    }
//                    assetReader.cancelReading()
//                    
//                    if let outputFileAttributes = try? FileManager.default.attributesOfItem(atPath: outPutUrl.path) as NSDictionary {
//                        let fileSize = outputFileAttributes.fileSize()
//                        print("FlyElephant \(fileSize)")
//                    }
//                    
//                    block(outPath)
//                    break
//                }
//                
//                // Append buffer
//                assetWriterInput.append(nextBuffer)
//                convertedByteCount += UInt64(CMSampleBufferGetTotalSampleSize(nextBuffer))
//            }
//        }
    }

    
    /// 将图片转换为PixelBuffer
    public class func pixelBufferFromImage(image: UIImage) -> CVPixelBuffer? {
        let ciimage = CIImage(image: image)
        //let cgimage = convertCIImageToCGImage(inputImage: ciimage!)
        let tmpcontext = CIContext(options: nil)
        let cgimage =  tmpcontext.createCGImage(ciimage!, from: ciimage!.extent)
        
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
       
        let width = cgimage!.width
        let height = cgimage!.height
     
        var pxbuffer: CVPixelBuffer?
        // if pxbuffer = nil, you will get status = -6661
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32BGRA, options, &pxbuffer)
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);

        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue);
        context?.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
//        context?.concatenate(__CGAffineTransformMake( -1.0, 0.0, 0.0, 1.0, CGFloat(width), 0.0)) //Flip Horizontal
        

        context?.draw(cgimage!, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)));
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        // CVPixelBuffer to UIImage
//        if let pxbuffer {
//            let ciImageDepth            = CIImage(cvPixelBuffer: pxbuffer)
//            let contextDepth:CIContext  = CIContext.init(options: nil)
//            let cgImageDepth:CGImage    = contextDepth.createCGImage(ciImageDepth, from: ciImageDepth.extent)!
//            let uiImageDepth:UIImage    = UIImage(cgImage: cgImageDepth, scale: 1, orientation: UIImage.Orientation.up)
//            print("")
//        }
        
        return pxbuffer
            
    }
    
    /// 将图片压缩到指定size范围
    public class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let targetWidth = targetSize.width*(1.0/UIScreen.main.scale)
        let targetHeight = targetSize.height*(1.0/UIScreen.main.scale)
        
        var width = image.size.width
        var height = image.size.height
        
        // 只有图片大于目标尺寸，才需要压缩
        if width > targetSize.width || height > targetSize.height {
            if width/height < targetWidth / targetHeight {
                if width > targetWidth {
                    width = targetWidth
                    height = (image.size.height/image.size.width)*width
                }
            } else {
                if height > targetHeight {
                    height = targetHeight
                    width = (image.size.width/image.size.height)*height
                }
            }
            
            // 渲染
            let resultSize = CGSize(width: width, height: height)
            let renderer = UIGraphicsImageRenderer(size: resultSize)
            let resizedImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: resultSize))
            }
            return resizedImage
        }
        
        // 小于目标size，直接返回
        return image
    }
    
}
