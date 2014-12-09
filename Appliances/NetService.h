//
//  NetService.h
//  Appliances
//
//  Created by qiufawen on 30/11/14.
//  Copyright (c) 2014 yekaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetService : NSObject

+(void) Login:(NSString *) Username andPassword:(NSString *)Password;
+(void) CreateAccount:(NSDictionary *) Account;
@end

