//
//  MonitorTelephoneStatus.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 18/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import "MonitorTelephoneStatus.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@implementation MonitorTelephoneStatus
//- (BOOL)MonitorTelephoneStatus
//{
//    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
//    callCenter.callEventHandler=^(CTCall* call){
//        
//        if (call.callState == CTCallStateDialing){
//            NSLog(@"Call Dialing");
//        }
//        
//        if (call.callState == CTCallStateConnected){
//            NSLog(@"Call Connected");
//            [self performSelectorOnMainThread:@selector(closeTalk) withObject:nil waitUntilDone:YES];
//        }
//        if (call.callState == CTCallStateDisconnected){
//            [self performSelectorOnMainThread:@selector(closeTalk) withObject:nil waitUntilDone:YES];
//            NSLog(@"Call Disconnected");
//        }
//    };
//}

- (void) callBack{
    NSLog(@"呼叫");
    NSString *number = @"10086";
    //    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    //实现呼叫之后到app中
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    UIWebView *  phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler=^(CTCall* call)
    {
        
        if (call.callState == CTCallStateDisconnected)
        {
            NSLog(@"Call has been disconnected");
        }
        else if (call.callState == CTCallStateConnected)
        {
            NSLog(@"Call has just been connected");
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            NSLog(@"Call is incoming");
            //self.viewController.signalStatus=NO;
        }
        
        else if (call.callState ==CTCallStateDialing)
        {
            NSLog(@"call is dialing");
        }
        else
        {
            NSLog(@"Nothing is done");
        }
    };
    
}
@end
