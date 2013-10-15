//
//  Transfer+ParseXML.m
//  LKOA4iPhone
//
//  Created by  STH on 7/28/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "Transfer+ParseXML.h"
#import "TBXML.h"

@interface Transfer (private)



//获取未读传阅详情
//- (UnReadDetailModel *) getFilePassBody:(TBXMLElement *) bodyElement;

@end

@implementation Transfer (ParseXML)

- (id) DemoParse:(NSString *) reqName
{
//    NSError *error = nil;
//    TBXML *tbXML = [[TBXML alloc] initWithXMLFile:@"http_request_param" fileExtension:@"xml" error:&error];
//    if (error) {
//        NSLog(@"%@->ParseXML[%@]:%@", [self class] , reqName, [error localizedDescription]);
//        return nil;
//    }
//    
//    TBXMLElement *rootElement = [tbXML rootXMLElement];
//    if (rootElement) {
//    
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        TBXMLElement *listElement = [TBXML childElementNamed:@"request" parentElement:rootElement];
//        while (listElement) {
    
            
//            UnReadModel *model = [[UnReadModel alloc] init];
//            [model setPKID:[TBXML textForElement:[TBXML childElementNamed:@"PKID" parentElement:listElement]]];
//            [model setTitle:[TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:listElement]]];
//            [model setReleaseDate:[TBXML textForElement:[TBXML childElementNamed:@"ReleaseDate" parentElement:listElement]]];
//            [model setFileId:[TBXML textForElement:[TBXML childElementNamed:@"FileId" parentElement:listElement]]];
//            
//            
//            
//            [array addObject:model];
//            listElement = [TBXML nextSiblingNamed:@"List" searchFromElement:listElement];
//        }
//        
//        
//        return array;
//    }
    
    return nil;
}

- (id) ParseXMLWithReqName:(NSString *) reqName
                           xmlString:(NSString *) xml
{
        
    return nil;
}

@end
