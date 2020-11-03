//
//  AepContext.hpp
//  QnvtCore
//
//  Created by 李政勇 on 2020/2/25.
//  Copyright © 2020 Hermes. All rights reserved.
//

#ifndef QnvtGLContext_hpp
#define QnvtGLContext_hpp

#include <functional>
#include <stdio.h>

namespace QNVT {
class ThreadPool;
class PrivData;
class GLContext {
public:
    virtual ~GLContext();

    virtual void makeCurrent() = 0;
    virtual void present() = 0;

    void runSyncOnContextQueue(std::function<void()> func);
    void runAsyncOnContextQueue(std::function<void()> func);
    void cleanContextQueue(); // clean the tasks in queue, be careful to use it;

    bool initialized() { return mInitialized; }

    auto getPrivData() const -> PrivData&;
    void setQueueName(const std::string& name);

protected:
    GLContext();
    void didCreateGLContext(bool success); // call after create glcontext

private:
    std::shared_ptr<PrivData> mPrivateData;
    std::unique_ptr<ThreadPool> mPool;
    bool mInitialized = false;
};

class GLContextFactory {
public:
    virtual std::unique_ptr<GLContext> createContext() = 0;
    virtual std::unique_ptr<GLContext> createContext(const GLContext& sharedContext) = 0;

    virtual ~GLContextFactory() = default;
};

class GLContextMgr {
public:
    static void setFactory(std::unique_ptr<GLContextFactory> factory);
    static std::unique_ptr<GLContext> CreateContext();
    static std::unique_ptr<GLContext> CreateContext(const GLContext& sharedContext);
};

} // namespace QNVT

#endif /* QnvtGLContext_hpp */
