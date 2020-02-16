//
//  LZNetworkingManager.m
//  LZNetworkingDemo
//
//  Created by LZ on 2017/8/14.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "LZNetworkingManager.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <objc/runtime.h>
#import "NSDictionary+SetNullWithStr.h"

static LZNetworkingManager *_shareInstance;

@interface LZNetworkingManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation LZNetworkingManager
@synthesize config = _config;

- (LZNetworkingConfig *)config
{
    if (_config == nil) {
        _config = [LZNetworkingConfig networkingConfigWithBasePath:nil];
    }
    
    return _config;
}
- (void)setConfig:(LZNetworkingConfig *)config
{
    _config = config;
    self.sessionManager = [self sessionManagerWithNetworkingConfig:config];
}
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [self sessionManagerWithNetworkingConfig:self.config];
    }
    
    return _sessionManager;
}

- (AFHTTPSessionManager *)sessionManagerWithNetworkingConfig:(LZNetworkingConfig *)config
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:config.basePath]];
    sessionManager.requestSerializer.timeoutInterval = config.timeoutInterval;
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    sessionManager.responseSerializer = serializer;
    [config.HTTPHeaderDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    sessionManager.responseSerializer.acceptableContentTypes = config.acceptableContentTypes;
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:config.SSLPinningMode];
    sessionManager.securityPolicy.allowInvalidCertificates = config.allowInvalidCertificates;//忽略https证书
    sessionManager.securityPolicy.validatesDomainName = config.validatesDomainName;//是否验证域名
   
    if (!config.isAuthenticationDNS) {
        return sessionManager;
    }
    //授权验证
    AFSecurityPolicy *secx = sessionManager.securityPolicy;
    NSString *orangeHost = [sessionManager.requestSerializer.HTTPRequestHeaders valueForKey:@"host"];
    
    [sessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([secx evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:orangeHost]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
        if (credential) {
            *_credential = credential;
        }
        return disposition;
    }];
    
    //请求大数据时，重定向的授权认证
    [sessionManager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *_credential =nil;
        
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([secx evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:orangeHost]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
                _credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
        if (_credential) {
            *credential = _credential;
        }
        
        return disposition;
    }];
    return sessionManager;
}

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    
    return _shareInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });
    
    return _shareInstance;
}

+ (void)configWithNetworkingConfig:(LZNetworkingConfig *)networkingConfig errorConfig:(LZErrorConfig *)errorConfig loadConfig:(LZLoadConfig *)loadConfig condictionOfSuccess:(LZConditionOfSuccessBolck)condictionOfSuccess
{
    LZNetworkingManager *manager = [self manager];
    manager.config = networkingConfig;
    manager.errorConfig = errorConfig;
    manager.loadConfig = loadConfig;
    manager.conditionOfSuccess = condictionOfSuccess;
}
+ (LZNetworkingObject *)defaultCall:(NSString *)apiPath parameters:(NSDictionary *)parameters   cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion
{
    LZParameterConfig *parameterConfig = [LZParameterConfig parameterConfigWithParameters:parameters apiPath:apiPath cancelDependence:dependence controller:controller completion:completion];
    return [self callWithParameterConfig:parameterConfig];
}
+ (LZNetworkingObject *)getCall:(NSString *)apiPath parameters:(NSDictionary *)parameters cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion {
    LZParameterConfig *parameterConfig = [LZParameterConfig parameterConfigWithParameters:parameters apiPath:apiPath cancelDependence:dependence controller:controller completion:completion];
    parameterConfig.type = LZNetworkingTypeGET;
    return [self callWithParameterConfig:parameterConfig];
}
+ (LZNetworkingObject *)callWithParameterConfig:(LZParameterConfig *)config
{
    return [[self manager] callWithParameterConfig:config];
}
- (NSURLSessionDataTask * _Nullable)extracted:(LZParameterConfig *)parameterConfig sessionManager:(AFHTTPSessionManager *)sessionManager weakSelf:(LZNetworkingManager *const __weak)weakSelf {
    return [sessionManager POST:parameterConfig.apiPath parameters:parameterConfig.parameters constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        //上传文件
        for (LZUploadModel *uploadModel in parameterConfig.uploadModels) {
            [formData appendPartWithFileData:uploadModel.data name:uploadModel.name fileName:uploadModel.fileName mimeType:uploadModel.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //出来进度
        if (parameterConfig.progress) {
            parameterConfig.progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功着陆
        [weakSelf susseccWithParameterConfig:parameterConfig task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败着陆
        [weakSelf failureWithParameterConfig:parameterConfig task:task error:error];
    }];
}

- (LZNetworkingObject *)callWithParameterConfig:(LZParameterConfig *)parameterConfig
{
    NSParameterAssert(parameterConfig.apiPath.length > 0);
    if (self.config.isUseProxy == false) {
        if ([self isUseProxy]) {
            return nil;
        }
    }
    AFHTTPSessionManager *sessionManager = parameterConfig.networkingConfig ? [self sessionManagerWithNetworkingConfig:parameterConfig.networkingConfig] : self.sessionManager;
    [self showLoad:parameterConfig];
    LZNetworking_weakSelf
    if (parameterConfig.type == LZNetworkingTypeGET) {
        NSURLSessionTask *task = [sessionManager GET:parameterConfig.apiPath parameters:parameterConfig.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            if (parameterConfig.progress) {
                parameterConfig.progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf susseccWithParameterConfig:parameterConfig task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf failureWithParameterConfig:parameterConfig task:task error:error];
        }];
        
        return [self addDependence:parameterConfig andTask:task];
    }
    else
    {
        NSURLSessionDataTask *task = [self extracted:parameterConfig sessionManager:sessionManager weakSelf:weakSelf];
        
        return [self addDependence:parameterConfig andTask:task];
    }
}

+ (void)cancelWithTask:(NSURLSessionTask *)task;
{
    if (task.state != NSURLSessionTaskStateCompleted && task.state != NSURLSessionTaskStateCanceling) {
        [task cancel];
    }
}

- (void)susseccWithParameterConfig:(LZParameterConfig *)parameterConfig task:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    //打印请求信息
    LZNetworkingLog(@"\n接口地址：%@\n接口参数：%@\n上传文件：%@\n接口返回：%@", task.currentRequest.URL.absoluteString, parameterConfig.parameters, parameterConfig.uploadModels, responseObject);
    [self removeDependence:parameterConfig andTask:task];
    [self removeLoad:parameterConfig];
    
    //出来数据错误
    if (parameterConfig.showError) {
        //选择QSPErrorConfig，这里以parameterConfig的优先级高
        LZErrorConfig *errorConfig = parameterConfig.errorConfig ? parameterConfig.errorConfig : self.errorConfig;
        if (errorConfig.dataErrorPrompt) {
            errorConfig.dataErrorPrompt(responseObject, parameterConfig.controller);
        }
    }
    
    //过滤数据
    if (self.config.filterNullObj) {
        responseObject = [NSDictionary replaceNullObjectWithResponse:responseObject];
    }
    
    //执行成功条件
    if (parameterConfig.executeConditionOfSuccess) {
        if (self.conditionOfSuccess) {
            if (self.conditionOfSuccess(responseObject)) {
                if (parameterConfig.completion) {
                    parameterConfig.completion(YES, responseObject, nil);
                }
            }
            else
            {
                if (parameterConfig.completion) {
                    parameterConfig.completion(NO, responseObject, nil);
                }
            }
        }
        else
        {
            if (parameterConfig.completion) {
                parameterConfig.completion(YES, responseObject, nil);
            }
        }
    }
    else
    {
        if (parameterConfig.completion) {
            parameterConfig.completion(YES, responseObject, nil);
        }
    }
}
- (void)failureWithParameterConfig:(LZParameterConfig *)parameterConfig task:(NSURLSessionDataTask *)task error:(NSError *)error
{
    LZNetworkingLog(@"\n接口地址：%@\n接口参数：%@\n上传文件：%@\n\n错误信息：%@", task.currentRequest.URL.absoluteString, parameterConfig.parameters, parameterConfig.uploadModels, error);
    
    [self removeDependence:parameterConfig andTask:task];
    [self removeLoad:parameterConfig];
    
    if (parameterConfig.showError) {
        LZErrorConfig *errorConfig = parameterConfig.errorConfig ? parameterConfig.errorConfig : self.errorConfig;
        if (errorConfig.networkingErrorPrompt) {
            errorConfig.networkingErrorPrompt(error, parameterConfig.controller);
        }
    }
    
    if (parameterConfig.completion) {
        parameterConfig.completion(NO, nil, error);
    }
}

/**
 添加依赖
 */
- (LZNetworkingObject *)addDependence:(LZParameterConfig *)parameterConfig andTask:(NSURLSessionTask *)task
{
    if (task) {
        LZNetworkingObject *obj = [LZNetworkingObject networkingObjectWithTask:task autoCancel:(parameterConfig.autoCancel && parameterConfig.cancelDependence) ? YES : NO];
        
        if (parameterConfig.autoCancel && parameterConfig.cancelDependence) {
            NSMutableArray *networkingObjects = objc_getAssociatedObject(parameterConfig.cancelDependence, LZNetworkingObject_arrayName);
            if (networkingObjects == nil) {
                networkingObjects = [NSMutableArray arrayWithCapacity:1];
                objc_setAssociatedObject(parameterConfig.cancelDependence, LZNetworkingObject_arrayName, networkingObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            
            if (obj) {
                [networkingObjects addObject:obj];
            }
        }
        
        return obj;
    }
    else
    {
        return nil;
    }
}

/**
 移除依赖
 */
- (void)removeDependence:(LZParameterConfig *)parameterConfig andTask:(NSURLSessionTask *)task
{
    if (parameterConfig.autoCancel && parameterConfig.cancelDependence && task) {
        NSMutableArray *networkingObjects = objc_getAssociatedObject(parameterConfig.cancelDependence, LZNetworkingObject_arrayName);
        if (networkingObjects) {
            LZNetworkingObject *netObj;
            for (LZNetworkingObject *obj in networkingObjects) {
                if (obj.task == task) {
                    netObj = obj;
                    break;
                }
            }
            [networkingObjects removeObject:netObj];
        }
    }
}

/**
 执行加载处理
 */
- (void)showLoad:(LZParameterConfig *)parameterConfig
{
    if (parameterConfig.showLoad) {
        LZLoadConfig *loadConfig = parameterConfig.lodaConfig ? parameterConfig.lodaConfig : self.loadConfig;
        if (loadConfig.loadBegin) {
            loadConfig.loadBegin(parameterConfig.controller);
        }
    }
}

/**
 执行加载完成处理
 */
- (void)removeLoad:(LZParameterConfig *)parameterConfig
{
    if (parameterConfig.showLoad) {
        LZLoadConfig *loadConfig = parameterConfig.lodaConfig ? parameterConfig.lodaConfig : self.loadConfig;
        if (loadConfig.loadEnd) {
            loadConfig.loadEnd(parameterConfig.controller);
        }
    }
}

- (BOOL)isUseProxy {
   CFDictionaryRef dictionary = CFNetworkCopySystemProxySettings();
   const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dictionary, (const void*)kCFNetworkProxiesHTTPProxy);
   NSString* proxy = (__bridge NSString *)proxyCFstr;
   if (proxy.length > 0) {
       return YES;
   }
   return NO;
}


@end

@interface LZNetworkingObject ()

@property (assign, nonatomic, readonly) BOOL autoCancel;

@end

@implementation LZNetworkingObject

- (void)dealloc{
    if (self.autoCancel) {
        [self cancel];
    }
}

- (void)cancel{
    if (self.task.state != NSURLSessionTaskStateCompleted && self.task.state != NSURLSessionTaskStateCanceling) {
        [self.task cancel];
    }
}

+ (instancetype)networkingObjectWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel
{
    return [[self alloc] initWithTask:task autoCancel:autoCancel];
}
- (instancetype)initWithTask:(NSURLSessionTask *)task autoCancel:(BOOL)autoCancel
{
    if (self = [super init]) {
        _task = task;
        _autoCancel = autoCancel;
    }
    
    return self;
}

@end
