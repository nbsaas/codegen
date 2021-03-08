package com.nbsaas.codegen.handle.imple;

import com.nbsaas.codegen.annotation.FormFieldAnnotation;
import com.nbsaas.codegen.annotation.InputType;
import com.nbsaas.codegen.handle.BeanHandle;
import org.apache.commons.chain.Context;

import java.lang.reflect.Field;

public class CheckComponentHandle implements BeanHandle {
    @Override
    public void handle(Class<?> object, Context context) {
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                FormFieldAnnotation fieldBean=  f.getAnnotation(FormFieldAnnotation.class);
                if (fieldBean==null){
                    continue;
                }
                if (fieldBean.type() == InputType.image) {
                    context.put("componentState", true);
                    return;
                }
                if (fieldBean.type() == InputType.el_upload) {
                    context.put("componentState", true);
                    return;
                }
                if (fieldBean.type() == InputType.richText) {
                    context.put("componentState", true);
                    return;
                }
                if (fieldBean.type() == InputType.dictionary) {
                    context.put("componentState", true);
                    return;
                }
                if (fieldBean.type() == InputType.treeView) {
                    context.put("componentState", true);
                    return;
                }
            }
        }
        context.put("componentState", false);
    }
}
