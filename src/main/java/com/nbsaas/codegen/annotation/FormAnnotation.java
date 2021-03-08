package com.nbsaas.codegen.annotation;


import java.lang.annotation.*;

@Target( {ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface FormAnnotation {
  
  String title() default "";

  String model() default "";

  String list() default "";
  
  String add() default "";
  
  String update() default "";

  String menu() default "";

  String searchWidth() default "80";

  String viewWidth() default "80";

}
