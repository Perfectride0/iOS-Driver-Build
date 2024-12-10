//
//  DSBarChart.m
//  DSBarChart
//
//  Created by DhilipSiva Bijju on 31/10/12.
//  Copyright (c) 2012 Tataatsu IdeaLabs. All rights reserved.
//

#import "DSBarChart.h"

@implementation DSBarChart
@synthesize color, numberOfBars, maxLen, refs, vals;

-(DSBarChart *)initWithFrame:(CGRect)frame
                       color:(UIColor *)theColor
                  references:(NSArray *)references
                   andValues:(NSArray *)values
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = theColor;
        self.vals = values;
        self.refs = references;
        self.backgroundColor = [UIColor redColor];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)calculate{
    self.numberOfBars = [self.vals count];
    for (NSNumber *val in vals) {
        float iLen = [val floatValue];
        if (iLen > self.maxLen) {
            self.maxLen = iLen;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    /// Drawing code
    [self calculate];
    self.numberOfBars = 7;
    float rectWidth = (float)(rect.size.width-(self.numberOfBars)) / (float)self.numberOfBars;
    float LBL_HEIGHT = 20.0f, iLen, x, heightRatio, height, y;
    
    /// Draw Bars
    for (int barCount = 0; barCount < self.numberOfBars; barCount++) {
        
        /// Calculate dimensions
        iLen = [[vals objectAtIndex:barCount] floatValue];
        x = barCount * (rectWidth);
        heightRatio = (self.maxLen == 0) ? 0 : iLen / self.maxLen;
        height = heightRatio * rect.size.height;
        if (height < 0.1f)
            height = 0.0f;
        y = rect.size.height - height - LBL_HEIGHT;
        
        /// Reference Label.
        UILabel *lblRef = [[UILabel alloc] initWithFrame:CGRectMake(barCount + x, rect.size.height - LBL_HEIGHT, rectWidth-10, LBL_HEIGHT)];
        lblRef.text = [refs objectAtIndex:barCount];
        lblRef.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:14];
        lblRef.adjustsFontSizeToFitWidth = TRUE;
        lblRef.textColor = self.color;
        [lblRef setTextAlignment:NSTextAlignmentCenter];
        lblRef.backgroundColor = [UIColor clearColor];
        [self addSubview:lblRef];
        UIButton *lblRefe = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *str = [NSString stringWithFormat:@"%0.2f", iLen];
        lblRefe.accessibilityHint = str;
        lblRefe.frame = CGRectMake(barCount + x, y, rectWidth-10, height);
        lblRefe.layer.cornerRadius = 3;
        lblRefe.tag = barCount;
        [lblRefe addTarget:self action:@selector(onChartTapped:) forControlEvents:UIControlEventTouchUpInside];
        lblRefe.backgroundColor = _inactiveBarColor;
        [self addSubview:lblRefe];
    }
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha {
  // Convert hex string to an integer
  unsigned int hexint = [self intFromHexString:hexStr];

  // Create a color object, specifying alpha as well
  UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    blue:((CGFloat) (hexint & 0xFF))/255
    alpha:alpha];

  return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr {
  unsigned int hexInt = 0;

  // Create scanner
  NSScanner *scanner = [NSScanner scannerWithString:hexStr];

  // Tell scanner to skip the # character
  [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

  // Scan hex value
  [scanner scanHexInt:&hexInt];

  return hexInt;
}


-(void)onChartTapped:(UIButton *)sender {
    for (UIView *i in self.subviews){
          if([i isKindOfClass:[UIButton class]]){
              UIButton *tappedBtn = (UIButton *)i;
                if(tappedBtn.tag == sender.tag){
                    /// Write your code
                    sender.backgroundColor = _activeBarColor;
                } else {
                    tappedBtn.backgroundColor = _inactiveBarColor;
                }
          }
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    
    // Already a Lbl Present Remove It
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            int a;
            for( a = 0; a < 7; a = a + 1 ) {
                NSString *str = [NSString stringWithFormat:@"%ld", (long)a];
                if (subview.accessibilityHint == str) {
                    [subview removeFromSuperview];
                }
            }
        }
      
    }
    NSString *currency = [[NSUserDefaults standardUserDefaults]
        stringForKey:@"user_currency_symbol_org_splash"];
    NSString *price = [NSString stringWithFormat:@" %@ %@ " , currency,sender.accessibilityHint];
    // Creating a Lbl For The Sender
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl1.center = sender.center;
    lbl1.backgroundColor = _activeBarColor;
    lbl1.userInteractionEnabled=NO;
    lbl1.text= price;
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:lbl1];
    lbl1.accessibilityHint = str;
    lbl1.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:14];
    lbl1.textColor = [UIColor whiteColor];
    lbl1.layer.cornerRadius = 5;
    lbl1.clipsToBounds = true;
    [lbl1.heightAnchor constraintEqualToConstant:40].active = YES;
    [lbl1.centerXAnchor constraintEqualToAnchor:sender.centerXAnchor].active = YES;
    [lbl1.bottomAnchor constraintEqualToAnchor:sender.topAnchor constant:-10].active = YES;

    [self.delegate chartViewTapped:sender.tag];
}

/// pivot
//    CGRect frame = CGRectZero;
//    frame.origin.x = rect.origin.x;
//    frame.origin.y = rect.origin.y - LBL_HEIGHT;
//    frame.size.height = LBL_HEIGHT;
//    frame.size.width = rect.size.width;
//    UILabel *pivotLabel = [[UILabel alloc] initWithFrame:frame];
//    pivotLabel.text = [NSString stringWithFormat:@"%d", (int)self.maxLen];
//    pivotLabel.backgroundColor = [UIColor clearColor];
//    pivotLabel.textColor = self.color;
//    [self addSubview:pivotLabel];
//    
//    /// A line
//    frame = rect;
//    frame.size.height = 1.0;
//    CGContextSetFillColorWithColor(context, self.color.CGColor);
//    CGContextFillRect(context, frame);


@end
