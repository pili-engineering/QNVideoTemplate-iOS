//
//  QNVTPropertyModel.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTPropertyModel.h"

@implementation QNVTPropertyModel

- (NSArray<QNVTProperty*>*)properties {
    if (!_properties) {
        _properties = [NSMutableArray array];
    }
    return _properties;
}

- (void)appendProperty:(QNVTProperty*)property {
    if (self.properties.count == 0) {
        [(NSMutableArray*)self.properties addObject:property];
        [self update:property];
    } else {
        for (int i = 0; i < self.properties.count; i++) {
            if (property.value.inPoint <= self.properties[i].value.inPoint) {
                [(NSMutableArray*)self.properties insertObject:property atIndex:i];
                return;
            }
        }
        [(NSMutableArray*)self.properties addObject:property];
    }
}

- (void)update:(QNVTProperty*)property {
    switch (property.type) {
        case QNVTPropertyTypeImage: {
            _thumbnail = [UIImage downSampleWithPath:[(QNVTImageValue*)property.value imagePath] maxLength:150];
            QNVTImageValue* value = (QNVTImageValue*)property.value;
            _width = value.width;
            _height = value.height;
            break;
        }

        case QNVTPropertyTypeVideo: {
            _thumbnail = [UIImage getVideoPreViewImage:[(QNVTVideoValue*)property.value videoPath] maxLength:150];
            QNVTVideoValue* value = (QNVTVideoValue*)property.value;
            _width = value.width;
            _height = value.height;
            break;
        }

        default:
            break;
    }
}

- (float)fps {
    return _fps > 0 ? _fps : 25;
}

@end
