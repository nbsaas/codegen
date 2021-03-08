package com.nbsaas.codegen.command;

import freemarker.template.Configuration;
import org.apache.commons.chain.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RestCommand extends CodeBaseCommand{

	private Logger logger = LoggerFactory.getLogger(getClass());

	public boolean execute(Context context) throws Exception {
		boolean isRest=(Boolean) context.get("isRest");
		Configuration config = getConfiguration(context);

		Boolean restDomain=(Boolean) context.get("restDomain");
		if (restDomain==null){
			restDomain=true;
		}
        if (restDomain){
			handle(context, config,"rest_simple",".api.domain.simple","Simple");
			handle(context, config,"rest_response",".api.domain.response","Response");
			handle(context, config,"rest_request_data",".api.domain.request","DataRequest");
			//handle(context, config,"rest_request_update",".api.domain.request","UpdateRequest");
			handle(context, config,"rest_request_search",".api.domain.request","SearchRequest");
			//handle(context, config,"rest_request_view",".api.domain.request","ViewRequest");
			//handle(context, config,"rest_request_list",".api.domain.request","ListRequest");
			handle(context, config,"rest_conver_simple",".rest.convert","SimpleConvert");
			handle(context, config,"rest_conver_response",".rest.convert","ResponseConvert");
		}

		if (!isRest) {
			return false;
		}
		logger.info("Rest接口和实现生成");
		handle(context, config,"rest_list",".api.domain.list","List");
		handle(context, config,"rest_page",".api.domain.page","Page");

		handle(context, config,"rest_api",".api.apis","Api");
		handle(context, config,"rest_resource",".rest.resource","Resource");
		handle(context, config,"rest_controller_tenant",".controller.tenant","TenantRestController");
		handle(context, config,"rest_controller",".controller.rest","RestController");

		return false;
	}
}
