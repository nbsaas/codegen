package ${base}.controller.tenant;

import ${base}.api.apis.${entity.simpleName}Api;
import ${base}.api.domain.list.${entity.simpleName}List;
import ${base}.api.domain.page.${entity.simpleName}Page;
import ${base}.api.domain.request.*;
import ${base}.api.domain.response.${entity.simpleName}Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.haoxuer.discover.user.controller.tenant.BaseTenantRestController;
import org.apache.shiro.authz.annotation.RequiresUser;
import org.apache.shiro.authz.annotation.RequiresPermissions;

@RequestMapping("/tenantRest/${entity.simpleName?lower_case}")
@RestController
public class ${entity.simpleName}TenantRestController extends BaseTenantRestController {


	@RequiresPermissions("${config_entity}")
    @RequiresUser
    @RequestMapping("create")
    public ${entity.simpleName}Response create(${entity.simpleName}DataRequest request) {
        init(request);
        <#if createByUser?? && createByUser>
        request.setCreator(request.getCreateUser());
        </#if>
        return api.create(request);
    }

	@RequiresPermissions("${config_entity}")
    @RequiresUser
    @RequestMapping("update")
    public ${entity.simpleName}Response update(${entity.simpleName}DataRequest request) {
        init(request);
        return api.update(request);
    }

	@RequiresPermissions("${config_entity}")
    @RequiresUser
    @RequestMapping("delete")
    public ${entity.simpleName}Response delete(${entity.simpleName}DataRequest request) {
        init(request);
        ${entity.simpleName}Response result = new ${entity.simpleName}Response();
        try {
           result = api.delete(request);
        } catch (Exception e) {
           result.setCode(501);
           result.setMsg("删除失败!");
        }
        return result;
    }

	@RequiresPermissions("${config_entity}")
    @RequiresUser
    @RequestMapping("view")
    public ${entity.simpleName}Response view(${entity.simpleName}DataRequest request) {
       init(request);
       return api.view(request);
   }

	@RequiresPermissions("${config_entity}")
    @RequiresUser
    @RequestMapping("list")
    public ${entity.simpleName}List list(${entity.simpleName}SearchRequest request) {
        init(request);
        return api.list(request);
    }

	@RequiresPermissions("${config_entity}")
    @RequiresUser
    @RequestMapping("search")
    public ${entity.simpleName}Page search(${entity.simpleName}SearchRequest request) {
        init(request);
        return api.search(request);
    }

    @Autowired
    private ${entity.simpleName}Api api;

}
