package ${manager_p}.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.haoxuer.discover.data.core.Updater;
import ${dao_p}.${entity.simpleName}Dao;
import ${entity.name};
import ${manager_p}.${entity.simpleName}Service;

import com.haoxuer.discover.data.page.Filter;
import com.haoxuer.discover.data.page.Order;
import com.haoxuer.discover.data.page.Page;
import com.haoxuer.discover.data.page.Pageable;
import java.util.List;
import java.util.LinkedList;
import java.util.ArrayList;
<#if versionentity>
import com.haoxuer.discover.site.dao.SystemVersionDao;
</#if>
import com.haoxuer.discover.data.utils.FilterUtils;
import org.springframework.context.annotation.Scope;


/**
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/


@Scope("prototype")
@Service
@Transactional
public class ${entity.simpleName}ServiceImpl implements ${entity.simpleName}Service {

	private ${entity.simpleName}Dao dao;

	<#if versionentity>
	@Autowired
	private SystemVersionDao versionDao;
    </#if>

	@Override
	@Transactional(readOnly = true)
	public ${entity.simpleName} findById(${id.simpleName} id) {
		return dao.findById(id);
	}

	<#if catalog>
	@Override
	public List<${entity.simpleName}> findByTops(Integer pid) {
		LinkedList<${entity.simpleName}> result = new LinkedList<${entity.simpleName}>();
		${entity.simpleName} catalog = dao.findById(pid);
	    if(catalog != null){
			while ( catalog != null && catalog.getParent() != null ) {
				result.addFirst(catalog);
				catalog = dao.findById(catalog.getParentId());
			}
			result.addFirst(catalog);
	    }
		return result;
	}


    @Override
    public List<${entity.simpleName}> child(Integer id,Integer max) {
        List<Order> orders=new ArrayList<Order>();
        orders.add(Order.asc("code"));
        List<Filter> list=new ArrayList<Filter>();
        list.add(Filter.eq("parent.id",id));
        return dao.list(0,max,list,orders);
	}
    </#if>

	@Override
    @Transactional
	public ${entity.simpleName} save(${entity.simpleName} bean) {
	    <#if versionentity>
	    String sequence =${entity.simpleName}.class.getSimpleName().toLowerCase();
		Long version = versionDao.next(sequence);
		bean.setVersionNum(version);
		bean.setState(1);
		</#if>
		dao.save(bean);
		return bean;
	}

	@Override
    @Transactional
	public ${entity.simpleName} update(${entity.simpleName} bean) {
		<#if versionentity>
	    String sequence =${entity.simpleName}.class.getSimpleName().toLowerCase();
		Long version = versionDao.next(sequence);
		bean.setVersionNum(version);
		bean.setState(2);
		</#if>
		Updater<${entity.simpleName}> updater = new Updater<${entity.simpleName}>(bean);
		return dao.updateByUpdater(updater);
	}

	@Override
    @Transactional
	public ${entity.simpleName} deleteById(${id.simpleName} id) {
		${entity.simpleName} bean = dao.findById(id);
		<#if versionentity>
	    String sequence =${entity.simpleName}.class.getSimpleName().toLowerCase();
		Long version = versionDao.next(sequence);
		bean.setVersionNum(version);
		bean.setState(3);
		<#else>
        dao.deleteById(id);
		</#if>
		return bean;
	}

	@Override
    @Transactional	
	public ${entity.simpleName}[] deleteByIds(${id.simpleName}[] ids) {
		${entity.simpleName}[] beans = new ${entity.simpleName}[ids.length];
		for (int i = 0,len = ids.length; i < len; i++) {
			beans[i] = deleteById(ids[i]);
		}
		return beans;
	}


	@Autowired
	public void setDao(${entity.simpleName}Dao dao) {
		this.dao = dao;
	}

	@Override
    public Page<${entity.simpleName}> page(Pageable pageable){
         return dao.page(pageable);
    }


    @Override
	public Page<${entity.simpleName}> page(Pageable pageable, Object search) {
		List<Filter> filters=	FilterUtils.getFilters(search);
		if (filters!=null) {
			pageable.getFilters().addAll(filters);
		}
		return dao.page(pageable);
	}

    @Override
    public List<${entity.simpleName}> list(int first, Integer size, List<Filter> filters, List<Order> orders) {
        return dao.list(first,size,filters,orders);}
}