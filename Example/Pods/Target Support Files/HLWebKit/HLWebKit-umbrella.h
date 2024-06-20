#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HLWeakScriptMessageDelegate.h"
#import "HLWebKit.h"
#import "HLWebKitTool.h"
#import "HLWebView.h"
#import "HLWebViewController.h"

FOUNDATION_EXPORT double HLWebKitVersionNumber;
FOUNDATION_EXPORT const unsigned char HLWebKitVersionString[];

