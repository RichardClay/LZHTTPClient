//
//  LZViewController.m
//  LZHTTPClient
//
//  Created by kk on 02/07/2020.
//  Copyright (c) 2020 kk. All rights reserved.
//

#import "LZViewController.h"
#import <LZNetworkingManager.h>


@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //GET
    [LZNetworkingManager getCall:@"" parameters:@{} cancelDependence:self controller:self completion:^(BOOL success, id responseObject, NSError *error) {
         if (success) {
             
         }
     }];
    
    //POST
    [LZNetworkingManager defaultCall:@"" parameters:@{} cancelDependence:self controller:self completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
           
        }
    }];
    
    //自动取消网络请求
    [LZNetworkingManager getCall:@"" parameters:@{} cancelDependence:self controller:self completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
        
        }
    }];
    
    //手动调用取消网络请求
    LZNetworkingObject *netObj = [LZNetworkingManager defaultCall:@"" parameters:@{} cancelDependence:self controller:self completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
                                  
        }
    }];
    [netObj cancel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
