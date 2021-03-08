package ${manager_p};

import ${entity.name};
import com.quhaodian.data.page.Filter;
import com.quhaodian.data.page.Order;
import com.quhaodian.data.page.Page;
import com.quhaodian.data.page.Pageable;
import java.util.List;

import com.openyelp.annotation.RestFul;

@RestFul(api=${entity.simpleName}Service.class,value="${entity.simpleName}Service")
public interface ${entity.simpleName}Service {

	public ${entity.simpleName} findById(${id.simpleName} id);

	public ${entity.simpleName} save(${entity.simpleName} bean);

	public ${entity.simpleName} update(${entity.simpleName} bean);

	public ${entity.simpleName} deleteById(${id.simpleName} id);
	
	public ${entity.simpleName}[] deleteByIds(${id.simpleName}[] ids);
	
	public Page<${entity.simpleName}> findPage(Pageable pageable);

	public long count(Filter... filters);

	public List<${entity.simpleName}> findList(Integer first, Integer count, List<Filter> filters, List<Order> orders);
	
}