//
//  ItemICD10.h
//  Converter
//
//  Created by Pablo Epíscopo on 16/07/12.
//  Copyright (c) 2012 pabloepi14@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemICD10 : NSObject
{
    NSString *shortDescription;
    NSString *longDescription;
    NSString *codeICD10;
    NSDictionary *equivalentICD9;
}

@property(nonatomic, retain) NSString *shortDescription;
@property(nonatomic, retain) NSString *longDescription;
@property(nonatomic, retain) NSString *codeICD10;
@property(nonatomic, retain) NSDictionary *equivalentICD9;
@end
