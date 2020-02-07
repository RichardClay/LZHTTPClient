//
//  LZParameterConfig.m
//  LZNetworkingDemo
//
//  Created by LZ on 2017/9/13.
//  Copyright © 2017年 LZ. All rights reserved.
//

#import "LZParameterConfig.h"

@implementation LZParameterConfig

+ (instancetype)parameterConfigWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller  completion:(LZCompletionBlock)completion
{
    return [[self alloc] initWithParameters:parameters apiPath:apiPath cancelDependence:cancelDependence controller:controller completion:completion];
}
- (instancetype)initWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller  completion:(LZCompletionBlock)completion
{
    if (self = [super init]) {
        self.parameters = parameters;
        self.apiPath = apiPath;
        self.cancelDependence = cancelDependence;
        self.controller = controller;
        self.completion = completion;
        
        self.type = LZNetworkingTypePOST;
        self.autoCancel = YES;
        self.showError = YES;
        self.showLoad = YES;
        self.executeConditionOfSuccess = YES;
    }
    
    return self;
}

@end
