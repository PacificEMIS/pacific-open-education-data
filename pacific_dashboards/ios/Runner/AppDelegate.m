#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* apiChannel = [FlutterMethodChannel methodChannelWithName:@"fm.doe.national.pacific_dashboards/api"
                                                                   binaryMessenger:controller];
    
    [apiChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"apiGet" isEqualToString:call.method]) {
            NSString *strNative = @"Result";
            result(strNative);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
