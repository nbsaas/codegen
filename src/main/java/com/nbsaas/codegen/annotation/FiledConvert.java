package com.nbsaas.codegen.annotation;

import java.lang.annotation.*;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface FiledConvert {

    String classType() default "Long";

    String dao() default "";

}
