//
//  ODSDataStorage.h
//  OnlineDataStorage
//
//  Created by Aaron Kaufer on 1/9/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#define ONLINE_DATA_STORAGE_APP_KEY @"LisaBirthdayApp"

#import <Foundation/Foundation.h>

@interface NSString (HTMLEntities)

- (NSString *)stringByDecodingHTMLEntities;

@end


@interface ODSDataStorage : NSObject
+(void)loadURL:(NSString*)aurl forMethod:(NSString*)method;
+(NSMutableDictionary*)onlineData;
+(NSString*)getValueForKey:(NSString*)key;

+(void)setValue:(NSString*)value withKey:(NSString*)key;

@end
