package ${action};

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.apache.shiro.authz.annotation.RequiresPermissions;

import org.springframework.context.annotation.Scope;
import com.haoxuer.discover.web.base.BaseAction;
/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/

@Scope("prototype")
@Controller
public class ${entity.simpleName}Action extends BaseAction{


	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/view_list")
	public String list() {
		return getView("${config_entity}/list");
	}

}