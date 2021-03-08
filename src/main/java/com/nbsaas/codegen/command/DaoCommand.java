package com.nbsaas.codegen.command;

import freemarker.template.Configuration;
import org.apache.commons.chain.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DaoCommand extends CodeBaseCommand {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public boolean execute(Context context) throws Exception {
		boolean isDao=(Boolean) context.get("isDao");
		if (!isDao) {
			return false;
		}
		logger.info("Dao接口和实现生成");
		Configuration config = getConfiguration(context);

		handle(context, config,"dao",".data.dao","Dao");
		handle(context, config,"dao_impl",".data.dao.impl","DaoImpl");

		return false;
	}



}
