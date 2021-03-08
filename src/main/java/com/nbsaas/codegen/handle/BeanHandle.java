package com.nbsaas.codegen.handle;

import org.apache.commons.chain.Context;

public interface BeanHandle {

    void handle(Class<?> object, Context context);
}
