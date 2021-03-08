package com.nbsaas.codegen.command;

import freemarker.template.Configuration;
import org.apache.commons.chain.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ActionCommand extends CodeBaseCommand {

    private Logger logger = LoggerFactory.getLogger(getClass());

    public boolean execute(Context context) throws Exception {
        boolean isAction = (Boolean) context.get("isAction");
        if (!isAction) {
            return false;
        }
        logger.info("Action接口和实现生成");
        Configuration config = getConfiguration(context);

        Boolean catalog = (Boolean) context.get("catalog");
        if (catalog) {
            handle(context, config, "catalog_action", ".controller.admin", "Action");
        } else {
            handle(context, config, "action", ".controller.admin", "Action");
        }


        return false;
    }

}
