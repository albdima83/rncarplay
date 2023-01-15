#import "RCTConvert+RNCarPlay.h"
#import <React/RCTConvert+CoreLocation.h>
#import <Availability.h>

@implementation RCTConvert (RNCarPlay)

RCT_ENUM_CONVERTER(CPTripEstimateStyle, (@{
                                           @"light": @(CPTripEstimateStyleLight),
                                           @"dark": @(CPTripEstimateStyleDark)
                                           }),
                                         CPTripEstimateStyleDark,
                                         integerValue)

RCT_ENUM_CONVERTER(CPPanDirection, (@{
                                      @"up": @(CPPanDirectionUp),
                                      @"right": @(CPPanDirectionRight),
                                      @"bottom": @(CPPanDirectionDown),
                                      @"left": @(CPPanDirectionLeft),
                                      @"none": @(CPPanDirectionNone),
                                      }), CPPanDirectionNone, integerValue)

+ (CPMapButton*)CPMapButton:(id)json withHandler:(void (^)(CPMapButton * _Nonnull mapButton))handler {
    CPMapButton *mapButton = [[CPMapButton alloc] initWithHandler:handler];

    if ([json objectForKey:@"image"]) {
        [mapButton setImage:[RCTConvert UIImage:json[@"image"]]];
    }

    if ([json objectForKey:@"focusedImage"]) {
        [mapButton setImage:[RCTConvert UIImage:json[@"focusedImage"]]];
    }

    if ([json objectForKey:@"disabled"]) {
        [mapButton setEnabled:![RCTConvert BOOL:json[@"disabled"]]];
    }

    if ([json objectForKey:@"hidden"]) {
        [mapButton setHidden:[RCTConvert BOOL:json[@"hidden"]]];
    }

    return mapButton;
}

+ (MKMapItem*)MKMapItem:(id)json {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([RCTConvert double:json[@"latitude"]], [RCTConvert double:json[@"longitude"]]);
    NSString *name = [RCTConvert NSString:json[@"name"]];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = name;
    return mapItem;
}

+ (CPRouteChoice*)CPRouteChoice:(id)json {
    return [[CPRouteChoice alloc] initWithSummaryVariants:[RCTConvert NSStringArray:json[@"additionalInformationVariants"]] additionalInformationVariants:[RCTConvert NSStringArray:json[@"selectionSummaryVariants"]] selectionSummaryVariants:[RCTConvert NSStringArray:json[@"summaryVariants"]]];
}

+ (CPPointOfInterest*)CPPointOfInterest:(id)json {
    MKMapItem *location = [RCTConvert MKMapItem:json[@"location"]];
    NSString *title = [RCTConvert NSString:json[@"title"]];
    NSString *subtitle = [RCTConvert NSString:json[@"subtitle"]];
    NSString *summary = [RCTConvert NSString:json[@"summary"]];
    NSString *detailTitle = [RCTConvert NSString:json[@"detailTitle"]];
    NSString *detailSubtitle = [RCTConvert NSString:json[@"detailSubtitle"]];
    NSString *detailSummary = [RCTConvert NSString:json[@"detailSummary"]];

    CPPointOfInterest *poi = [[CPPointOfInterest alloc] initWithLocation:location title:title subtitle:subtitle summary:summary detailTitle:detailTitle detailSubtitle:detailSubtitle detailSummary:detailSummary pinImage:nil];
    return poi;
}

+ (CPAlertActionStyle)CPAlertActionStyle:(NSString*) json {
    if ([json isEqualToString:@"cancel"]) {
        return CPAlertActionStyleCancel;
    } else if ([json isEqualToString:@"destructive"]) {
        return CPAlertActionStyleDestructive;
    }
    return CPAlertActionStyleDefault;
}

+ (UIImage *)UIImage:(id)json
{
  if (!json) {
    return nil;
  }
  
  __block UIImage *image;
  if (!RCTIsMainQueue()) {
    // It seems that none of the UIImage loading methods can be guaranteed
    // thread safe, so we'll pick the lesser of two evils here and block rather
    // than run the risk of crashing
    NSLog(@"Calling [RCTConvert UIImage:] on a background thread is not recommended");
    RCTUnsafeExecuteOnMainQueueSync(^{
      image = [self UIImage:json];
    });
    return image;
  }

  if ([json isMemberOfClass:[NSString class]]){
      NSLog(@"json is string");
      NSString *url_ = json;
      NSURL *url = [NSURL URLWithString:url_];
      if(url){
          NSString *scheme = url.scheme.lowercaseString;
          if ([scheme isEqualToString:@"file"]) {
              image = [UIImage imageWithContentsOfFile:url_];
          } else if ([scheme isEqualToString:@"data"]) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
          } else if ([scheme isEqualToString:@"http"]) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
          } else {
            RCTLogConvertError(json, @"an image. Only local files or data URIs are supported.");
            return nil;
          }
      }

  }

  return image;
}


@end
