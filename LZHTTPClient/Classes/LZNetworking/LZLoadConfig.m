//
//  LZLoadConfig.m
//  VCHelper
//
//  Created by QSP on 2017/9/18.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "LZLoadConfig.h"

@implementation LZLoadConfig

+ (instancetype)loadConfigWithLoadBegin:(LZLoadBlock)loadBegin loadEnd:(LZLoadBlock)loadEnd
{
    return [[self alloc] initWithLoadBegin:loadBegin loadEnd:loadEnd];
}
- (instancetype)initWithLoadBegin:(LZLoadBlock)loadBegin loadEnd:(LZLoadBlock)loadEnd
{
    if (self = [super init]) {
        self.loadBegin = loadBegin;
        self.loadEnd = loadEnd;
    }
    
    return self;
}

@end
