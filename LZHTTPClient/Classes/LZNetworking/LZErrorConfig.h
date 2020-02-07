//
//  LZErrorConfig.h
//  VCHelper
//
//  Created by QSP on 2017/9/18.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZNetworkingDefine.h"

@interface LZErrorConfig : NSObject

/**
 网络错误处理（默认无）
 */
@property (copy, nonatomic) LZNetworkingErrorBlock networkingErrorPrompt;

/**
 数据错误处理（默认无）
 */
@property (copy, nonatomic) LZDataErrorBlock dataErrorPrompt;

+ (instancetype)errorConfigWithNetworkingErrorPrompt:(LZNetworkingErrorBlock)networkingErrorPrompt dataErrorPrompt:(LZDataErrorBlock)dataErrorPrompt;

- (instancetype)initWithNetworkingErrorPrompt:(LZNetworkingErrorBlock)networkingErrorPrompt dataErrorPrompt:(LZDataErrorBlock)dataErrorPrompt;

@end
