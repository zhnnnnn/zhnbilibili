//
//  WTKAutoHighLightLabel.m
//  WTKAutoHighlightedLabelDemo
//
//  Created by 王同科 on 2016/11/24.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAutoHighLightLabel.h"
#import <CoreText/CoreText.h>

///若要修改判定方法，修改此处
#define URLRegular @"((http|ftp|https|Http|Http)://)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\&%_\./-~-]*)?"
#define EmojiRegular @"(\\[\\w+\\])"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{1,30}"
#define TopicRegular @"#[^#]+#"

@interface WTKAutoHighLightLabel ()

@property(nonatomic,strong)NSMutableDictionary *highRangeDic;

@property(nonatomic,copy)NSString *selectedStr;

@property(nonatomic,copy)NSMutableAttributedString *w_mString;

@end

@implementation WTKAutoHighLightLabel{
    NSString *w_text;
    NSMutableDictionary *highDic;
    BOOL    isHighLighted;
    NSRange currentRange;

}

- (void)wtk_setText:(NSString *)text
{
    [self wtk_setText:text withClickBlock:self.clickBlock];
}
- (void)wtk_setText:(NSString *)text withClickBlock:(void (^)(NSString *))clickBlock
{
    [self wtk_setText:text highLightedColor:self.w_highColor withClickBlock:clickBlock];
}
- (void)wtk_setText:(NSString *)text highLightedColor:(UIColor *)highColor withClickBlock:(void (^)(NSString *))clickBlock
{
    [self wtk_setText:text highLightedColor:highColor withNormalColor:self.w_normalColor withClickBlock:clickBlock];
}
- (void)wtk_setText:(NSString *)text highLightedColor:(UIColor *)highColor withNormalColor:(UIColor *)normalColor withClickBlock:(void (^)(NSString *))clickBlock
{
    [self wtk_setText:text highLightedColor:highColor withNormalColor:normalColor withSelectedColor:self.w_selectedColor withClickBlock:clickBlock];
}
- (void)wtk_setText:(NSString *)text highLightedColor:(UIColor *)highColor withNormalColor:(UIColor *)normalColor withSelectedColor:(UIColor *)selectedColor withClickBlock:(void (^)(NSString *))clickBlock
{
    w_text = text;
    self.w_highColor = highColor;
    self.w_normalColor = normalColor;
    self.w_selectedColor = selectedColor;
    if (clickBlock || self.clickBlock)
    {
        self.clickBlock = clickBlock ? clickBlock : self.clickBlock;
        self.userInteractionEnabled = YES;
        highDic = @{}.mutableCopy;
    }
    if (highDic)
    {
        [highDic removeAllObjects];
    }
    if (self.highRangeDic) {
        [self.highRangeDic removeAllObjects];
    }
    if (!isHighLighted) {
        currentRange = NSMakeRange(-1, -1);
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : self.font,NSForegroundColorAttributeName : normalColor}];
    [string addAttribute:(NSString *)kCTForegroundColorAttributeName value:normalColor range:NSMakeRange(0, text.length)];
    NSMutableAttributedString *maString = [self highlightText:string];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)maString);
    
    [self drawFramesetter:framesetter attributedString:string textRange:CFRangeMake(0, string.length) inRect:CGRectMake(0, 5, self.frame.size.width, self.frame.size.height) context:nil];
    self.attributedText = maString;
    
    
}
- (void)setW_range:(NSRange)w_range
{
    _w_range = w_range;
    if (w_text.length > w_range.location + w_range.length)
    {
        [self wtk_setText:w_text];
    }
    else
    {
        NSLog(@"越界");
    }
    
}

- (NSMutableAttributedString *)highlightText:(NSMutableAttributedString *)coloredString{
    NSString* string = coloredString.string;
    NSRange range = NSMakeRange(0,[string length]);
    for(NSString* expression in self.ruleArray) {
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for(NSTextCheckingResult* match in matches) {
           
            self.highRangeDic[NSStringFromRange(match.range)] = @1;
            if (currentRange.location != -1 && currentRange.location >= match.range.location && currentRange.length + currentRange.location <= match.range.length + match.range.location)
            {
                 [coloredString addAttribute:NSForegroundColorAttributeName value:self.w_selectedColor range:match.range];
                self.selectedStr = [coloredString attributedSubstringFromRange:match.range].string;
            }
            else
            {
                 [coloredString addAttribute:NSForegroundColorAttributeName value:self.w_highColor range:match.range];
            }
        }
    }
    if (self.w_range.location != NSNotFound)
    {
        self.highRangeDic[NSStringFromRange(self.w_range)] = @1;
        if (currentRange.location != -1 && currentRange.location >= self.w_range.location && currentRange.length + currentRange.location <= self.w_range.length + self.w_range.location)
        {
            [coloredString addAttribute:NSForegroundColorAttributeName value:self.w_selectedColor range:self.w_range];
            self.selectedStr = [coloredString attributedSubstringFromRange:self.w_range].string;
        }
        else
        {
            [coloredString addAttribute:NSForegroundColorAttributeName value:self.w_highColor range:self.w_range];
        }
    }
    return coloredString;
}

- (void)drawFramesetter:(CTFramesetterRef)framesetter
       attributedString:(NSAttributedString *)attributedString
              textRange:(CFRange)textRange
                 inRect:(CGRect)rect
                context:(CGContextRef)context
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, ![self.backgroundColor isEqual:[UIColor clearColor]], 0);
    context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = CFArrayGetCount(lines);
    BOOL truncateLastLine = NO;//tailMode
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        lineOrigin = CGPointMake((lineOrigin.x), (lineOrigin.y));
        
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        CGFloat descent = 0.0f;
        CGFloat ascent = 0.0f;
        CGFloat lineLeading;
        CTLineGetTypographicBounds((CTLineRef)line, &ascent, &descent, &lineLeading);
        
        // Adjust pen offset for flush depending on text alignment
        CGFloat flushFactor = NSTextAlignmentLeft;
        CGFloat penOffset;
        CGFloat y;
        if (lineIndex == numberOfLines - 1 && truncateLastLine) {
            // Check if the range of text in the last line reaches the end of the full attributed string
            CFRange lastLineRange = CTLineGetStringRange(line);
            
            if (!(lastLineRange.length == 0 && lastLineRange.location == 0) && lastLineRange.location + lastLineRange.length < textRange.location + textRange.length) {
                // Get correct truncationType and attribute position
                CTLineTruncationType truncationType = kCTLineTruncationEnd;
                CFIndex truncationAttributePosition = lastLineRange.location;
                
                NSString *truncationTokenString = @"\u2026";
                
                NSDictionary *truncationTokenStringAttributes = [attributedString attributesAtIndex:(NSUInteger)truncationAttributePosition effectiveRange:NULL];
                
                NSAttributedString *attributedTokenString = [[NSAttributedString alloc] initWithString:truncationTokenString attributes:truncationTokenStringAttributes];
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributedTokenString);
                
                // Append truncationToken to the string
                // because if string isn't too long, CT wont add the truncationToken on it's own
                // There is no change of a double truncationToken because CT only add the token if it removes characters (and the one we add will go first)
                NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange((NSUInteger)lastLineRange.location, (NSUInteger)lastLineRange.length)] mutableCopy];
                if (lastLineRange.length > 0) {
                    // Remove any newline at the end (we don't want newline space between the text and the truncation token). There can only be one, because the second would be on the next line.
                    unichar lastCharacter = [[truncationString string] characterAtIndex:(NSUInteger)(lastLineRange.length - 1)];
                    if ([[NSCharacterSet newlineCharacterSet] characterIsMember:lastCharacter]) {
                        [truncationString deleteCharactersInRange:NSMakeRange((NSUInteger)(lastLineRange.length - 1), 1)];
                    }
                }
                [truncationString appendAttributedString:attributedTokenString];
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                

                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                if (!truncatedLine) {
                    truncatedLine = CFRetain(truncationToken);
                }
                
                penOffset = (CGFloat)CTLineGetPenOffsetForFlush(truncatedLine, flushFactor, rect.size.width);
                y = lineOrigin.y - descent - self.font.descender;
                CGContextSetTextPosition(context, penOffset, y);
                
                CTLineDraw(truncatedLine, context);
                
                CFRelease(truncatedLine);
                CFRelease(truncationLine);
                CFRelease(truncationToken);
            } else {
                penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, rect.size.width);
                y = lineOrigin.y - descent - self.font.descender;
                CGContextSetTextPosition(context, penOffset, y);
                CTLineDraw(line, context);
            }
        } else {
            penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, rect.size.width);
            y = lineOrigin.y - descent - self.font.descender;
            CGContextSetTextPosition(context, penOffset, y);
            CTLineDraw(line, context);
        }
        if ((!isHighLighted&&self.superview!=nil)) {
            CFArrayRef runs = CTLineGetGlyphRuns(line);
            for (int j = 0; j < CFArrayGetCount(runs); j++) {
                CGFloat runAscent;
                CGFloat runDescent;
                CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                if (highDic!=nil) {
                    CFRange range = CTRunGetStringRange(run);
                    CGRect runRect;
                    runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                    float offset = CTLineGetOffsetForStringIndex(line, range.location, NULL);
                    float height = runAscent;
                    float w_y = (self.frame.size.height - numberOfLines * height - (numberOfLines - 1) * runDescent) / 2.0 + lineIndex * (height + runDescent);
//                    runRect=CGRectMake(lineOrigin.x + offset, (self.frame.size.height+5)-y-height+runDescent/2, runRect.size.width, height);
                    runRect=CGRectMake(lineOrigin.x + offset, w_y, runRect.size.width, height);
                    NSRange nRange = NSMakeRange(range.location, range.length);
                    for (NSString *key in self.highRangeDic.allKeys)
                    {
                        NSRange oRange = NSRangeFromString(key);
                        if (nRange.location >= oRange.location && nRange.length + nRange.location <= oRange.location + oRange.length) {
                            [highDic setValue:[NSValue valueWithCGRect:runRect] forKey:NSStringFromRange(nRange)];
                        }
                    }
//                    if (self.highRangeDic[NSStringFromRange(nRange)])
//                    {
//                        
//                    }
                }
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
}

- (void)showHighLightedWord
{
    isHighLighted = YES;
    [self wtk_setText:w_text];
}

- (void)showNormalWord
{
    isHighLighted = NO;
    [self wtk_setText:w_text];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    for (NSString *key in highDic.allKeys)
    {
        CGRect frame = [highDic[key] CGRectValue];
        if (CGRectContainsPoint(frame, location))
        {
            NSRange range = NSRangeFromString(key);
            range = NSMakeRange(range.location, range.length - 1);
            currentRange = range;
            [self showHighLightedWord];
        }
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (isHighLighted)
    {
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf showNormalWord];
            if (weakSelf.selectedStr && weakSelf.clickBlock)
            {
                weakSelf.clickBlock(weakSelf.selectedStr);
            }
        });
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (isHighLighted)
    {
        [self showNormalWord];
    }
}

#pragma mark - lazyLoad
- (UIColor *)w_highColor
{
    if (!_w_highColor)
    {
        _w_highColor = [UIColor blueColor];
    }
    return _w_highColor;
}
- (UIColor *)w_normalColor
{
    if (!_w_normalColor)
    {
        _w_normalColor = [UIColor colorWithRed:30 / 255.0 green:30 / 255.0 blue:30 / 255.0 alpha:1];
    }
    return _w_normalColor;
}
- (UIColor *)w_selectedColor
{
    if (!_w_selectedColor)
    {
        _w_selectedColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
    }
    return _w_selectedColor;
}
- (NSMutableDictionary *)highRangeDic
{
    if (!_highRangeDic)
    {
        _highRangeDic = @{}.mutableCopy;
    }
    return _highRangeDic;
}
- (NSMutableArray *)ruleArray
{
    if (!_ruleArray)
    {
        _ruleArray = @[URLRegular,EmojiRegular,AccountRegular,TopicRegular].mutableCopy;
    }
    return _ruleArray;
}


@end
