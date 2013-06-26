//
//  Utils.m
//  Converter
//
//  Created by TopTierlabs on 4/26/13.
//  Copyright (c) 2013 pabloepi14@hotmail.com. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (bool) isFavorite:(NSString*)actualCode{
        
    NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[self favoritesPlistPath]];
    NSArray *actualValues = [favPlist valueForKey:@"Favorites"];
    for (int i=0; i<actualValues.count; i++){
        NSDictionary *ICD = [actualValues objectAtIndex:i];
        NSArray *code = [ICD allKeys];
        if ([[code objectAtIndex:0] isEqualToString:actualCode]){
            return true;
        }
    }
    return false;
}

+ (void) removeFavorite:(NSString*) actualCode{
    
    NSMutableDictionary *favPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[Utils favoritesPlistPath]];
    
    NSString *error = nil;
    // create NSData from dictionary
    
    
    NSMutableArray *actualValues = [favPlist valueForKey:@"Favorites"];
    for (int i=0; i<actualValues.count; i++){
        NSDictionary *ICD = [actualValues objectAtIndex:i];
        NSArray *code = [ICD allKeys];
        if ([[code objectAtIndex:0] isEqualToString:actualCode]){
            [actualValues removeObjectAtIndex:i];
        }
    }
    
    [favPlist setObject:actualValues forKey:@"Favorites"];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:favPlist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:[Utils favoritesPlistPath] atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoriteAdded" object:self];
    
}

+ (NSString*) favoritesPlistPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    return [documentsPath stringByAppendingPathComponent:@"Favorites.plist"];

}

+ (NSString*) commentsICD9PlistPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    return [documentsPath stringByAppendingPathComponent:@"CommentsICD9.plist"];
}

+ (NSString*) commentsICD10PlistPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    return [documentsPath stringByAppendingPathComponent:@"CommentsICD10.plist"];
    
}


@end
