#import "WebService.h"
#import "ItemICD9.h"
#import "ItemICD10.h"
#import "SBJSON.h"
@implementation WebService

@synthesize arrayData, arrayItems;

-(NSMutableArray *)getICD9ByCode: (NSString *)codeICD9
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"GETICD9BYCODE", nil), codeICD9]];
    
    arrayItems = nil;
    
    NSError *error;
    
    arrayItems = [[NSMutableArray alloc] init];
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    if ([jsonString length] > 0) {
        //Alloc the parser
        SBJSON *parser = [[SBJSON alloc] init];
        
        NSDictionary *json = [[parser objectWithString:jsonString error:nil] copy];
        NSDictionary *data = [json objectForKey:@"GetICD9ByCodeResult"];
        ItemICD9 *item =[[ItemICD9 alloc] init];
        
        if ([data objectForKey:@"Code"] == [NSNull null])
            [item setCodeICD9: nil];    
        else
            [item setCodeICD9: [data objectForKey:@"Code"]];
        
        NSMutableArray *auxArray = [self getICD10ListByICD9Code:codeICD9];
        
        if (auxArray == nil)
            [item setArrayICD10: nil];    
        else
            [item setArrayICD10: auxArray];
        
    
        
        if ([data objectForKey:@"LongDescription"] == [NSNull null])
            [item setLongDescription: nil];    
        else
            [item setLongDescription: [data objectForKey:@"LongDescription"]];
        
        if ([data objectForKey:@"ShortDescription"] == [NSNull null])
            [item setShortDescription: nil];    
        else
            [item setShortDescription: [data objectForKey:@"ShortDescription"]];
        
        [arrayItems addObject:item];
        
    }
    return arrayItems;
}

-(NSMutableArray *)getICD10ByCode: (NSString *)codeICD10
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"GETICD10BYCODE", nil), codeICD10]];
    
    arrayItems = nil;
    
    NSError *error;
    
    
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    arrayItems = [[NSMutableArray alloc] init];
    
    if ([jsonString length] > 0) {
        //Alloc the parser
        SBJSON *parser = [[SBJSON alloc] init];
        
        NSDictionary *json = [[parser objectWithString:jsonString error:nil] copy];
    
    
    
        NSDictionary *data = [json objectForKey:@"GetICD10ByCodeResult"];
        ItemICD10 *item = [[ItemICD10 alloc] init];
        
        if ([data objectForKey:@"Code"] == [NSNull null])
            [item setCodeICD10: nil];    
        else
            [item setCodeICD10: [data objectForKey:@"Code"]];
        
        NSDictionary *auxIcd9Dic = [data objectForKey:@"ICD9Equivalent"];
        
        if ([data objectForKey:@"ICD9Equivalent"] == [NSNull null])
            [item setEquivalentICD9: nil];
        else
            [item setEquivalentICD9:auxIcd9Dic];
        
        if ([data objectForKey:@"LongDescription"] == [NSNull null])
            [item setLongDescription: nil];    
        else
            [item setLongDescription: [data objectForKey:@"LongDescription"]];

        if ([data objectForKey:@"ShortDescription"] == [NSNull null])
            [item setShortDescription: nil];    
        else
            [item setShortDescription: [data objectForKey:@"ShortDescription"]];
        
        [arrayItems addObject:item];
            
    }
    return arrayItems;
}

-(NSMutableArray *)getICD10ListByICD9Code: (NSString *)codeICD9
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:
                                                NSLocalizedString(@"GETICD10LISTBYICD9CODE", nil), codeICD9]];
    
    NSError *error;
    
    
    NSMutableArray *auxArray = [[NSMutableArray alloc] init];
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    if ([jsonString length] > 0) {
        //Alloc the parser
        SBJSON *parser = [[SBJSON alloc] init];
        
        NSDictionary *json = [[parser objectWithString:jsonString error:nil] copy];
        NSMutableArray *data = [json objectForKey:@"GetICD10ListByICD9CodeResult"];
        if ([json objectForKey:@"GetICD10ListByICD9CodeResult"] == [NSNull null])
            auxArray = nil;
        else
            for (int i = 0; i < [data count]; i++) {
                NSDictionary *dicData = [data objectAtIndex:i];
                
                if ([dicData objectForKey:@"Code"] == [NSNull null])
                    [auxArray addObject: @"Equivalent Code Not Found"];
                else
                    [auxArray addObject: dicData];
                
            }
    }
        
        
        
    //NSDictionary *json = [NSJSONSerialization 
    //                      JSONObjectWithData:[NSData dataWithContentsOfURL:url]
    //                      options:kNilOptions 
    //                     error:&error];
    
    return auxArray;
}

-(NSMutableArray *)searchItems: (NSString *)text columnMax:(NSInteger *)maxColumns andCodeType:(NSInteger *) codeType
{
    
    NSString *newText = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) text,
                                                                          NULL, (CFStringRef) @"!’\"();:@&=+$,/?%#[]% ",kCFStringEncodingISOLatin1);
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:
                                                NSLocalizedString(@"SEARCHITEMS", nil), newText, maxColumns, codeType]];
    NSError *error;
    arrayItems = [[NSMutableArray alloc] init];
    
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    if ([jsonString length] > 0) {
        //Alloc the parser
        SBJSON *parser = [[SBJSON alloc] init];
        
        NSDictionary *json = [[parser objectWithString:jsonString error:nil] copy];
 
    
        NSDictionary *icd9_icd10_Array = [json objectForKey:@"SearchItemsResult"];
        
        NSArray *itemsICD9 = [icd9_icd10_Array objectForKey:@"ICD_9_Items"];
        NSArray *itemsICD10 = [icd9_icd10_Array objectForKey:@"ICD_10_Items"];

        NSMutableArray *icd9Array = [[NSMutableArray alloc] init];
        NSMutableArray *icd10Array = [[NSMutableArray alloc] init];
        
        
            
        if ([icd9_icd10_Array objectForKey:@"ICD_9_Items"] == [NSNull null]) {
            
            [icd9Array addObject:[NSNull null]];
            [arrayItems addObject:icd9Array];
            
        } else {
            
            for (int i = 0; i < [itemsICD9 count]; i++) {
        
                NSDictionary *aux = [itemsICD9 objectAtIndex:i];

                ItemICD9 *item9 = [[ItemICD9 alloc] init];
                
                if ([aux objectForKey:@"Code"] == [NSNull null])
                    [item9 setCodeICD9: nil];
                else
                    [item9 setCodeICD9:[aux objectForKey:@"Code"]];

                [item9 setArrayICD10: nil];
                
                if ([aux objectForKey:@"LongDescription"] == [NSNull null])
                    [item9 setLongDescription: nil];
                else
                    [item9 setLongDescription:[aux objectForKey:@"LongDescription"]];

                if ([aux objectForKey:@"ShortDescription"] == [NSNull null])
                    [item9 setShortDescription: nil];
                else
                    [item9 setShortDescription:[aux objectForKey:@"ShortDescription"]];

                [icd9Array addObject:item9];
                
            }
            
            [arrayItems addObject:icd9Array];
        }
        
        if ([icd9_icd10_Array objectForKey:@"ICD_10_Items"] == [NSNull null]) {

            [icd10Array addObject:[NSNull null]];
            [arrayItems addObject:icd10Array];
            
        } else {
            
            for (int i = 0; i < [itemsICD10 count]; i++) {
                
                NSDictionary *aux = [itemsICD10 objectAtIndex:i];

                ItemICD10 *item10 = [[ItemICD10 alloc] init];
                
                if ([aux objectForKey:@"Code"] == [NSNull null])
                    [item10 setCodeICD10: nil];
                else
                    [item10 setCodeICD10:[aux objectForKey:@"Code"]];

                if ([aux objectForKey:@"ICD9Equivalent"] == [NSNull null])
                    [item10 setEquivalentICD9: nil];
                else
                    [item10 setEquivalentICD9:[[aux objectForKey:@"ICD9Equivalent"] objectForKey:@"code"]];
                
                if ([aux objectForKey:@"LongDescription"] == [NSNull null])
                    [item10 setLongDescription: nil];
                else
                    [item10 setLongDescription:[aux objectForKey:@"LongDescription"]];
                
                if ([aux objectForKey:@"ShortDescription"] == [NSNull null])
                    [item10 setShortDescription: nil];
                else
                    [item10 setShortDescription:[aux objectForKey:@"ShortDescription"]];
                
                [icd10Array addObject:item10];
                
            }
            
            [arrayItems addObject:icd10Array];
        }
    }
    
    
    return arrayItems;
}

-(NSMutableArray *)getNews
{
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:
                                                NSLocalizedString(@"NEWS", nil)]];
    
    NSError *error;
    
    
    NSMutableArray *auxArray = [[NSMutableArray alloc] init];
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    if ([jsonString length] > 0) {
        //Alloc the parser
        SBJSON *parser = [[SBJSON alloc] init];
        
        NSDictionary *json = [[parser objectWithString:jsonString error:nil] copy];
        auxArray = [json objectForKey:@"NewsResult"];
    }
    
    
    
    //NSDictionary *json = [NSJSONSerialization
    //                      JSONObjectWithData:[NSData dataWithContentsOfURL:url]
    //                      options:kNilOptions
    //                     error:&error];
    
    //[auxArray autorelease];
    return auxArray;
}


-(void) ratingApp: (NSString*)comment rating:(NSInteger)rating{
    
    NSString *key = @"8FB12C60-6BEC-4757-93AD-FD4029B768CB";
    NSString *user_id = [[UIDevice currentDevice] uniqueIdentifier];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"RATEAPP",nil), rating, comment, key, user_id]];
    
    NSError *error;
    
    
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    if ([jsonString length] > 0) {
    }


    
}



//• code: código para el cual se reporta el error
//• type: valores 9 o 10, dependiendo si el código se trata de un ICD9 o un ICD10
//• comment_text: comentarios del usuario acerca del error encontrado
//• key: 8FB12C60-6BEC-4757-93AD-FD4029B768CB
//• id: id del dispositivo

-(void) reportCode: (NSString*)code type:(NSInteger)type comment:(NSString*) comment_text{
    NSString *key = @"8FB12C60-6BEC-4757-93AD-FD4029B768CB";
    NSString *user_id = [[UIDevice currentDevice] uniqueIdentifier]; //Device id
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"REPORTCODEERROR",nil), code, type, comment_text, key, user_id]];
    
    NSError *error;
    
    
    NSString *jsonString  =  [[NSString alloc] initWithContentsOfURL:url  encoding:NSASCIIStringEncoding  error:&error];
    if ([jsonString length] > 0) {
    }
    

}

@end





