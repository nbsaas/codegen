package com.nbsaas.codegen.handle.imple;

import com.haoxuer.discover.data.annotations.FormAnnotation;
import com.nbsaas.codegen.handle.BeanHandle;
import org.apache.commons.chain.Context;

public class TitleHandle implements BeanHandle {
    @Override
    public void handle(Class<?> object, Context context) {

        FormAnnotation annotation = object.getAnnotation(FormAnnotation.class);
        if (annotation!=null){
            context.put("title",annotation.title());
            context.put("model",annotation.model());
        }
    }
}
