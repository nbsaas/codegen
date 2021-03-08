package com.nbsaas.codegen.command;

import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public abstract class CodeBaseCommand implements Command {

    protected Configuration getConfiguration(Context context) {
        Class<?> codeDir=(Class<?>) context.get("codeDir");
        ClassTemplateLoader ctl = new ClassTemplateLoader(codeDir, "/"+codeDir.getName().replace(codeDir.getSimpleName(),"").replace(".","/"));
        Configuration config = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
        config.setTemplateLoader(ctl);
        return config;
    }

    protected void handle(Context context, Configuration config, String templateInfo, String pathUrl, String label) throws IOException, TemplateException {
        Template template = config.getTemplate(templateInfo+".ftl");

        Class<?> entity = (Class<?>) context.get("entity");

        String base=(String) context.get("base")+pathUrl;

        String path = base.replaceAll("\\.", "/");
        System.out.println(path);

        String b=entity.getResource("/").getFile();

        b=b.replace("/target/classes", "/src/main/java")+path;
        File actiondir=new File(b);
        if (!actiondir.exists()) {
            actiondir.mkdirs();
        }
        File daodirfile = new File(b, entity.getSimpleName() +label+ ".java");

        FileWriter writer = new FileWriter(daodirfile);

        template.process(context, writer);
    }
}
