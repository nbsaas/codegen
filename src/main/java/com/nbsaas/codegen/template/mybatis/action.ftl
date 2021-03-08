package ${action};



import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.quhaodian.data.page.Order;
import com.quhaodian.data.page.Page;
import com.quhaodian.data.page.Pageable;
import  ${entity.name};
import ${manager_p}.${entity.simpleName}Service;

@Controller
public class ${entity.simpleName}Action {
	private static final Logger log = LoggerFactory.getLogger(${entity.simpleName}Action.class);

	@RequestMapping("/admin/${config_entity}/view_list")
	public String list(Pageable pageable, HttpServletRequest request, ModelMap model) {
	
		if (pageable==null) {
			pageable=new Pageable();
		}
		if (pageable.getOrders()==null||pageable.getOrders().size()==0) {
			pageable.getOrders().add(Order.desc("id"));
		}
		Page<${entity.simpleName}> pagination = manager.findPage(pageable);
		model.addAttribute("list", pagination.getContent());
		model.addAttribute("page", pagination);
		return "/admin/${config_entity}/list";
	}

	@RequestMapping("/admin/${config_entity}/view_add")
	public String add(ModelMap model) {
		return "/admin/${config_entity}/add";
	}

	@RequestMapping("/admin/${config_entity}/view_edit")
	public String edit(Pageable pageable,${id.simpleName} id, Integer pageNo, HttpServletRequest request, ModelMap model) {
		model.addAttribute("model", manager.findById(id));
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("page", pageable);
		return "/admin/${config_entity}/edit";
	}

	@RequestMapping("/admin/${config_entity}/view_view")
	public String view(${id.simpleName} id,HttpServletRequest request, ModelMap model) {
		model.addAttribute("model", manager.findById(id));
		return "/admin/${config_entity}/view";
	}

	@RequestMapping("/admin/${config_entity}/model_save")
	public String save(${entity.simpleName} bean, HttpServletRequest request, ModelMap model) {
	
	    String view="redirect:view_list.htm";
		try {
			bean = manager.save(bean);
			log.info("save object id={}", bean.getId());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("erro", e.getMessage());
			view="/admin/${config_entity}/add";
		}
		return view;
	}

	@RequestMapping("/admin/${config_entity}/model_update")
	public String update(Pageable pageable, ${entity.simpleName} bean,HttpServletRequest request, ModelMap model) {
		
		String view="redirect:/admin/${config_entity}/view_list.htm?pageNumber="+pageable.getPageNumber();
		try {
		bean = manager.update(bean);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("erro", e.getMessage());
			model.addAttribute("model",bean);
		    model.addAttribute("page", pageable);
			view="/admin/${config_entity}/edit";
		}
		return view;
	}

	@RequestMapping("/admin/${config_entity}/model_delete")
	public String delete(Pageable pageable, ${id.simpleName} id, HttpServletRequest request, ModelMap model) {
			 
		try {
			manager.deleteById(id);
		} catch (DataIntegrityViolationException e) {
			model.addAttribute("erro", "该条数据不能删除，请先删除和他相关的类容!");
		}
					 
		return list(pageable, request, model);
	}
	@RequestMapping("/admin/${config_entity}/model_deletes")
	public String deletes(Pageable pageable, ${id.simpleName}[] ids, HttpServletRequest request, ModelMap model) {
			 
	  try{
			manager.deleteByIds(ids);
		} catch (DataIntegrityViolationException e) {
			model.addAttribute("erro", "该条数据不能删除，请先删除和他相关的类容!");
		}
		return list(pageable, request, model);
	}
	@Autowired
	private ${entity.simpleName}Service manager;
}