#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* apiChannel = [FlutterMethodChannel methodChannelWithName:@"fm.doe.national.pacific_dashboards/api"
                                                                   binaryMessenger:controller.binaryMessenger];
    
    __weak AppDelegate* weakSelf = self;
    [apiChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"apiGet" isEqualToString:call.method]) {
            NSString* url = call.arguments[@"url"];
            NSString* eTag = call.arguments[@"eTag"];
            
            if (weakSelf != nil) {
                [weakSelf handleApiGetCallWithUrl:url withETag:eTag onResult:result];
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void) handleApiGetCallWithUrl:(NSString*) url withETag:(NSString*) eTag onResult:(FlutterResult) result {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
        
        if (error != nil) {
            result([FlutterError errorWithCode:@"NSURLSession error"
                                       message:error.localizedDescription
                                       details:nil]);
            return;
        }
        
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            result([FlutterError errorWithCode:@"NSURLSession error"
                                       message:@"response is not NSHTTPURLResponse class"
                                       details:nil]);
            return;
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSNumber* statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
        NSString* eTag = httpResponse.allHeaderFields[@"ETag"];
        NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary* results = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"code" : statusCode,
            @"body" : body
        }];
        
        if (eTag != nil) {
            results[@"eTag"] = eTag;
        }
        
        result(results);
    }] resume];
}

@end

