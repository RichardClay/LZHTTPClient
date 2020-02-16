//
//  LZNetworkingDefine.h
//  LZNetworkingDemo
//
//  Created by LZ on 2017/8/14.
//  Copyright © 2017年 LZ. All rights reserved.
//

#ifndef LZNetworkingDefine_h
#define LZNetworkingDefine_h
#import <UIKit/UIKit.h>

/**
 *  1.调试阶段，写代码调试错误，需要打印。(系统会自定义一个叫做DEBUG的宏)
 *  2.发布阶段，安装在用户设备上，不需要打印。(系统会删掉这个叫做DEBUG的宏)
 */
#if DEBUG
#define LZNetworkingLog(FORMAT, ...)    fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String])
#else
#define LZNetworkingLog(FORMAT, ...)
#endif

#define                 LZNetworkingObject_arrayName           @"LZNetworkingObject_array"
#define                 LZNetworking_weakSelf                  __weak typeof(self) weakSelf = self;

typedef BOOL (^LZConditionOfSuccessBolck)(id responseObject);
typedef void (^LZCompletionBlock)(BOOL success, id responseObject, NSError *error);
typedef void (^LZProgressBolck)(NSProgress * uploadProgress);

typedef void (^LZNetworkingErrorBlock)(NSError *error, UIViewController *controller);
typedef void (^LZDataErrorBlock)(id responseObject, UIViewController *controller);

typedef void (^LZLoadBlock)(UIViewController *controller);

typedef NS_ENUM(NSInteger, LZNetworkingType){
    LZNetworkingTypePOST = 0,
    LZNetworkingTypeGET = 1,
    LZNetworkingTypeDOWNLOAD =2
};

#endif /* LZNetworkingDefine_h */
