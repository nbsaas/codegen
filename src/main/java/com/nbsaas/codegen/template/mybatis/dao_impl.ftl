package ${dao_p!""}.impl;

import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quhaodian.data.core.CriteriaDaoImpl;
import com.quhaodian.data.core.Pagination;
import ${dao_p}.${entity.simpleName}Dao;
import ${entity.name};

@Repository
public class ${entity.simpleName}DaoImpl extends CriteriaDaoImpl<${entity.simpleName}, ${id.simpleName}> implements ${entity.simpleName}Dao {
	public Pagination getPage(int pageNo, int pageSize) {
		Criteria crit = createCriteria();
		Pagination page = findByCriteria(crit, pageNo, pageSize);
		return page;
	}

	public ${entity.simpleName} findById(${id.simpleName} id) {
	    if (id==null) {
			return null;
		}
		${entity.simpleName} entity = get(id);
		return entity;
	}

	public ${entity.simpleName} save(${entity.simpleName} bean) {
		getSession().save(bean);
		<#if catalog>
		if (bean.getParentId() != null) {
			${entity.simpleName} parent =findById(bean.getParentId());
			if (parent != null) {
				if (parent.getLevelinfo() != null) {
					bean.setLevelinfo(parent.getLevelinfo() + 1);
				} else {
					bean.setLevelinfo(2);
				}
				if (parent.getIds() != null) {
					bean.setIds(parent.getIds() + "," + bean.getId());

				} else {
					bean.setIds(parent.getId() + "," + bean.getId());
				}

			} else {
				bean.setLevelinfo(1);
				bean.setIds("" + bean.getId());
			}
		} else {
			bean.setLevelinfo(1);
			bean.setIds("" + bean.getId());
		}		
		</#if>
		
		
		return bean;
	}

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