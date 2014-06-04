//
//  ListProgramDelegate.h
//  tv
//
//  Created by Аня Кайгородова on 20.05.14.
//  Copyright (c) 2014 VideoLAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"
#import "ProgramLoaderProtocol.h"

@class List;

@interface ProgramLoader : NSObject<NSURLConnectionDelegate, ProgramLoaderProtocol>{
    BOOL isLoading;
}

@property (nonatomic, assign) List* tableDelegate;
@property (nonatomic, retain) NSMutableDictionary* connectionDictionary;
@property (nonatomic, retain) NSMutableDictionary* parserDictionary;
@property (nonatomic, retain) NSOperationQueue* connectionQueue;

@end
