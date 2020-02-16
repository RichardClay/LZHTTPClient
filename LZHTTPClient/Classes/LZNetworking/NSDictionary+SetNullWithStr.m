//
//  NSDictionary+SetNullWithStr.m
//  UU
//
//  Created by lz on 2018/6/20.
//  Copyright © 2018年 lz. All rights reserved.
//

#import "NSDictionary+SetNullWithStr.h"

@implementation NSDictionary (SetNullWithStr)

+ (NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self replaceNullObjectWithResponse:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

+ (NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = [self replaceNullObjectWithResponse:obj];
        [resArr addObject:obj];
    }
    return resArr;
}


+ (NSString *)stringToString:(NSString *)string
{
    if ([string isEqualToString:@"<null>"]||[string isEqualToString:@"null"]) {
        return @"";
    }
    return string;
}

+ (NSString *)nullObjectToString
{
    return @"";
}

/**
 数据过滤

 @param res 数据源
 @return 过滤后数据
 */
+ (id)replaceNullObjectWithResponse:(id)res
{
    if ([res isKindOfClass:[NSDictionary class]]){
        return [self nullDic:res];
    }else if([res isKindOfClass:[NSArray class]]){
        return [self nullArr:res];
    }else if([res isKindOfClass:[NSString class]]){
        return [self stringToString:res];
    }else if([res isKindOfClass:[NSNull class]]){
        return [self nullObjectToString];
    }else{
        return res;
    }
}

@end
