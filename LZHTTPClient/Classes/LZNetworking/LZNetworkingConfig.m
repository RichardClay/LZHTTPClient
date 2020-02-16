//
//  LZNetworkingConfig.m
//  LZNetworkingDemo
//
//  Created by LZ on 2017/9/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "LZNetworkingConfig.h"

@implementation LZNetworkingConfig

+ (instancetype)networkingConfigWithBasePath:(NSString *)basePath
{
    LZNetworkingConfig *config = [[LZNetworkingConfig alloc] init];
    config.basePath = basePath;
    config.timeoutInterval = 15;
    config.SSLPinningMode = AFSSLPinningModeNone;
    config.allowInvalidCertificates = NO;
    config.validatesDomainName = NO;
    config.isUseProxy = NO;
    config.filterNullObj = YES;
    config.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    config.HTTPHeaderDictionary = [NSDictionary dictionaryWithObject:@"ios" forKey:@"request-type"];
    
    return config;
}

@end
