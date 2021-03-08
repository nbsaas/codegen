package com.nbsaas.codegen.command;

import freemarker.template.Configuration;
import org.apache.commons.chain.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Created by ada on 2017/4/12.
 */
public class SoCommand extends CodeBaseCommand  {

    private Logger logger = LoggerFactory.getLogger(getClass());


    @Override
    public boolean execute(Context context) throws Exception {

        boolean isSo=(Boolean) context.get("isSo");
        if (!isSo) {
            return false;
        }
        logger.info("So对象生成");
        Configuration config = getConfiguration(context);

        handle(context, config,"so",".data.so","So");


        return false;
    }
}
