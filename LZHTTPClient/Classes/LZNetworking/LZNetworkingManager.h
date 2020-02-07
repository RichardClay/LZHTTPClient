//
//  LZNetworkingManager.h
//  LZNetworkingDemo
//
//  Created by LZ on 2017/8/14.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZNetworkingDefine.h"
#import "LZParameterConfig.h"
#import "LZErrorConfig.h"
#import "LZLoadConfig.h"

@class LZNetworkingObject;
@interface LZNetworkingManager : NSObject

/**
 配置对象
 */
@property (strong, nonatomic) LZNetworkingConfig *config;

/**
 错误配置对象
 */
@property (strong, nonatomic) LZErrorConfig *errorConfig;

/**
 加载配置对象
 */
@property (strong, nonatomic) LZLoadConfig *loadConfig;

/**
 成功的条件（如果不设置，只要网络请求成功，就认为是成功）
 */
@property (copy, nonatomic) LZConditionOfSuccessBolck conditionOfSuccess;

/**
 配置框架
 
 @param networkingConfig 网络配置
 @param errorConfig 错误配置
 @param loadConfig 加载配置
 @param condictionOfSuccess 成功的条件（如果不设置，只要网络请求成功，就认为是成功）
 */
+ (void)configWithNetworkingConfig:(LZNetworkingConfig *)networkingConfig errorConfig:(LZErrorConfig *)errorConfig loadConfig:(LZLoadConfig *)loadConfig condictionOfSuccess:(LZConditionOfSuccessBolck)condictionOfSuccess;

/**
 单例方法
 */
+ (instancetype)manager;

/**
 默认调用（POST方式调用，最终转化为callWithParameterConfig方法调用）

 @param apiPath api
 @param parameters 参数
 @param dependence 依赖对象
 @param completion 完成的回调
 @return QSPNetworkingObject对象
 */
+ (LZNetworkingObject *)defaultCall:(NSString *)apiPath parameters:(NSDictionary *)parameters cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion;

/**
 get调用（最终转化为callWithParameterConfig方法调用）
 
 @param apiPath api
 @param parameters 参数
 @param dependence 依赖对象
 @param completion 完成的回调
 @return QSPNetworkingObject对象
 */
+ (LZNetworkingObject *)getCall:(NSString *)apiPath parameters:(NSDictionary *)parameters cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion;

/**
 使用配置对象调用

 @param parameterConfig 配置对象
 @return QSPNetworkingObject对象
 */
+ (LZNetworkingObject *)callWithParameterConfig:(LZParameterConfig *)parameterConfig;

/**
 取消网络请求

 @param task 网络任务
 */
+ (void)cancelWithTask:(NSURLSessionTask *)task;

@end


/**
 网络请求对象
 */
@interface LZNetworkingObject : NSObject

@property (strong, nonatomic, readonly) NSURLSessionTask *task;

+ (instancetype)networkingObjectWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel;
- (instancetype)initWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel;

/**
 取消请求
 */
- (void)cancel;

@end
