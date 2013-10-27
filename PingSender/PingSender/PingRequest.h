#import <MXi/MXi.h>

@interface PingRequest : MXiBean <MXiOutgoingBean>

@property (nonatomic, strong) NSString* content;

- (id)init;

@end