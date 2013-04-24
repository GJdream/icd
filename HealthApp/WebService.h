//
//  WebService.h
//  HealthApp
//
//  Created by Pablo Epíscopo on 15/06/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import <Foundation/Foundation.h>

@interface WebService : NSObject
{
    NSArray *arrayData; 
    NSMutableArray *arrayItems;
}

@property(nonatomic, retain) NSArray *arrayData;
@property(nonatomic, retain) NSMutableArray *arrayItems;

-(NSMutableArray *)getICD9ByCode: (NSString *)codeICD9;
-(NSMutableArray *)getICD10ByCode: (NSString *)codeICD10;
-(NSMutableArray *)getICD10ListByICD9Code: (NSString *)codeICD9;
-(NSMutableArray *)searchItems: (NSString *)text columnMax:(NSInteger *)maxColumns andCodeType:(NSInteger *) codeType;

@end
