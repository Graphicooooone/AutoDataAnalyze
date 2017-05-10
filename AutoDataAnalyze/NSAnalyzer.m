//
//  NSAnalyzer.m
//  Genius_IM
//
//  Created by Peter Gra on 2017/5/7.
//  Copyright © 2017年 Graphic-one. All rights reserved.
//

#import "NSAnalyzer.h"
#import "GAKeychainHelper.h"

#import "AppDelegateAnalyze.h"
#import "UIViewControllerAnalyze.h"
#import "UIViewAnalyze.h"

#pragma mark - Category Primers
@interface AppDelegateAnalyze ()
+ (void)_changeAnalyzerStatus;
@end

@interface UIViewControllerAnalyze ()
+ (void)_changeAnalyzerStatus;
@end
@interface UIViewAnalyze ()
+ (void)_changeAnalyzerStatus;
@end


static NSString* const keychainIndetifier = @"peter.gra.keychainIndetifier";
static NSMutableData* _mData;

__attribute__((constructor))
static void autoDataAnalyze(void){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSAnalyzer* anlyzer = [NSAnalyzer shareAnalyzer];
    });
}


#define GAAnalyzer_Lock
#define GAAnalyzer_UnLock

static NSString* const NSAnalyzerApplicationLifeCycle           = @"Application_LifeCycle";
static NSString* const NSAnalyzerViewControllerLifeCycle        = @"ViewController_LifeCycle";
static NSString* const NSAnalyzerViewLifeCycle                  = @"View_LifeCycle";
static NSString* const NSAnalyzerViewEvent                      = @"View_Event";

#pragma mark - NSAnalyzer
@interface NSAnalyzer ()
{
    dispatch_semaphore_t _lock;
    NSDictionary* _curAnalyzeContent;
    NSDictionary* _curAnalyzeConfig;
}
@end

@implementation NSAnalyzer

#pragma mark - Public 
+ (instancetype)shareAnalyzer{
    static NSAnalyzer* _shareAnalyzer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareAnalyzer = [[NSAnalyzer alloc] init];
        _shareAnalyzer -> _curAnalyzeContent = [self _analyzeContentInfo];
        _shareAnalyzer -> _curAnalyzeConfig = [self _analyzeConfigInfo];
        _shareAnalyzer -> _lock = dispatch_semaphore_create(1);
    });
    return _shareAnalyzer;
}

- (void)updateAnalyzeContentType:(AnalyzeContentType)analyzeContentType status:(BOOL)isAnalyze{
    
}
- (void)openAllAnalyze{
    [self _allSetting:YES];
}
- (void)closeAllAnalyze{
    [self _allSetting:NO];
}


#pragma mark - Property
- (BOOL)isAnalyzeApplication{
    return [[NSAnalyzer shareAnalyzer]->_curAnalyzeConfig[NSAnalyzerApplicationLifeCycle] boolValue];
}
- (BOOL)isAnalyzeViewController{
    return [[NSAnalyzer shareAnalyzer]->_curAnalyzeConfig[NSAnalyzerViewControllerLifeCycle] boolValue];
}
- (BOOL)isAnalyzeView{
    return [[NSAnalyzer shareAnalyzer]->_curAnalyzeConfig[NSAnalyzerViewLifeCycle] boolValue];
}
- (BOOL)isAnalyzeViewEvent{
    return [[NSAnalyzer shareAnalyzer]->_curAnalyzeConfig[NSAnalyzerViewEvent] boolValue];
}

#pragma mark - Private


#pragma mark - Utils 
+ (void)_handleData{
    
}

#pragma mark - lazy load 
- (void)_allSetting:(BOOL)isOpen{
    
}

+ (NSDictionary* )_curConfig{
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:[self _configurationFilePath]];
    dic = dic[@"Configuration"];
    return dic;
}

+ (NSDictionary* )_analyzeConfigInfo{
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:[self _configurationFilePath]];
    dic = dic[@"Configuration"];
    return dic;
}

+ (NSDictionary* )_analyzeContentInfo{
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:[self _configurationFilePath]];
#ifdef DEBUG
    dic = dic[@"Debug"];
#else
    dic = dic[@"Release"];
#endif
    return dic;
}

+ (NSString* )_analyzeFilePath{
    NSString* cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString* key = [GAKeychainHelper secretKeyWithIndentifier:keychainIndetifier.MD5_Value];
    if (!key) {
        key = [NSUUID UUID].UUIDString;
        [GAKeychainHelper saveSecretKeyWithIndentifier:keychainIndetifier.MD5_Value secretKey:key];
    }
    return [NSString stringWithFormat:@"%@/%@",cachePath,keychainIndetifier.MD5_Value];
}

+ (NSString* )_configurationFilePath{
    return [[NSBundle mainBundle] pathForResource:@"GA_AnalyzeConfiguration" ofType:@"plist"];
}
@end
