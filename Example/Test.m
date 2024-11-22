//
//  Test.m
//  Example
//
//  Created by SharkAnimation on 2023/9/28.
//

#import "Test.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation Test

+ (void)test {

    // 添加视频和音频轨道的内容，这里只是示例，您需要替换为实际的视频和音频资源
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"target" withExtension:@"mp4"];
    AVURLAsset *videoAsset = [AVURLAsset assetWithURL:path];

    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];

    CGSize videoSize = videoTrack.naturalSize;

    // 创建AVMutableVideoComposition
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:videoAsset];
    videoComposition.frameDuration = CMTimeMake(1, 30); // 帧速率
    videoComposition.renderSize = videoSize; // 视频尺寸

    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);

    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = parentLayer.bounds;
    [parentLayer addSublayer:videoLayer];

    // 创建Core Animation 图层
    CALayer *animationLayer = [CALayer layer];
    animationLayer.allowsEdgeAntialiasing = YES;
    animationLayer.frame = parentLayer.bounds;
    [parentLayer addSublayer:animationLayer];

    CALayer *textAniLayer = [CALayer layer];
    textAniLayer.backgroundColor = [UIColor redColor].CGColor;
    textAniLayer.frame = CGRectMake(0, 0, 100, 100);

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.duration = 3;
    basicAnimation.repeatCount = 2;
    basicAnimation.fromValue=[NSNumber numberWithFloat:0.0];
    basicAnimation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
    basicAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    basicAnimation.removedOnCompletion = NO;
    [textAniLayer addAnimation:basicAnimation forKey:@"ani"];

    CALayer *textAniLayer2 = [CALayer layer];
    textAniLayer2.backgroundColor = [UIColor redColor].CGColor;
    textAniLayer2.frame = CGRectMake(200, 0, 100, 100);

    [animationLayer addSublayer:textAniLayer];
    [animationLayer addSublayer:textAniLayer2];

    if ([animationLayer contentsAreFlipped]) {
        animationLayer.geometryFlipped = YES;
    }

    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    // 创建AVAssetExportSession来导出合成的视频
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.outputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/output_video.mp4", docPath]];
    exportSession.videoComposition = videoComposition;

    // 开始导出
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        NSError *error = exportSession.error;
        if (error) {
            NSLog(@"Export failed with error: %@", error);
        } else {
            NSLog(@"Export successful");
        }
    }];

}

@end
