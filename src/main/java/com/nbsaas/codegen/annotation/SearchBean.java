package com.nbsaas.codegen.annotation;

import java.lang.annotation.*;


@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface SearchBean {

    SearchItem[] items() default {};
}
