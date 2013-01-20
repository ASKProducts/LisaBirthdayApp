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
+(id)getValueForKey:(NSString*)key;

+(void)setValue:(id)value withKey:(NSString*)key;

@end
