#import <MXi/MXi.h>

@interface PingResponse : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) NSString* content;

- (id)init;

@end