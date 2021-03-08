package ${manager_p}.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.quhaodian.data.core.Finder;
import com.quhaodian.data.core.Pagination;
import com.quhaodian.data.core.Updater;
import ${dao_p}.${entity.simpleName}Dao;
import ${entity.name};
import ${manager_p}.${entity.simpleName}Service;

import com.quhaodian.data.page.Filter;
import com.quhaodian.data.page.Order;
import com.quhaodian.data.page.Page;
import com.quhaodian.data.page.Pageable;
import java.util.List;


@Service
@Transactional
public class ${entity.simpleName}ServiceImpl implements ${entity.simpleName}Service {
	

	@Transactional(readOnly = true)
	public ${entity.simpleName} findById(${id.simpleName} id) {
		${entity.simpleName} entity = dao.findById(id);
		return entity;
	}

    @Transactional
	public ${entity.simpleName} save(${entity.simpleName} bean) {
		dao.save(bean);
		return bean;
	}

    @Transactional
	public ${entity.simpleName} update(${entity.simpleName} bean) {
		Updater<${entity.simpleName}> updater = new Updater<${entity.simpleName}>(bean);
		bean = dao.updateByUpdater(updater);
		return bean;
	}

    @Transactional
	public ${entity.simpleName} deleteById(${id.simpleName} id) {
		${entity.simpleName} bean = dao.deleteById(id);
		return bean;
	}

    @Transactional	
	public ${entity.simpleName}[] deleteByIds(${id.simpleName}[] ids) {
		${entity.simpleName}[] beans = new ${entity.simpleName}[ids.length];
		for (int i = 0,len = ids.length; i < len; i++) {
			beans[i] = deleteById(ids[i]);
		}
		return beans;
	}

	private ${entity.simpleName}Dao dao;

	@Autowired
	public void setDao(${entity.simpleName}Dao dao) {
		this.dao = dao;
	}
	
	
	@Transactional(readOnly = true)
	public Page<${entity.simpleName}> findPage(Pageable pageable){
	     return dao.findPage(pageable);
	}

	@Transactional(readOnly = true)
	public long count(Filter... filters){
	     
	     return dao.count(filters);
	     
	}

	@Transactional(readOnly = true)
	public List<${entity.simpleName}> findList(Integer first, Integer count, List<Filter> filters, List<Order> orders){
	
		     return dao.findList(first,count,filters,orders);
	
	}
}