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

#import <objc/message.h>

#pragma mark - Category Primers
@interface AppDelegateAnalyze ()
+ (void)_changeAnalyzerStatus:(AnalyzerActionBlock)block;
@end
@interface UIViewControllerAnalyze ()
+ (void)_changeAnalyzerStatus:(AnalyzerActionBlock)block;
@end
@interface UIViewAnalyze ()
+ (void)_changeAnalyzerStatus:(AnalyzerActionBlock)block;
+ (void)_changeViewEventAnalyzerStatus:(AnalyzerActionBlock)block;
@end


#define GAAnalyzer_Lock dispatch_semaphore_wait([[NSAnalyzer shareAnalyzer] valueForKeyPath:@"_lock"], 1)
#define GAAnalyzer_UnLock dispatch_semaphore_signal([[NSAnalyzer shareAnalyzer] valueForKeyPath:@"_lock"])

NSString* const GAAnalyzerContentInfo = @"GAAnalyzerContentInfo";

NSString* const GAAnalyzerAppDelegateHandle = @"GAAnalyzerAppDelegateHandle";
NSString* const GAAnalyzerViewControllerHandle = @"GAAnalyzerViewControllerHandle";
NSString* const GAAnalyzerViewHandle = @"GAAnalyzerViewHandle";
NSString* const GAAnalyzerViewEventHandle = @"GAAnalyzerViewEventHandle";

static NSString* const keychainIndetifier = @"peter.gra.keychainIndetifier";
static NSMutableData* _mData;

__attribute__((constructor))
static void autoDataAnalyze(void){
    if (class_conformsToProtocol(objc_getClass("AppDelegate"), objc_getProtocol("NSAnalyzerRegistration")) &&
        class_getClassMethod(objc_getClass("AppDelegate"), @selector(AnalyzerRegisterInfo:))) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDictionary* dic = @{
                                  GAAnalyzerAppDelegateHandle           : @(NO),
                                  GAAnalyzerViewControllerHandle        : @(NO),
                                  GAAnalyzerViewHandle                  : @(NO),
                                  GAAnalyzerViewEventHandle             : @(NO),
                                  };
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:GAAnalyzerContentInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            objc_msgSend(objc_getClass("AppDelegate"),@selector(AnalyzerRegisterInfo:));
        });
    }
}


#pragma mark - NSAnalyzer
@interface NSAnalyzer ()
{
    NSDictionary<NSString *,AnalyzerActionBlock>* _handleBlocks;
    
    dispatch_semaphore_t _lock;
    NSDictionary* _curAnalyzeContent;
}
@end

@implementation NSAnalyzer

#pragma mark - Public 
+ (instancetype)shareAnalyzer{
    static NSAnalyzer* _shareAnalyzer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareAnalyzer = [[NSAnalyzer alloc] init];
        _shareAnalyzer -> _lock = dispatch_semaphore_create(1);
        _shareAnalyzer -> _curAnalyzeContent = @{
                                                 GAAnalyzerAppDelegateHandle        : @(NO),
                                                 GAAnalyzerViewControllerHandle     : @(NO),
                                                 GAAnalyzerViewHandle               : @(NO),
                                                 GAAnalyzerViewEventHandle          : @(NO),
                                                 };
    });
    return _shareAnalyzer;
}

- (void)registerAnalyzerBlocks:(NSDictionary<NSString *,AnalyzerActionBlock> *)blockDic{
    if (!blockDic || blockDic == (id)kCFNull) return;
    
    [NSAnalyzer shareAnalyzer] -> _handleBlocks = blockDic;
    if (blockDic[GAAnalyzerAppDelegateHandle]) {
        GAAnalyzer_Lock;
        [AppDelegateAnalyze _changeAnalyzerStatus:blockDic[GAAnalyzerAppDelegateHandle]];
        [self _changeAnalyzeStatu:GAAnalyzerAppDelegateHandle];
        GAAnalyzer_UnLock;
    }
    if (blockDic[GAAnalyzerViewControllerHandle]) {
        GAAnalyzer_Lock;
        [UIViewControllerAnalyze _changeAnalyzerStatus:blockDic[GAAnalyzerViewControllerHandle]];
        [self _changeAnalyzeStatu:GAAnalyzerViewControllerHandle];
        GAAnalyzer_UnLock;
    }
    if (blockDic[GAAnalyzerViewHandle]) {
        GAAnalyzer_Lock;
        [UIViewAnalyze _changeAnalyzerStatus:blockDic[GAAnalyzerViewHandle]];
        [self _changeAnalyzeStatu:GAAnalyzerViewHandle];
        GAAnalyzer_UnLock;
    }
    if (blockDic[GAAnalyzerViewEventHandle]) {
        GAAnalyzer_Lock;
        [UIViewAnalyze _changeViewEventAnalyzerStatus:blockDic[GAAnalyzerViewEventHandle]];
        [self _changeAnalyzeStatu:GAAnalyzerViewEventHandle];
        GAAnalyzer_UnLock;
    }
}

- (void)updateAnalyzeContentType:(AnalyzeContentType)analyzeContentType status:(BOOL)isAnalyze{
    NSArray<NSString* >* keys = [self _switchKeyWithEnum:analyzeContentType];
    if (keys == (id)kCFNull) [self _allSetting:isAnalyze];
    
    NSMutableDictionary* mDic = [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent.mutableCopy;
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        mDic[key] = @(isAnalyze);
    }];
    [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent = mDic.copy;
    return [self _update2AnalyzerSetting];
}

- (void)openAllAnalyze{
    return [self _allSetting:YES];
}
- (void)closeAllAnalyze{
    return [self _allSetting:NO];
}


#pragma mark - Property
- (BOOL)isAnalyzeApplication{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:GAAnalyzerContentInfo];
    return [dic[GAAnalyzerAppDelegateHandle] boolValue];
}
- (BOOL)isAnalyzeViewController{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:GAAnalyzerContentInfo];
    return [dic[GAAnalyzerViewControllerHandle] boolValue];
}
- (BOOL)isAnalyzeView{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:GAAnalyzerContentInfo];
    return [dic[GAAnalyzerViewHandle] boolValue];
}
- (BOOL)isAnalyzeViewEvent{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:GAAnalyzerContentInfo];
    return [dic[GAAnalyzerViewEventHandle] boolValue];
}


#pragma mark - Private

#pragma mark - Utils 

- (void)_update2AnalyzerSetting{
    NSDictionary* targetDic = [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent;
    NSDictionary* curDic    = [[NSUserDefaults standardUserDefaults] dictionaryForKey:GAAnalyzerContentInfo];
    NSDictionary* handleDic = [NSAnalyzer shareAnalyzer] -> _handleBlocks;
    if (targetDic || targetDic == (id)kCFNull)  return ;
    if (curDic || curDic == (id)kCFNull)        return ;
    if (handleDic || handleDic == (id)kCFNull)  return ;
    
    /** dynamic update **/
    if (handleDic[GAAnalyzerAppDelegateHandle] &&
        [curDic[GAAnalyzerAppDelegateHandle] boolValue] != [targetDic[GAAnalyzerAppDelegateHandle] boolValue]) {
        GAAnalyzer_Lock;
        [AppDelegateAnalyze _changeAnalyzerStatus:handleDic[GAAnalyzerAppDelegateHandle]];
        GAAnalyzer_UnLock;
    }
    if (handleDic[GAAnalyzerViewControllerHandle] &&
        [curDic[GAAnalyzerViewControllerHandle] boolValue] != [targetDic[GAAnalyzerViewControllerHandle] boolValue]) {
        GAAnalyzer_Lock;
        [UIViewControllerAnalyze _changeAnalyzerStatus:handleDic[GAAnalyzerViewControllerHandle]];
        GAAnalyzer_UnLock;
    }
    if (handleDic[GAAnalyzerViewHandle] &&
        [curDic[GAAnalyzerViewHandle] boolValue] != [targetDic[GAAnalyzerViewHandle] boolValue]) {
        GAAnalyzer_Lock;
        [UIViewAnalyze _changeAnalyzerStatus:handleDic[GAAnalyzerViewHandle]];
        GAAnalyzer_UnLock;
    }
    if (handleDic[GAAnalyzerViewEventHandle] &&
        [curDic[GAAnalyzerViewEventHandle] boolValue] != [targetDic[GAAnalyzerViewEventHandle] boolValue]) {
        GAAnalyzer_Lock;
        [UIViewAnalyze _changeViewEventAnalyzerStatus:handleDic[GAAnalyzerViewEventHandle]];
        GAAnalyzer_UnLock;
    }
    /** dynamic update **/

}

- (void)_allSetting:(BOOL)isOpen{
    NSMutableDictionary* mDic = [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent.mutableCopy;
    [[NSAnalyzer shareAnalyzer] -> _curAnalyzeContent enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        mDic[key] = @(isOpen);
    }];
    [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent = mDic.copy;
    return [self _update2AnalyzerSetting];
}

- (NSArray<NSString* >* )_switchKeyWithEnum:(AnalyzeContentType)analyzeType{
    if (analyzeType & AnalyzeContentTypeAll) return (id)kCFNull;
    
    NSMutableArray<NSString* >* mArr = @[].mutableCopy;
    if (analyzeType & AnalyzeContentTypeApplication) {
        [mArr addObject:GAAnalyzerAppDelegateHandle];
    }
    if (analyzeType & AnalyzeContentTypeViewController) {
        [mArr addObject:GAAnalyzerViewControllerHandle];
    }
    if (analyzeType & AnalyzeContentTypeView) {
        [mArr addObject:GAAnalyzerViewHandle];
    }
    if (analyzeType & AnalyzeContentTypeViewEvent) {
        [mArr addObject:GAAnalyzerViewEventHandle];
    }
    return mArr.copy;
}

- (void)_changeAnalyzeStatu:(NSString* )key{
    NSMutableDictionary* mDic = [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent.mutableCopy;
    BOOL b = [[NSAnalyzer shareAnalyzer] -> _curAnalyzeContent[key] boolValue];
    mDic[key] = @(!b);
    [NSAnalyzer shareAnalyzer] -> _curAnalyzeContent = mDic.copy;
}

@end


