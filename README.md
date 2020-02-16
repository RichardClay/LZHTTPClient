# LZHTTPClient

[![CI Status](https://img.shields.io/travis/kk/LZHTTPClient.svg?style=flat)](https://travis-ci.org/kk/LZHTTPClient)
[![Version](https://img.shields.io/cocoapods/v/LZHTTPClient.svg?style=flat)](https://cocoapods.org/pods/LZHTTPClient)
[![License](https://img.shields.io/cocoapods/l/LZHTTPClient.svg?style=flat)](https://cocoapods.org/pods/LZHTTPClient)
[![Platform](https://img.shields.io/cocoapods/p/LZHTTPClient.svg?style=flat)](https://cocoapods.org/pods/LZHTTPClient)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LZHTTPClient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LZHTTPClient'
```

## 使用说明
### 配置网络框架
此网络框架的配置需要LZNetworkingConfig（网络配置对象）、LZErrorConfig（错误处理配置对象）、LZLoadConfig（加载处理配置对象）以及一个判断网络请求数据正确的block共同完成（Block内可做数据处理，根据不同情况做容错）
```
- (void)configNetworking {
    //创建网络配置对象，控制网络请求
    LZNetworkingConfig *networkingConfig = [LZNetworkingConfig networkingConfigWithBasePath:@""];
    
    //创建错误处理配置对象，处理网络、数据错误
    LZErrorConfig *errorConfig = [LZErrorConfig errorConfigWithNetworkingErrorPrompt:^(NSError *error, UIViewController *controller) {
        if (error.code == -999) {
            //toast
        }
        else if (error.code == -1001)
        {
            //toast
        }
        else
        {
            //toast
        }
    } dataErrorPrompt:^void(id responseObject, UIViewController *controller) {
        //数据错误
        if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
            
        } else {
           
        }
    }];
    
    //统一创建加载处理配置对象，处理加载过程
    LZLoadConfig *loadConfig = [LZLoadConfig loadConfigWithLoadBegin:^(UIViewController *controller){
        
    } loadEnd:^(UIViewController *controller){
        
    }];
    
    //配置网络框架
    [LZNetworkingManager configWithNetworkingConfig:networkingConfig errorConfig:errorConfig loadConfig:loadConfig condictionOfSuccess:^BOOL(id responseObject) {
        return [responseObject[@"status"] integerValue] == 1;
    }];
}
```

### 发送请求

#### 分装了如下三个方法来发送请求，分别为默认方式（post）、get方式、参数配置方式（可以通过配置对象配置各种适合自己的请求）。
```
+ (LZNetworkingObject *)defaultCall:(NSString *)apiPath parameters:(NSDictionary *)parameters cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion;
+ (LZNetworkingObject *)getCall:(NSString *)apiPath parameters:(NSDictionary *)parameters cancelDependence:(id)dependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion;
+ (LZNetworkingObject *)callWithParameterConfig:(LZParameterConfig *)parameterConfig;
```

#### 发送一个get请求
```

        [LZNetworkingManager getCall:K_NetService_Regeo parameters:K_NetService_RegeoParamery cancelDependence:weakSelf controller:weakSelf completion:^(BOOL success, id responseObject, NSError *error) {
            if (success) {
                [LoadClass showMessage:@"请求成功！" toView:weakSelf.view];
            }
        }];
        [weakSelf.navigationController popViewControllerAnimated:NO];
```

#### 取消请求说明
1. 手动取消：每发送一个请求都会返回一个LZNetworkingObject，只需对该对象进行cancel操作就能取消此请求了。
2. 自动取消：发送请求的时候会要求设置一个cancelDependence的参数，这个参数就是自动取消请求的依赖对象，只要设置了此对象，请求在此对象销毁时如果还没有完成，那么就会取消这个请求，所在控制器销毁时也会取消这个请求。

## Author

LZ, 750460196@qq.com

## License

LZHTTPClient is available under the MIT license. See the LICENSE file for more info.
