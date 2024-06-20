//
//  HLWeakScriptMessageDelegate.h
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak)id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end

NS_ASSUME_NONNULL_END
