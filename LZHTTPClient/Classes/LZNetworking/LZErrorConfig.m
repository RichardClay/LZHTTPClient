//
//  LZErrorConfig.m
//  VCHelper
//
//  Created by QSP on 2017/9/18.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "LZErrorConfig.h"

@implementation LZErrorConfig

+ (instancetype)errorConfigWithNetworkingErrorPrompt:(LZNetworkingErrorBlock)networkingErrorPrompt dataErrorPrompt:(LZDataErrorBlock)dataErrorPrompt
{
    return [[self alloc] initWithNetworkingErrorPrompt:networkingErrorPrompt dataErrorPrompt:dataErrorPrompt];
}
- (instancetype)initWithNetworkingErrorPrompt:(LZNetworkingErrorBlock)networkingErrorPrompt dataErrorPrompt:(LZDataErrorBlock)dataErrorPrompt
{
    if (self = [super init]) {
        self.networkingErrorPrompt = networkingErrorPrompt;
        self.dataErrorPrompt = dataErrorPrompt;
    }
    
    return self;
}

@end
