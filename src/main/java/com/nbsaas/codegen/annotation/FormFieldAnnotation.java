package com.nbsaas.codegen.annotation;


import java.lang.annotation.*;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface FormFieldAnnotation {


    boolean ignore() default false;


    boolean grid() default false;

    String title() default "";

    String width() default "100";


    /**
     * 排序号
     *
     * @return
     */
    String sortNum() default "0";

    /**
     * 输入框类型
     *
     * @return
     */
    InputType type() default InputType.text;


    /**
     * 列表bootstrap栅格大小
     *
     * @return
     */
   ColType col() default ColType.col_none;

    /**
     * css类名
     *
     * @return
     */
    String className() default "form-control";

    /**
     * 数据框id
     *
     * @return
     */
    String id() default "";

    /**
     * 输入框提示信息
     *
     * @return
     */
    String placeholder() default "";

    /**
     * 是否是搜索字段
     *
     * @return
     */
    boolean search() default false;

    boolean required() default false;

    boolean sort() default  false;

    String option() default "";

}
