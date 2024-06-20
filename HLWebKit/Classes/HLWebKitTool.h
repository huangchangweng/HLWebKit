//
//  HLWebKitTool.h
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#ifdef DEBUG
#   define HLWebKitLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] );
#else
#   define HLWebKitLog(...)
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLWebKitTool : NSObject

/// base64编码
+ (NSString *)base64Encoded:(NSString *)string;

/// base64解码
+ (NSString *)base64Decoded:(NSString *)string;

/// url编码
+ (NSString *)urlDecoded:(NSString *)urlString;

/// url解码
+ (NSString *)urlEncoded:(NSString *)urlString;

/// 打开URL
+ (void)openURL:(NSURL *)URL;

/// 获取图片
+ (UIImage *)imageNamed:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
