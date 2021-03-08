package com.nbsaas.codegen.handle.imple;

import com.nbsaas.codegen.annotation.CreateByUser;
import com.nbsaas.codegen.handle.BeanHandle;
import org.apache.commons.chain.Context;

public class CreateByUserHandle implements BeanHandle {
    @Override
    public void handle(Class<?> object, Context context) {
        CreateByUser view = object.getAnnotation(CreateByUser.class);
        if (view == null) {
            context.put("createByUser", false);
        } else {
            context.put("createByUser", true);
        }
    }
}
