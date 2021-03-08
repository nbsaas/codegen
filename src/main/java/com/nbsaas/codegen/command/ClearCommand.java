package com.nbsaas.codegen.command;

import freemarker.template.TemplateException;
import org.apache.commons.chain.Context;

import java.io.File;
import java.io.IOException;

public class ClearCommand extends CodeBaseCommand {
    @Override
    public boolean execute(Context context) throws Exception {

        clear(context, ".data.dao", "Dao");
        clear(context, ".data.dao.impl", "DaoImpl");
        clear(context, ".data.service", "Service");
        clear(context, ".data.service.impl", "ServiceImpl");
        clear(context, ".api.apis", "Api");
        clear(context, ".api.domain.list", "List");
        clear(context, ".api.domain.page", "Page");
        clear(context, ".api.domain.simple", "Simple");
        clear(context, ".api.domain.response", "Response");
        clear(context, ".api.domain.request", "DataRequest");
        clear(context, ".api.domain.request", "SearchRequest");
        clear(context, ".rest.convert", "SimpleConvert");
        clear(context, ".rest.convert", "ResponseConvert");
        clear(context, ".rest.resource", "Resource");
        clear(context, ".controller.tenant", "TenantRestController");
        clear(context, ".controller.rest", "RestController");
        clear(context, ".controller.admin", "Action");
        clear(context, ".data.so", "So");

        return false;
    }

    protected void clear(Context context, String pathUrl, String label) throws IOException, TemplateException {

        Class<?> entity = (Class<?>) context.get("entity");

        String base = context.get("base") + pathUrl;

        String path = base.replaceAll("\\.", "/");

        String b = entity.getResource("/").getFile();

        b = b.replace("/target/classes", "/src/main/java") + path;
        File actiondir = new File(b);
        if (!actiondir.exists()) {
        }
        File daodirfile = new File(b, entity.getSimpleName() + label + ".java");
        if (daodirfile.exists()) {
            daodirfile.delete();
        }


    }
}
