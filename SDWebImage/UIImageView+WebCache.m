/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgress:(double)progress
{
    if (progress > 0) {
        UIProgressView *progressView = nil;
        
        // Check if allocated
        if ([self viewWithTag:SDWEBIMAGE_UIVIEW_PROGRESS_TAG] == nil)
        {
            float progressViewWidth = self.frame.size.width * SDWEBIMAGE_UIVIEW_PROGRESS_WIDTH;
            progressView = [[UIProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width - progressViewWidth) / 2,
                                                                           ((self.frame.size.height / 2) - (SDWEBIMAGE_UIVIEW_PROGRESS_HEIGHT / 2)),
                                                                           progressViewWidth,
                                                                           SDWEBIMAGE_UIVIEW_PROGRESS_HEIGHT)];
            progressView.tag = SDWEBIMAGE_UIVIEW_PROGRESS_TAG;
            [self addSubview:progressView];
        } else
        {
            progressView = (UIProgressView *)[self viewWithTag:SDWEBIMAGE_UIVIEW_PROGRESS_TAG];
        }
        progressView.progress = progress;
        
        // Check if done or not
        if (progress == 1)
        {
            [progressView removeFromSuperview];
        }
    }
}





@end
