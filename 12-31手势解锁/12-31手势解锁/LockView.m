//
//  LockView.m
//  12-31手势解锁
//
//  Created by apple on 14-12-31.
//  Copyright (c) 2014年 Ai. All rights reserved.
//

#import "LockView.h"
@interface LockView()
@property (nonatomic,strong)NSMutableArray *selectedBtnArray;
@property (nonatomic,assign)CGPoint curPoint;
@end
@implementation LockView
// 148  375 400

- (NSMutableArray *)selectedBtnArray
{
    if (_selectedBtnArray == nil)
    {
        _selectedBtnArray = [NSMutableArray array];
    }
    return _selectedBtnArray;
}



- (void)awakeFromNib
{
    
    CGFloat btnW = 74;
    int cols = 3;
    CGFloat margin = (self.bounds.size.width - cols * btnW)/4;
    for (int i = 0; i < 9; i++)
    {
        int row = i / cols;
        int col = i % cols;
        CGFloat btnX = margin + (margin + btnW) * col;
        CGFloat btnY = (margin + btnW) * row;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnW);
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        btn.tag = i;
    }
}
// 抽出相同的代码
- (CGPoint)pointWithTouch:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return  [touch locationInView:self];
}

- (void)dealWithPoint:(CGPoint)pos
{
    for (UIButton *btn in self.subviews )
    {
        if (CGRectContainsPoint(btn.frame, pos))
        {
            if (btn.selected) return;
            btn.selected = YES;
            [self.selectedBtnArray addObject:btn];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [self pointWithTouch:touches];
    [self dealWithPoint:pos];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
     CGPoint pos = [self pointWithTouch:touches];
    [self dealWithPoint:pos];

    // 设置数组存储当前移动手指触摸到的点
    _curPoint = pos;
    [self setNeedsDisplay];
    
}
// 触摸结束。清空当前按钮线段
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableString *strPwd = [NSMutableString string];
    for (UIButton *btn in self.selectedBtnArray) {
        [strPwd appendString:[NSString stringWithFormat:@"%ld",btn.tag]];
        btn.selected = NO;
    }
    //NSLog(@"-----%@",strPwd);
    [self.selectedBtnArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.selectedBtnArray.count == 0) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (UIButton *btn  in self.selectedBtnArray)
    {
        if (btn == self.selectedBtnArray[0])
        {
            [path moveToPoint:btn.center];
        }
        else
        {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_curPoint];
    path.lineWidth = 10;
    [[UIColor greenColor]set];
    path.lineJoinStyle = kCGLineCapRound;
    [path stroke];
}

@end
