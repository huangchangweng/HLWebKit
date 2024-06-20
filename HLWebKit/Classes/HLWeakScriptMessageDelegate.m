//
//  HLWeakScriptMessageDelegate.m
//  HLWebKit
//
//  Created by 黄常翁 on 2024/6/19.
//

#import "HLWeakScriptMessageDelegate.h"

@implementation HLWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
