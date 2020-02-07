//
//  LZLoadConfig.h
//  VCHelper
//
//  Created by QSP on 2017/9/18.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZNetworkingDefine.h"

@interface LZLoadConfig : NSObject

@property (copy, nonatomic) LZLoadBlock loadBegin;
@property (copy, nonatomic) LZLoadBlock loadEnd;

+ (instancetype)loadConfigWithLoadBegin:(LZLoadBlock)loadBegin loadEnd:(LZLoadBlock)loadEnd;
- (instancetype)initWithLoadBegin:(LZLoadBlock)loadBegin loadEnd:(LZLoadBlock)loadEnd;

@end
