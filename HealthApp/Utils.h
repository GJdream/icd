//
//  Utils.h
//  Converter
//
//  Created by TopTierlabs on 4/26/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (bool) isFavorite:(NSString*)actualCode;
+ (NSString*) favoritesPlistPath;
+ (NSString*) commentsICD9PlistPath;
+ (NSString*) commentsICD10PlistPath;
+ (void) removeFavorite:(NSString*) code;

@end
