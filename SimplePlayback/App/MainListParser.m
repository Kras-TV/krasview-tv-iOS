//
//  MainListParser.m
//  tv
//
//  Created by Аня Кайгородова on 03.06.14.
//  Copyright (c) 2014 VideoLAN. All rights reserved.
//

#import "MainListParser.h"

@implementation MainListParser

@synthesize currentElement = _currentElement;
@synthesize currentDic = _currentDic;
@synthesize name = _name;
@synthesize chanelId = _chanelId;
@synthesize uri = _uri;
@synthesize fav = _fav;
@synthesize image = _image;

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
    
    if ([elementName isEqualToString:@"channel"]) {
        self.currentDic = [NSMutableDictionary dictionaryWithCapacity:2];
    }else if ([elementName isEqualToString:@"name"]){
        self.name = [NSMutableString string];
    }else if ([elementName isEqualToString:@"id"]){
        self.chanelId = [NSMutableString string];
    }else if([elementName isEqualToString:@"uri"]){
        self.uri = [NSMutableString string];
    }else if([elementName isEqualToString:@"star"]){
        self.fav = [NSMutableString string];
    }else if([elementName isEqualToString:@"image"]){
        self.image = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElement isEqualToString:@"name"]) {
        [self.name appendString:string];
    }else if([self.currentElement isEqualToString:@"id"]){
        [self.chanelId appendString:string];
    }else if([self.currentElement isEqualToString:@"uri"]){
        [self.uri appendString:string];
    }else if([self.currentElement isEqualToString:@"star"]){
        [self.fav appendString:string];
    }else if([self.currentElement isEqualToString:@"image"]){
        [self.image appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"name"]) {
        [self.currentDic setObject:self.name forKey:@"title"];
        self.name = nil;
    }else if([elementName isEqualToString:@"uri"]) {
        [self.currentDic setObject:self.uri forKey:@"uri"];
        self.uri = nil;
    }else if([elementName isEqualToString:@"id"]) {
        [self.currentDic setObject:self.chanelId forKey:@"id"];
        self.chanelId = nil;
    }else if([elementName isEqualToString:@"star"]) {
        [self.currentDic setObject:self.fav forKey:@"star"];
        self.fav = nil;
    }else if([elementName isEqualToString:@"image"]) {
        [self.currentDic setObject:self.image forKey:@"image"];
        self.image = nil;
    }else if([elementName isEqualToString:@"channel"]){
        //отсюда currentDic возвращаем в List
        [self.list addElement:self.currentDic];
        self.chanelId = nil;
        self.currentDic = nil;
        self.currentElement = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Распарсено");
}


@end
