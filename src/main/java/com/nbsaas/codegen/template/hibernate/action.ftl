package ${action};

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.apache.shiro.authz.annotation.RequiresPermissions;

<#if versionentity>
import com.haoxuer.discover.data.page.Filter;
</#if>
import com.haoxuer.discover.data.page.Pageable;
import ${base}.api.apis.${entity.simpleName}Api;
import ${base}.api.domain.page.${entity.simpleName}Page;
import ${base}.api.domain.request.*;import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.context.annotation.Scope;
import com.haoxuer.discover.web.base.BaseAction;
/**
*
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/


@Scope("prototype")
@Controller
public class ${entity.simpleName}Action extends BaseAction{

	public static final String MODEL = "model";

	public static final String REDIRECT_LIST_HTML = "redirect:/admin/${config_entity}/view_list.htm";

	private static final Logger log = LoggerFactory.getLogger(${entity.simpleName}Action.class);

	@Autowired
	private ${entity.simpleName}Api api;

	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/view_list")
	public String list(${entity.simpleName}SearchRequest request,ModelMap model) {

        ${entity.simpleName}Page page = api.search(request);
        model.addAttribute("list", page.getList());
		model.addAttribute("page", page);
		model.addAttribute("so", request);
		return getView("${config_entity}/list");
	}

	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/view_add")
	public String add(ModelMap model) {
		return getView("${config_entity}/add");
	}

	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/view_edit")
	public String edit(Pageable pageable,${entity.simpleName}DataRequest request,  ModelMap model) {
        model.addAttribute(MODEL, api.view(request));
		model.addAttribute("page", pageable);
		return getView("${config_entity}/edit");
	}

	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/view_view")
	public String view(${entity.simpleName}DataRequest request,ModelMap model) {
         model.addAttribute(MODEL, api.view(request));
		return getView("${config_entity}/view");
	}

	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/model_save")
	public String save(${entity.simpleName}DataRequest request,ModelMap model) {
	
	    String view=REDIRECT_LIST_HTML;
		try {
			 api.create(request);
		} catch (Exception e) {
			log.error("保存失败",e);
			model.addAttribute("erro", e.getMessage());
			view=getView("${config_entity}/add");
		}
		return view;
	}

	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/model_update")
	public String update(Pageable pageable, ${entity.simpleName}DataRequest request,  RedirectAttributes redirectAttributes, ModelMap model) {
		
		String view=REDIRECT_LIST_HTML;
		try {
			api.update(request);
			initRedirectData(pageable, redirectAttributes);
		} catch (Exception e) {
			log.error("更新失败",e);
			model.addAttribute("erro", e.getMessage());
			model.addAttribute(MODEL,request);
		    model.addAttribute("page", pageable);
			view=getView("${config_entity}/edit");
		}
		return view;
	}
	@RequiresPermissions("${config_entity}")
	@RequestMapping("/admin/${config_entity}/model_delete")
	public String delete(Pageable pageable, ${entity.simpleName}DataRequest request, RedirectAttributes redirectAttributes) {

		String view=REDIRECT_LIST_HTML;

		try {
			initRedirectData(pageable, redirectAttributes);
			 api.delete(request);
		} catch (DataIntegrityViolationException e) {
			log.error("删除失败",e);
			redirectAttributes.addFlashAttribute("erro", "该条数据不能删除，请先删除和他相关的类容!");
		}

		return view;
	}

	private void initRedirectData(Pageable pageable, RedirectAttributes redirectAttributes) {
		redirectAttributes.addAttribute("pageNumber",pageable.getPageNumber());
	}
}