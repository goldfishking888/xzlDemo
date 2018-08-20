//
//  WBShareKit.h
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAsynchronousDataFetcher.h"
#import "OAToken.h"
#import "OAServiceTicket.h"
#import "WBShareKey.h"
#import "WBRequest.h"

@interface WBShareKit : NSObject<UIWebViewDelegate>
{
    SEL _successSEL;
    SEL _failSEL;
}
@property (nonatomic, retain) UIView *safariView;
+ (WBShareKit *)mainShare;
//- (void)setDelegate:(id)delegate;
- (void)handleOpenURL:(NSURL *)url;

#pragma mark sina
- (void)startSinaOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
//- (void)startSinaAccessWithVerifier:(NSString *)_ver;
- (void)sendSinaRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
- (void)sendSinaPhotoWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;

#pragma mark douban
- (void)startDoubanOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
//- (void)startDoubanAccess;
- (void)sendDoubanShuoWithStatus:(NSString *)_status delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;

#pragma mark tx
- (void)startTxOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
//- (void)startTxAccessWithVerifier:(NSString *)_ver;
- (void)sendTxRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng format:(NSString *)_format delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
- (void)sendTxRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng format:(NSString *)_format path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;

#pragma mark twitter
- (void)startTwitterOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
- (void)sendTwitterWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;

#pragma mark 163
- (void)startWyOauthWithSelector:(SEL)_sSel withFailedSelector:(SEL)_eSel;
- (void)sendWyRecordWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
- (void)sendWyPhotoWithStatus:(NSString *)_status lat:(double)_lat lng:(double)_lng path:(NSString *)_path delegate:(id)_delegate successSelector:(SEL)_sSel failSelector:(SEL)_eSel;
@end
