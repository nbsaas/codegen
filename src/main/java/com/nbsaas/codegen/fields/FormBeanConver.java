package com.nbsaas.codegen.fields;


import com.nbsaas.codegen.annotation.*;
import jodd.util.StringUtil;
import org.apache.commons.lang3.StringUtils;

import java.lang.reflect.Field;
import java.util.*;

public class FormBeanConver {

    // SearchItem
    public List<FieldBean> search(Class<?> object) {
        List<FieldBean> beans = new ArrayList<>();
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                f.setAccessible(true);
                SearchItem annotation = f.getAnnotation(SearchItem.class);
                if (annotation == null) {
                    continue;
                }
                FieldBean bean = new FieldBean();
                if (annotation == null) {
                    continue;
                }
                bean.setType(annotation.type().name());
                bean.setPlaceholder(annotation.placeholder());
                bean.setTitle(annotation.label());
                bean.setId(annotation.name());
                bean.setClassName(annotation.classType());
                bean.setKey(annotation.key());
                bean.setOperator(annotation.operator());
                Integer sortNum = getInteger(annotation);
                bean.setSortNum(sortNum);
                bean.setShow(annotation.show());
                if (StringUtils.isEmpty(bean.getTitle())) {
                    bean.setTitle(f.getName());
                }
                if (StringUtils.isEmpty(bean.getKey())) {
                    bean.setKey(f.getName());
                }
                if (StringUtils.isEmpty(bean.getId())) {
                    bean.setId(f.getName());
                }
                if (StringUtils.isEmpty(bean.getPlaceholder())) {
                    bean.setPlaceholder(bean.getTitle());
                }
                beans.add(bean);
            }
        }

        SearchBean bean = object.getAnnotation(SearchBean.class);
        if (bean != null) {
            SearchItem[] items = bean.items();
            if (items != null) {
                for (SearchItem item : items) {
                    FieldBean fieldBean = new FieldBean();
                    if (item == null) {
                        continue;
                    }
                    fieldBean.setType(item.type().name());
                    fieldBean.setPlaceholder(item.placeholder());
                    fieldBean.setTitle(item.label());
                    fieldBean.setId(item.name());
                    fieldBean.setClassName(item.classType());
                    fieldBean.setKey(item.key());
                    fieldBean.setOperator(item.operator());
                    fieldBean.setShow(item.show());
                    Integer sortNum = getInteger(item);
                    fieldBean.setSortNum(sortNum);
                    if (StringUtils.isEmpty(fieldBean.getKey())) {
                        fieldBean.setKey(fieldBean.getId());
                    }
                    if (StringUtils.isEmpty(fieldBean.getPlaceholder())) {
                        fieldBean.setPlaceholder("");
                    }
                    beans.add(fieldBean);
                }
            }
        }


        beans.sort(new Comparator<FieldBean>() {
            @Override
            public int compare(FieldBean o1, FieldBean o2) {
                return o1.getSortNum().compareTo(o2.getSortNum());
            }
        });
        return beans;
    }

    /**
     * 获取实体所有字段
     * @param object
     * @return
     */
    public Set<FieldBean> fields(Class<?> object) {
        Set<FieldBean> beans = new HashSet<>();
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                f.setAccessible(true);
                if (f.getName().equals("id")) {
                    continue;
                }
                NoHandle noHandle = f.getAnnotation(NoHandle.class);
                if (noHandle != null) {
                    continue;
                }
                FiledConvert convert = f.getAnnotation(FiledConvert.class);
                if (convert != null) {
                    FieldBean bean = new FieldBean();
                    bean.setId(f.getName());
                    bean.setType(convert.classType());
                    bean.setFieldType(2);
                    beans.add(bean);
                }

                if (f.getType().isEnum()) {
                    FieldBean bean = new FieldBean();
                    bean.setId(f.getName());
                    bean.setType(f.getType().getSimpleName());
                    bean.setFieldType(4);
                    beans.add(bean);
                    continue;
                }

                if (f.getType().getName().startsWith("java.lang")
                        || f.getType().getName().equals("int")
                        || f.getType().getName().equals("long")
                        || f.getType().getName().equals("float")
                        || f.getType().getName().equals("double")
                        || f.getType().getName().equals("Date")
                        || f.getType().getSimpleName().equals("BigDecimal")
                        || f.getType().getSimpleName().equals("Date")) {
                    FieldBean bean = new FieldBean();
                    bean.setId(f.getName());
                    bean.setType(f.getType().getSimpleName());
                    bean.setFieldType(1);
                    beans.add(bean);
                }
            }
        }
        return beans;
    }

    public Set<FieldBean> fieldsForSimple(Class<?> object) {
        return getFieldBeans(object, NoSimple.class);
    }

    public Set<FieldBean> fieldsForResponse(Class<?> object) {
        return getFieldBeans(object, NoResponse.class);
    }

    private Set<FieldBean> getFieldBeans(Class<?> object, Class annotation) {
        Set<FieldBean> beans = new HashSet<>();
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                f.setAccessible(true);
                if (f.getName().equals("id")) {
                    continue;
                }
                FiledConvert convert = f.getAnnotation(FiledConvert.class);
                if (convert != null) {
                    FieldBean bean = new FieldBean();
                    bean.setId(f.getName());
                    bean.setType(convert.classType());
                    bean.setFieldType(2);
                    beans.add(bean);
                }

                FiledName filedName = f.getAnnotation(FiledName.class);
                if (filedName != null) {
                    FieldBean bean = new FieldBean();
                    String parentName = filedName.name();
                    if (StringUtil.isNotBlank(parentName)) {
                        bean.setId(parentName);
                        bean.setExtName(parentName);
                    } else {
                        bean.setId(f.getName() + "Name");
                        bean.setExtName("Name");
                    }
                    bean.setParent(f.getName());
                    bean.setType(filedName.classType());
                    bean.setFieldType(3);
                    beans.add(bean);
                }

                if (f.getType().isEnum()) {
                    FieldBean bean = new FieldBean();
                    bean.setId(f.getName());
                    bean.setType(f.getType().getSimpleName());
                    bean.setFieldType(4);
                    beans.add(bean);
                }


                if (f.getType().getName().startsWith("java.lang")
                        || f.getType().getName().equals("int")
                        || f.getType().getName().equals("long")
                        || f.getType().getName().equals("float")
                        || f.getType().getName().equals("double")
                        || f.getType().getSimpleName().equals("BigDecimal")
                        || f.getType().getSimpleName().equals("Date")) {
                    if (f.getAnnotation(annotation) != null) {
                        continue;
                    }
                    FieldBean bean = new FieldBean();
                    bean.setId(f.getName());
                    bean.setType(f.getType().getSimpleName());
                    bean.setFieldType(1);
                    beans.add(bean);

                }
            }
        }
        return beans;
    }

    public FormBean converClass(Class<?> object) {
        FormBean formBean = new FormBean();
        List<FieldBean> beanList = formBean.getFields();
        FormAnnotation anno = object.getAnnotation(FormAnnotation.class);
        if (anno != null) {
            formBean.setTitle(anno.title());
            formBean.setAdd(anno.add());
            formBean.setUpdate(anno.update());
            formBean.setList(anno.list());
            formBean.setMenu(anno.menu());
            formBean.setViewWidth(anno.viewWidth());
            formBean.setSearchWidth(anno.searchWidth());
        }
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                f.setAccessible(true);
                if (f.getName().equals("id")) {
                    continue;
                }
                FormFieldAnnotation annotation = f.getAnnotation(FormFieldAnnotation.class);
                FieldBean bean = new FieldBean();
                if (annotation == null) {
                    continue;
                }

                if (f.getType().isEnum()) {
                    bean.setFieldType(4);
                    bean.setExtName("Name");
                } else {
                    bean.setFieldType(1);
                    bean.setExtName("");
                }
                FiledName filedName = f.getAnnotation(FiledName.class);
                if (filedName != null) {
                    bean.setFieldType(3);
                    bean.setExtName("Name");
                }
                bean.setWidth(annotation.width());
                bean.setClassName(annotation.className());
                bean.setId(annotation.id());
                if (bean.getId() == null) {
                    bean.setId(f.getName());
                }
                bean.setType(annotation.type().name());
                bean.setPlaceholder(annotation.placeholder());
                Integer sortNum = getInteger(annotation);
                bean.setSortNum(sortNum);
                bean.setTitle(annotation.title());
                bean.setCol(annotation.col() + "");
                bean.setRequired(annotation.required());
                bean.setOption(annotation.option());
                bean.setSort(annotation.sort());
                if (annotation.grid()) {
                    formBean.getGrids().add(bean);
                }
                if (StringUtils.isEmpty(bean.getTitle())) {
                    bean.setTitle(f.getName());
                }
                if (StringUtils.isEmpty(bean.getId())) {
                    bean.setId(f.getName());
                }
                if (StringUtils.isEmpty(bean.getPlaceholder())) {
                    bean.setPlaceholder(bean.getTitle());
                }
                if ("date".equals(bean.getType())) {
                    formBean.setHasDate(true);
                    formBean.getDates().add(bean);
                }
                if ("image".equals(bean.getType())) {
                    formBean.setHasImage(true);
                    formBean.getImages().add(bean);
                }
                if (annotation.ignore()) {
                    continue;
                }
                if (!beanList.contains(bean)) {
                    beanList.add(bean);
                }
            }
        }
        beanList.sort(new Comparator<FieldBean>() {
            @Override
            public int compare(FieldBean o1, FieldBean o2) {
                return o1.getSortNum().compareTo(o2.getSortNum());
            }
        });
        Collections.sort(formBean.getGrids());
        return formBean;
    }

    public FormBean conver(Object object) {
        return converClass(object.getClass());
    }

    private Integer getInteger(FormFieldAnnotation annotation) {
        Integer result = 0;
        String b = annotation.sortNum();
        try {
            result = Integer.parseInt(b);
        } catch (Exception e) {
            result = 0;
        }
        return result;
    }

    private Integer getInteger(SearchItem annotation) {
        Integer result = 0;
        String b = annotation.sortNum();
        try {
            result = Integer.parseInt(b);
        } catch (Exception e) {
            result = 0;
        }
        return result;
    }

    public Set<DaoBean> daoBeans(Class<?> object) {
        Set<DaoBean> beans = new HashSet<>();
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                f.setAccessible(true);
                if (f.getName().equals("id")) {
                    continue;
                }
                FiledConvert convert = f.getAnnotation(FiledConvert.class);
                if (convert != null) {
                    DaoBean bean = new DaoBean();
                    String dao = f.getType().getCanonicalName();
                    dao = dao.replace("entity", "dao") + "Dao";
                    bean.setDaoName(dao);
                    bean.setDao(f.getType().getSimpleName() + "Dao");
                    bean.setDaoField(f.getName());
                    beans.add(bean);
                }

            }
        }
        return beans;
    }

    public Set<EnumBean> enums(Class<?> object) {
        Set<EnumBean> beans = new HashSet<>();
        for (Class<?> clazz = object; clazz != Object.class; clazz = clazz.getSuperclass()) {
            Field[] fs = clazz.getDeclaredFields();
            for (Field f : fs) {
                f.setAccessible(true);
                if (f.getType().isEnum()) {
                    EnumBean bean = new EnumBean();
                    String dao = f.getType().getCanonicalName();
                    bean.setClassName(f.getType().getName());
                    bean.setField(f.getName());
                    beans.add(bean);
                }

            }
        }
        return beans;
    }

}
