//
//  AFNetWorkService.h
//  TBRJL
//
//  Created by 程三 on 15/6/10.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestInfo.h"


typedef void(^RequestCompelete)(id result);
@interface AFNetWorkService : NSObject

@property(nonatomic,retain)id result;
//设置获取cookID的服务参数对象
@property(nonatomic,retain)RequestInfo *requestInfo;

-(void)requestWithServiceIP:(NSString *) serviceIP ServiceName:(NSString *)serviceName
                       params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                       resultIsDictionary:(BOOL)resultIsDictionary
                       completeBlock:(RequestCompelete)block;

-(void)uploadUrl:(NSString *)url
                fileFullPath:(NSString *)fileFullpath
                params:(NSMutableDictionary *)params
                name:(NSString *)name
                fileName:(NSString *)fileName
                completeBlock:(RequestCompelete)block;

@end
