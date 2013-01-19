//
//  ODSDataStorage.m
//  OnlineDataStorage
//
//  Created by Aaron Kaufer on 1/9/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "ODSDataStorage.h"

@implementation NSString (HTMLEntities)

- (NSString *)stringByDecodingHTMLEntities {
    // TODO: Replace this with something more efficient/complete
    NSMutableString *string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&apos;" withString:@"'"  options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:0 range:NSMakeRange(0, [string length])];
    return string;
}

@end

@implementation ODSDataStorage
+(void)loadURL:(NSString*)aurl forMethod:(NSString*)method{
    NSData *postData = [NSData dataWithBytes:[aurl UTF8String] length:[aurl length]];
    
    if([method isEqualToString:@"GET"]){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.openkeyval.org/%@",aurl]]];
        [[[NSURLConnection alloc] initWithRequest:request delegate:nil] description];
    }
    else{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openkeyval.org/"]];
        [request setURL:url];
        [request setHTTPMethod:method];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    }
}

+(NSMutableDictionary*)onlineData{
    NSData *contents = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.openkeyval.org/ASKProductsDatabase4499-%@",ONLINE_DATA_STORAGE_APP_KEY]]];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    data = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
    
    return data;
}

+(NSString*)getValueForKey:(NSString*)key{
    NSMutableDictionary *onlineData = [ODSDataStorage onlineData];
    return [onlineData valueForKey:key];
}

+(void)setValue:(NSString*)value withKey:(NSString*)key{
    //NSString *url = [NSString stringWithFormat:@"ASKProductsDatabase4499-%@",key,value];
    NSMutableDictionary *onlineData = [ODSDataStorage onlineData];
    [onlineData setValue:value forKey:key];
    
    NSData *JSONContentData = [NSJSONSerialization dataWithJSONObject:onlineData options:NSJSONReadingMutableContainers error:nil];
    NSString *JSONContentString = [[NSString alloc] initWithData:JSONContentData encoding:NSUTF8StringEncoding];
    
    [ODSDataStorage loadURL:[@"ASKProductsDatabase4499-" stringByAppendingFormat:@"%@=%@",ONLINE_DATA_STORAGE_APP_KEY,JSONContentString] forMethod:@"POST"];
}


@end






