package ${dao_p!""}.impl;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.haoxuer.discover.data.core.CriteriaDaoImpl;
import ${dao_p}.${entity.simpleName}Dao;
import ${entity.name};
<#if catalog>
import com.haoxuer.discover.data.core.CatalogDaoImpl;
</#if>

/**
* Created by imake on ${.now?string("yyyy年MM月dd日HH:mm:ss")}.
*/
@Repository

<#if catalog>
public class ${entity.simpleName}DaoImpl extends CatalogDaoImpl<${entity.simpleName}, ${id.simpleName}> implements ${entity.simpleName}Dao {
<#else>
public class ${entity.simpleName}DaoImpl extends CriteriaDaoImpl<${entity.simpleName}, ${id.simpleName}> implements ${entity.simpleName}Dao {
</#if>

	@Override
	public ${entity.simpleName} findById(${id.simpleName} id) {
	    if (id==null) {
			return null;
		}
		return get(id);
	}

	@Override
	public ${entity.simpleName} save(${entity.simpleName} bean) {

		<#if catalog>
		add(bean);
		<#else>
        getSession().save(bean);
		</#if>
		
		
		return bean;
	}

    @Override
	public ${entity.simpleName} deleteById(${id.simpleName} id) {
		${entity.simpleName} entity = super.get(id);
		if (entity != null) {
			getSession().delete(entity);
		}
		return entity;
	}
	
	@Override
	protected Class<${entity.simpleName}> getEntityClass() {
		return ${entity.simpleName}.class;
	}
	
	@Autowired
	public void setSuperSessionFactory(SessionFactory sessionFactory){
	    super.setSessionFactory(sessionFactory);
	}
}