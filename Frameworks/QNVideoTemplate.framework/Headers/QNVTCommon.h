//
//  QNVTCommon.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/26.
//  Copyright © 2020 李政勇. All rights reserved.
//

#define QNVTLOG_LEVEL_CLOSE 0
#define QNVTLOG_LEVEL_ERROR 1
#define QNVTLOG_LEVEL_WARNING 2
#define QNVTLOG_LEVEL_INFO 3
#define QNVTLOG_LEVEL_DEBUG 4

#ifdef __cplusplus
extern "C" {
#endif
void QNVTSetLicensePath(const char* licensePath);
void QNVTSetLogLevel(int level);
#ifdef __cplusplus
}
#endif
