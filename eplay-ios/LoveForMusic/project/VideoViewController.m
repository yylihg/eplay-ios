//
//  VideoViewController.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/8/14.
//  Copyright © 2017年 wbk. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "VideoViewController.h"
#import "ZFPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <ZFDownload/ZFDownloadManager.h>
#import "ZFDownloadManager.h"

@interface VideoViewController () <ZFPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoView;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *uploadName;
@property (weak, nonatomic) IBOutlet UILabel *uploadTime;
@property (weak, nonatomic) IBOutlet UITextView *videoDes;

@property(nonatomic, strong) ZFPlayerView * zfPlayerView;
@end

@implementation VideoViewController
@synthesize zfPlayerView;
@synthesize videoTitle;
@synthesize videoUrl;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getVideoUrl:self.videoUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/** 返回按钮事件 */
- (void)zf_playerBackAction{
    
}
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url{
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getVideoUrl:(NSString *)videoApi {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[Utils getUserInfo].accessToken forHTTPHeaderField:@"access-token"];
    [manager.requestSerializer setValue:[Utils getUserInfo].userToken forHTTPHeaderField:@"user-token"];
  
    [manager GET: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],videoApi ] parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"ihg videoUrl: %@ %@",responseObject, [responseObject objectForKey:@"code"] );
                NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
                if([code isEqualToString:@"0"]){
                    NSDictionary * videoObj = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
                    [self.videoName setText: [videoObj objectForKey:@"VIDEO_NAME"]];
                    [self.uploadName setText: [NSString stringWithFormat:@"上传人：%@", [videoObj objectForKey:@"UPLOAD_USER_NAME"]] ];
                    [self.uploadTime setText: [NSString stringWithFormat:@"上传时间：%@",  [videoObj objectForKey:@"UPLOAD_TIME"]]];
                    [self.videoDes setText: [NSString stringWithFormat:@"视频简介：%@",  [videoObj objectForKey:@"VIDEO_REMARK"]]];
                    [self playVideo: [videoObj objectForKey: @"VIDEO_URL"]];
                }
//                NSLog(@"ihg%@",[[responseObject objectForKey:@"errorMsg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                
             }
     ];
  
}


-(void)playVideo:(NSString *)url{;
    NSLog(@"ihg run %@", url);
    self.zfPlayerView = [[ZFPlayerView alloc] init];
    //    [self.videoView addSubview:self.zfPlayerView];
    //    [self.zfPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).offset(20);
    //        make.left.right.equalTo(self.view);
    //        // 这里宽高比16：9，可以自定义视频宽高比
    //        make.height.equalTo(self.zfPlayerView.mas_width).multipliedBy(9.0f/16.0f);
    //    }];
    
    // 初始化控制层view(可自定义)
    //    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    // 初始化播放模型
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.fatherView = self.videoView;
    playerModel.videoURL =
    [NSURL URLWithString: url];
    playerModel.title = self.videoTitle;
    [self.zfPlayerView playerControlView:nil playerModel:playerModel];
    //
    // 设置代理
    self.zfPlayerView.delegate = self;
    // 自动播放
    [self.zfPlayerView autoPlayTheVideo];
}

- (IBAction)back:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}
@end
