//
//  ProgramLoaderDelegate.h
//  tv
//
//  Created by Аня Кайгородова on 22.05.14.
//  Copyright (c) 2014 VideoLAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProgramLoaderProtocol <NSObject>

-(void)loadProgramForChannelID:(NSString*)channelID;

@end
