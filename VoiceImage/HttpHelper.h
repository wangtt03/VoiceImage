//
//  HttpHelper.h
//  VoiceImage
//
//  Created by SPG on 7/6/15.
//  Copyright (c) 2015 SPG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject

+(void)applyForAccount:(id)object withSelector:(SEL)selector;
+(void)uploadPhoto:(id)object withSelector:(SEL)selector imageName:(NSArray*)nameList imageData:(NSData*)imgData voicePath:(NSString*)voicePath date:(NSDate*)date location:(NSString*)location;
+(void)search:(id)object withSelector:(SEL)selector voicePath:(NSString*)voicePath tags:(NSArray*)tags;
@end
