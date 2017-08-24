//
//  SyncManager.m
//  Ebizident
//
//  Created by Pritesh Pethani on 10/12/15.
//  Copyright © 2015 Pritesh Pethani. All rights reserved.
//

#import "SyncManager.h"
#import "AFNetworking.h"

@implementation SyncManager

-(void) webServiceCall:(NSString*)url withParams:(NSDictionary*) params  withTag:(NSInteger) tag{
    
    NSURL *baseURL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.delegate syncSuccess:responseObject withTag:tag];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.delegate syncFailure:error withTag:tag];
    }];
    
    
    //    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id
    //                                            responseObject) {
    //        [self.delegate syncSuccess:responseObject withTag:tag];
    //
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        [self.delegate syncFailure:error withTag:tag];
    //
    //    }];
}

-(void) webServiceCallWithOtherParameter:(NSString*)url withParams:(NSDictionary*) params  withTag:(NSInteger) tag withEmailID:(NSString*) emailid withToken:(NSString*) token{
    
    NSURL *baseURL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:emailid forHTTPHeaderField:@"X-AUTH-EMAIL"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id
                                                  responseObject) {
        [self.delegate syncSuccess:responseObject withTag:tag];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate syncFailure:error withTag:tag];
        
    }];
}

-(void) webServiceCallWithOtherParameterForGetRequest:(NSString*)url withParams:(NSDictionary*) params  withTag:(NSInteger) tag withEmailID:(NSString*) emailid withToken:(NSString*) token{
    
    NSURL *baseURL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:emailid forHTTPHeaderField:@"X-AUTH-EMAIL"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id
                                                 responseObject) {
        [self.delegate syncSuccess:responseObject withTag:tag];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate syncFailure:error withTag:tag];
        
    }];
}


@end
