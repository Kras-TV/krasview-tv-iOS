//
//  ListProgramDelegate.m
//  tv
//
//  Created by Аня Кайгородова on 20.05.14.
//  Copyright (c) 2014 VideoLAN. All rights reserved.
//

#import "ProgramLoader.h"

@implementation ProgramLoader
@synthesize tableDelegate = _tableDelegate;
@synthesize connectionDictionary = _connectionDictionary;
@synthesize parserDictionary = _parserDictionary;
@synthesize connectionQueue = _connectionQueue;

#pragma mark livecycle

-(id)init{
    if (self=[super init]) {
        self.connectionDictionary = [NSMutableDictionary dictionary];
        self.parserDictionary = [NSMutableDictionary dictionary];
        self.connectionQueue = [NSOperationQueue new];
        [self.connectionQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

-(void)dealloc{
    self.connectionDictionary = nil;
    self.parserDictionary = nil;
    self.connectionQueue = nil;
    [super dealloc];
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   // NSLog(@"connectionDidFinishLoading");
    NSLog(@"connectionDidFinishLoading %@ %@", [NSThread currentThread], connection);
    NSString *connString = [NSString stringWithFormat:@"%@", connection];
    NSString *channelID = [self.connectionDictionary objectForKey:connString];
    if(channelID!=nil){
        [self.connectionDictionary removeObjectForKey:connString];
        NSLog(@"channelID %@", channelID);
    }else{
        return;
    }
    
    [self syncAPI];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // NSLog(@"didReceiveResponse");
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   // NSLog(@"didReceiveData");
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"something very bad happened here");
    NSString *connString = [NSString stringWithFormat:@"%@", connection];
    if([self.connectionDictionary objectForKey:connString]!=nil){
        [self.connectionDictionary removeObjectForKey:connString];
    }
}

#pragma mark ProgramLoaderProtocol

-(void)loadProgramForChannelID:(NSString*)channelID{
   //[self loadForID:channelID];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:channelID,@"channelID", nil];
    NSOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadForID:) object:params];
    [operation release];
}

#pragma mark private

-(void)loadForID:(NSString*)channelID{
    
    NSMutableString* urlString = [NSMutableString stringWithFormat:@"http://tv.kraslan.ru/api/program/get.xml?id=%@", channelID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLConnection* cnc = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [self.connectionDictionary setObject:channelID forKey:[NSString stringWithFormat:@"%@", cnc]];
    [cnc release];
}

-(void)syncAPI{
    [self.tableDelegate dataLoadFinishing];
    [self.tableDelegate.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
