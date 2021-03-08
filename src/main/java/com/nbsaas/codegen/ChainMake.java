package com.nbsaas.codegen;

import com.nbsaas.codegen.fields.FieldBean;
import com.nbsaas.codegen.fields.FormBean;
import com.nbsaas.codegen.fields.FormBeanConver;
import com.nbsaas.codegen.handle.BeanHandle;
import com.nbsaas.codegen.template.hibernate.TemplateHibernateDir;
import com.nbsaas.codegen.templates.ace.TemplateAceDir;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.persistence.Entity;
import javax.persistence.Id;

import com.nbsaas.codegen.command.*;
import org.apache.commons.chain.Chain;
import org.apache.commons.chain.Context;
import org.apache.commons.chain.impl.ChainBase;
import org.apache.commons.chain.impl.ContextBase;
import org.reflections.ReflectionUtils;
import org.reflections.Reflections;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ChainMake {

    private Logger logger = LoggerFactory.getLogger("imake");

    private File view;

    private boolean isAction = true;
    private boolean isDao = true;
    private boolean isService = false;
    private boolean isView = true;
    private boolean isSo = false;
    private boolean isRest = false;
    private String base;
    private String api;

    private boolean isApi = true;
    /**
     * 菜单编号
     */
    private String menus;


    private Class<?> dir;

    private Class<?> codeDir;

    private Map<String, Object> attributes = new HashMap<>();

    public boolean isSo() {
        return isSo;
    }

    public boolean isRest() {
        return isRest;
    }

    public void setRest(boolean rest) {
        isRest = rest;
    }

    public boolean isApi() {
        return isApi;
    }

    public void setApi(boolean api) {
        isApi = api;
    }

    public ChainMake(Class<?> dir, Class<?> codeDir) {
        super();
        this.dir = dir;
        this.codeDir = codeDir;
    }

    public ChainMake() {
        super();
        this.dir = TemplateAceDir.class;
        this.codeDir = TemplateHibernateDir.class;
    }

    public void put(String key, Object value) {
        this.attributes.put(key, value);
    }

    public boolean isAction() {
        return isAction;
    }

    public void setAction(boolean isAction) {
        this.isAction = isAction;
    }

    public boolean isDao() {
        return isDao;
    }

    public void setDao(boolean isDao) {
        this.isDao = isDao;
    }

    public boolean isService() {
        return isService;
    }

    public void setService(boolean isService) {
        this.isService = isService;
    }

    public boolean isView() {
        return isView;
    }

    public void setView(boolean isView) {
        this.isView = isView;
    }

    public void setSo(boolean isSo) {
        this.isSo = isSo;
    }


    public File getView() {
        return view;
    }

    public void setView(File view) {
        this.view = view;
    }

    private String action;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public void clear(Class<?> entity) {
        Chain chain = new ChainBase();
        chain.addCommand(new ClearCommand());
        if (this.base == null) {
            String name = entity.getName();
            int len = name.indexOf("data.entity");
            this.base = name.substring(0, len - 1);
            this.action = this.base + ".controller.admin";
            this.api = this.base;
        }
        try {
            Context contex = makeContext(entity);
            chain.execute(contex);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void make(Class<?> entity) {
        // TODO Auto-generated method stub
        Chain chain = new ChainBase();
        chain.addCommand(new DaoCommand());
        chain.addCommand(new ManagerCommand());
        chain.addCommand(new SoCommand());
        chain.addCommand(new ActionCommand());
        chain.addCommand(new RouterPageCommand());
        chain.addCommand(new RestCommand());
        if (this.base == null) {
            String name = entity.getName();
            int len = name.indexOf("data.entity");
            this.base = name.substring(0, len - 1);
            this.action = this.base + ".controller.admin";
            this.api = this.base;
        }
        try {
            Context contex = makeContext(entity);
            chain.execute(contex);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @SuppressWarnings("unchecked")
    private Context makeContext(Class<?> entity) {
        FormBean formBean = new FormBeanConver().converClass(entity);
        this.menus = formBean.getMenu();
        Context context = new ContextBase();
        context.put("entity", entity);
        context.put("action", action);
        context.put("api", api);
        context.put("base", base);
        URL entityUrl = entity.getResource(".");
        if (entityUrl != null) {
            File entityPath = new File(entityUrl.getFile());
            context.put("basedir", entityPath.getParentFile());
        } else {
            logger.info("实体路径不存在");
        }
        context.put("config_entity", entity.getSimpleName().toLowerCase());
        context.put("view", view);
        context.put("isAction", isAction);
        context.put("isDao", isDao);
        context.put("isService", isService);
        context.put("isView", isView);
        context.put("isSo", isSo);
        context.put("dir", dir);
        context.put("menus", menus);
        context.put("codeDir", codeDir);
        context.put("bean", formBean);
        context.put("requests", new FormBeanConver().fields(entity));

        context.put("daoList", new FormBeanConver().daoBeans(entity));
        context.put("enumList", new FormBeanConver().enums(entity));
        Set<FieldBean> simples = new FormBeanConver().fieldsForSimple(entity);
        if (simples != null) {
            Long count = simples.stream().filter(item -> item.getType().equals("BigDecimal")).count();
            if (count > 0) {
                context.put("haveBigDecimal", true);
            } else {
                context.put("haveBigDecimal", false);
            }

            Long dateCount = simples.stream().filter(item -> item.getType().equals("Date")).count();
            if (dateCount > 0) {
                context.put("haveDate", true);
            } else {
                context.put("haveDate", false);
            }
        } else {
            context.put("haveBigDecimal", false);
            context.put("haveDate", false);
        }
        context.put("simples", new FormBeanConver().fieldsForSimple(entity));
        context.put("responses", new FormBeanConver().fieldsForResponse(entity));
        List<FieldBean> searchs = new FormBeanConver().search(entity);
        context.put("searchs", searchs);
        long size = searchs.stream().filter(item->item.isShow()).count();
        long leftSize = 24 - (size % 4) * 6;
        if (leftSize == 0) {
            leftSize = 24;
        }
        context.put("leftSize", leftSize);

        context.put("isRest", isRest);

        String entityPackage = entity.getName();
        String lastpackage = entityPackage.substring(0, entityPackage.lastIndexOf("."));
        String packageBase = entityPackage.substring(0, lastpackage.lastIndexOf("."));
        context.put("dao_p", packageBase + ".dao");
        context.put("manager_p", packageBase + ".service");
        context.put("page_p", packageBase + ".page");
        context.put("so_p", packageBase + ".so");

        Set<Field> files = ReflectionUtils.getAllFields(entity);
        for (Field field : files) {
            Id id = field.getAnnotation(Id.class);
            if (id != null) {
                context.put("id", field.getType());
            }
        }

        Reflections reflections = new Reflections("com.haoxuer.imake.handle");
        Set<Class<? extends BeanHandle>> ss = reflections.getSubTypesOf(BeanHandle.class);
        for (Class<? extends BeanHandle> s : ss) {
            if (Modifier.isAbstract(s.getModifiers())) {
                continue;
            }
            try {
                BeanHandle beanHandle = s.newInstance();
                beanHandle.handle(entity, context);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        Set<String> keys = this.attributes.keySet();
        for (String key : keys) {
            Object value = this.attributes.get(key);
            context.put(key,value);
        }
        return context;
    }

    public void makes(String packagestr) {

        Reflections reflections = new Reflections(packagestr);
        Set<Class<?>> ss = reflections.getTypesAnnotatedWith(Entity.class);
        for (Class<?> class1 : ss) {
            make(class1);
        }

    }

    public void makes(Class<?>... entitys) {

        for (Class<?> entity : entitys) {
            make(entity);

        }
    }

    public void makes(List<Class<?>> entitys) {

        for (Class<?> entity : entitys) {

            make(entity);
        }
    }
}
