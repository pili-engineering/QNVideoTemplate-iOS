//
//  QnvtGeometry.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/3/2.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtGeometry_hpp
#define QnvtGeometry_hpp

#include <stdio.h>

namespace QNVT {

struct Size {
    float width, height;
    bool operator==(const Size& rhs) const;
    bool operator!=(const Size& rhs) const;
};

struct ISize {
    int width, height;
    bool operator==(const ISize& rhs) const;
    bool operator!=(const ISize& rhs) const;
};

struct Point {
    float x, y;
};

struct Rect {
    Point origin;
    Size size;
};

inline static Size MakeSize(float width, float height) {
    return {width, height};
}

inline static ISize MakeISize(int width, int height) {
    return {width, height};
}

} // namespace QNVT

#endif /* QnvtGeometry_hpp */
