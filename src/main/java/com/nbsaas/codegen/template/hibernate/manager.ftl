package ${manager_p};

import ${entity.name};
import com.haoxuer.discover.data.page.Filter;
import com.haoxuer.discover.data.page.Order;
import com.haoxuer.discover.data.page.Page;
import com.haoxuer.discover.data.page.Pageable;
import java.util.List;

/**
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/
public interface ${entity.simpleName}Service {

	${entity.simpleName} findById(${id.simpleName} id);

	${entity.simpleName} save(${entity.simpleName} bean);

	${entity.simpleName} update(${entity.simpleName} bean);

	${entity.simpleName} deleteById(${id.simpleName} id);
	
	${entity.simpleName}[] deleteByIds(${id.simpleName}[] ids);
	
	Page<${entity.simpleName}> page(Pageable pageable);
	
	Page<${entity.simpleName}> page(Pageable pageable, Object search);

	<#if catalog>
	List<${entity.simpleName}> findByTops(Integer pid);


    List<${entity.simpleName}> child(Integer id,Integer max);
	</#if>

	List<${entity.simpleName}> list(int first, Integer size, List<Filter> filters, List<Order> orders);

}