//
//  HttpHelper.m
//  VoiceImage
//
//  Created by SPG on 7/6/15.
//  Copyright (c) 2015 SPG. All rights reserved.
//

#import "HttpHelper.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include <AssetsLibrary/AssetsLibrary.h>
#import "global.h"

@implementation HttpHelper

static NSString* host = @"vophoto.chinacloudapp.cn";

+(void)applyForAccount:(id)object withSelector:(SEL)selector {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/register",host]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString* guid = [HttpHelper GetUUID];
    NSString* messageBody = [NSString stringWithFormat:@"{'Lang':'zh-CN', 'Name':'', 'Id':'%@'}}", guid];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[messageBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                    queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               [self doSomethingWithData:data];
//                               outstandingRequests--;
//                               if (outstandingRequests == 0) {
//                                   [self doSomethingElse];
//                               }
                               [object performSelector:selector withObject:data];
                           }];
    
    
}

+(void)uploadPhoto:(id)object withSelector:(SEL)selector imageName:(NSArray*)nameList imageData:(NSData*)imgData voicePath:(NSString*)voicePath date:(NSDate*)date location:(NSString*)location {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/upload",host]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"01212123234347564653452345326372377546546564";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    if (userId == nil) {
        return;
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n%@", userId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSString* name in nameList) {
        if (name != nil) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imgName\"\r\n\r\n%@", name] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    if (location != nil) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n%@", location] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (date != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"date\"\r\n\r\n%@", [formatter stringFromDate:date]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (imgData != nil) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", [nameList objectAtIndex:0]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imgData]];
    }
    if (voicePath != nil) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"voice\"; filename=\"%@\"\r\n", [NSString stringWithFormat:@"%@.wav",[HttpHelper GetUUID]]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:voicePath];
        [body appendData:[NSData dataWithData:data]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               //                               [self doSomethingWithData:data];
                               //                               outstandingRequests--;
                               //                               if (outstandingRequests == 0) {
                               //                                   [self doSomethingElse];
                               //                               }
                               [object performSelector:selector withObject:data];
                           }];
}

+(void)search:(id)object withSelector:(SEL)selector voicePath:(NSString*)voicePath tags:(NSArray*)tags{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/search",host]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"01212123234347564653452345326372377546546564";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    if (userId == nil) {
        return;
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n%@", userId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (tags != nil) {
        for (NSString* tag in tags) {
            if (tag != nil) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n%@", tag] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    if (voicePath != nil) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"search\"; filename=\"%@\"\r\n", @"search.wav"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:voicePath];
        [body appendData:[NSData dataWithData:data]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [object performSelector:selector withObject:data];
                           }];
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
