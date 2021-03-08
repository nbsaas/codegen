package com.nbsaas.codegen.handle.imple;

import com.nbsaas.codegen.annotation.ComposeView;
import com.nbsaas.codegen.handle.BeanHandle;
import org.apache.commons.chain.Context;

public class ComposeViewHandle implements BeanHandle {


    @Override
    public void handle(Class<?> object, Context context) {
        ComposeView view = object.getAnnotation(ComposeView.class);
        if (view == null) {
            context.put("childView", false);
        } else {
            context.put("childView", true);
        }

    }
}
