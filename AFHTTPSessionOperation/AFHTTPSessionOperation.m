//
//  AFHTTPSessionOperation.m
//
//  Created by Robert Ryan on 8/6/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//

#import "AFHTTPSessionOperation.h"
#import "AFNetworking.h"

@interface AFHTTPSessionManager (DataTask)

// this method is not publicly defined in @interface in .h, so we need to define our own interface for it

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end

@interface AFHTTPSessionOperation ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) id parameters;
@property (nonatomic, copy) void (^body)(id <AFMultipartFormData> formData);
@property (nonatomic, copy) void (^success)(NSURLSessionDataTask *task, id responseObject);
@property (nonatomic, copy) void (^failure)(NSURLSessionDataTask *task, NSError * error);

@property (nonatomic, weak) NSURLSessionTask *task;

@end

@implementation AFHTTPSessionOperation

+ (nullable instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                                       method:(NSString *)method
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    AFHTTPSessionOperation *operation = [[self alloc] init];
    
    operation.manager = manager;
    operation.method = method;
    operation.URLString = URLString;
    operation.parameters = parameters;
    operation.success = success;
    operation.failure = failure;
    
    return operation;
}

+ (nullable instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                                       method:(NSString *)method
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))body
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask *task, NSError * error))failure {
    
    AFHTTPSessionOperation *operation = [[self alloc] init];
    
    operation.manager = manager;
    operation.method = method;
    operation.URLString = URLString;
    operation.parameters = parameters;
    operation.body = body;
    operation.success = success;
    operation.failure = failure;
    
    return operation;
}

- (void)main {
    NSURLSessionDataTask *task;
    if([self.method isEqualToString:@"POST"] && self.body != nil){
        task = [self.manager POST:self.URLString parameters:self.parameters constructingBodyWithBlock:self.body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (self.success) {
                self.success(task, responseObject);
            }
            [self completeOperation];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self.failure) {
                self.failure(task, error);
            }
            [self completeOperation];
        }];
    }
    else{
        task = [self.manager dataTaskWithHTTPMethod:self.method URLString:self.URLString parameters:self.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.success) {
                self.success(task, responseObject);
            }
            [self completeOperation];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (self.failure) {
                self.failure(task, error);
            }
            [self completeOperation];
        }];
    }
    
    [task resume];
    self.task = task;
}

- (void)completeOperation {
    self.failure = nil;
    self.success = nil;
    self.body = nil;
    
    [super completeOperation];
}

- (void)cancel {
    [self.task cancel];
    [super cancel];
}

@end
