//
//  TFY_PhotoBrowserUITestsLaunchTests.m
//  TFY_PhotoBrowserUITests
//
//  Created by 田风有 on 2022/2/6.
//

#import <XCTest/XCTest.h>

@interface TFY_PhotoBrowserUITestsLaunchTests : XCTestCase

@end

@implementation TFY_PhotoBrowserUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
