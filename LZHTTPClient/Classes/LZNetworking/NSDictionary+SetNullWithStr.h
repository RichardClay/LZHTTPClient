//
//  NSDictionary+SetNullWithStr.h
//  UU
//
//  Created by lz on 2018/6/20.
//  Copyright © 2018年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SetNullWithStr)


/**
 数据源过滤空对象

 @param res 数据源
 @return 过滤后数据源
 */
+ (id)replaceNullObjectWithResponse:(id)res;


@end
