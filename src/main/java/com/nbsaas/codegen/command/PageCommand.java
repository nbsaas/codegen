package com.nbsaas.codegen.command;

import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileWriter;

public class PageCommand implements Command {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public boolean execute(Context context) throws Exception {
		boolean isView=(Boolean) context.get("isView");
		if (!isView) {
			return false;
		}
		logger.info("Page接口和实现生成");
		
		Class<?> classdir=(Class<?>) context.get("dir");
		ClassTemplateLoader ctl = new ClassTemplateLoader(classdir, "/"+classdir.getName().replace(classdir.getSimpleName(),"").replace(".","/"));
		Configuration config = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
		config.setTemplateLoader(ctl);

		File view = (File) context.get("view");
		if (!view.exists()) {
			view.mkdirs();
		}
		Class<?> entity = (Class<?>) context.get("entity");
        File dir=new File(view,entity.getSimpleName().toLowerCase());
    	if (!dir.exists()) {
    		dir.mkdirs();
		}
		File list = new File(dir, "list.html");
		
		FileWriter listWriter = new FileWriter(list);

		Boolean catalog = (Boolean) context.get("catalog");
		if (catalog){
			config.getTemplate("page_catalog_list.html").process(context, listWriter);
		}else {
			config.getTemplate("page_list.html").process(context, listWriter);

		}

		
		FileWriter addWriter=new FileWriter(new File(dir, "add.html"));
		config.getTemplate("page_add.html").process(context, addWriter);

		FileWriter editWriter=new FileWriter(new File(dir, "edit.html"));
		if (catalog){
			config.getTemplate("page_catalog_edit.html").process(context, editWriter);
		}else{
			config.getTemplate("page_edit.html").process(context, editWriter);
		}

		FileWriter viewWriter=new FileWriter(new File(dir, "view.html"));
		config.getTemplate("page_view.html").process(context, viewWriter);

		FileWriter component=new FileWriter(new File(dir, "component.html"));
		config.getTemplate("component.html").process(context, component);
		return false;
	}

}
