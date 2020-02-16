
#import <Foundation/Foundation.h>
#import "LZNetworkingDefine.h"
#import "LZNetworkingConfig.h"
#import "LZErrorConfig.h"
#import "LZLoadConfig.h"
#import "LZUploadModel.h"

@interface LZParameterConfig : NSObject

/**
 请求参数
 */
@property (copy, nonatomic) NSDictionary *parameters;

/**
 请求类型（默认为POST）
 */
@property (assign, nonatomic) LZNetworkingType type;

/**
 上传文件数组（默认为nil）
 */
@property (copy, nonatomic) NSArray<LZUploadModel *> *uploadModels;

/**
下载文件存储目录（默认为nil）
*/
@property (nonatomic,copy ) NSString *downloadSaveUrl;

/**
 请求api
 */
@property (copy, nonatomic) NSString *apiPath;

/**
 是否自动取消（默认为YES）
 */
@property (assign, nonatomic) BOOL autoCancel;

/**
 自动取消操作的依赖对象（此对象一销毁，就执行取消操作，所以autoCancel设置为YES的时候必须设置此参数自动取消才会起作用，默认为nil）
 */
@property (weak, nonatomic) id cancelDependence;

/**
 网络请求发生的控制器（默认为nil）
 */
@property (weak, nonatomic) UIViewController *controller;

/**
 是否处理错误（默认为YES）
 */
@property (assign, nonatomic) BOOL showError;

/**
 是否显示加载（默认为YES）
 */
@property (assign, nonatomic) BOOL showLoad;

/**
 是否执行成功的条件(默认为YES，如果为NO，只要网络请求成功就表示成功)
 */
@property (assign, nonatomic) BOOL executeConditionOfSuccess;

/**
 网络配置对象（默认为nil）
 */
@property (strong, nonatomic) LZNetworkingConfig *networkingConfig;

/**
 错误配置对象（默认为nil）
 */
@property (strong, nonatomic) LZErrorConfig *errorConfig;

/**
 加载配置对象（默认为nil）
 */
@property (strong, nonatomic) LZLoadConfig *lodaConfig;

/**
 进度回调（默认为nil）
 */
@property (copy, nonatomic) LZProgressBolck progress;

/**
 请求完成回调（默认为nil）
 */
@property (copy, nonatomic) LZCompletionBlock completion;

+ (instancetype)parameterConfigWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion;
- (instancetype)initWithParameters:(NSDictionary *)parameters apiPath:(NSString *)apiPath cancelDependence:(id)cancelDependence controller:(UIViewController *)controller completion:(LZCompletionBlock)completion;

@end
