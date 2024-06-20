//
//  HLWebKitTool.m
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import "HLWebKitTool.h"

@implementation HLWebKitTool

#pragma mark - Private Method

+ (NSBundle *)resourceBundle
{
    static NSBundle *hlBundle = nil;
    if (hlBundle == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"HLWebView")];
        NSURL *bundleURL = [bundle URLForResource:@"HLWebKit" withExtension:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
        if (!resourceBundle) {
            NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:@"HLWebKit.bundle"];
            resourceBundle = [NSBundle bundleWithPath:bundlePath];
        }
        hlBundle = resourceBundle ?: bundle;
    }
    return hlBundle;
}

#pragma mark - Public Mehtod

/// base64编码
+ (NSString *)base64Encoded:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/// base64解码
+ (NSString *)base64Decoded:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/// url编码
+ (NSString *)urlDecoded:(NSString *)urlString
{
    NSString *string = urlString;
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/// url解码
+ (NSString *)urlEncoded:(NSString *)urlString
{
    NSString *string = urlString;
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                     (CFStringRef)string,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8));
    return encodedString;
}

/// 打开URL
+ (void)openURL:(NSURL *)URL
{
    BOOL success = [[UIApplication sharedApplication] canOpenURL:URL];
    if (success) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }
}

/// 获取图片
+ (UIImage *)imageNamed:(NSString *)imageName
{
    UIImage *image = nil;
    NSURL *mianBundleURL = [[NSBundle mainBundle] URLForResource:@"HLWebKit" withExtension:@"bundle"];
    if (mianBundleURL) {
        image = [UIImage imageWithContentsOfFile:[[[NSBundle bundleWithURL:mianBundleURL] resourcePath] stringByAppendingPathComponent:imageName]];
    } else {
        NSString *path = [[[self resourceBundle] resourcePath] stringByAppendingPathComponent:imageName];
        image = [UIImage imageWithContentsOfFile:path];
        if (!image) {
            image = [UIImage imageNamed:path];
        }
    }
    
    return image;
}

@end
