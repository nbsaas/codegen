package ${base}.rest.resource;

import ${base}.api.apis.${entity.simpleName}Api;
import ${base}.api.domain.list.${entity.simpleName}List;
import ${base}.api.domain.page.${entity.simpleName}Page;
import ${base}.api.domain.request.*;
import ${base}.api.domain.response.${entity.simpleName}Response;
import ${base}.data.dao.${entity.simpleName}Dao;
import ${base}.data.entity.${entity.simpleName};
import ${base}.rest.convert.${entity.simpleName}ResponseConvert;
import ${base}.rest.convert.${entity.simpleName}SimpleConvert;
import com.haoxuer.discover.config.utils.ConverResourceUtils;
import com.haoxuer.discover.data.page.Filter;
import com.haoxuer.discover.data.page.Order;
import com.haoxuer.discover.data.page.Page;
import com.haoxuer.discover.data.page.Pageable;
import com.haoxuer.discover.data.utils.FilterUtils;
import jodd.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import com.haoxuer.discover.user.rest.conver.PageableConver;
import com.haoxuer.discover.data.utils.BeanDataUtils;
<#if daoList??>
<#list daoList as item>
import ${item.daoName};
</#list>
</#if>
import java.util.ArrayList;
import java.util.List;



@Transactional
@Component
public class ${entity.simpleName}Resource implements ${entity.simpleName}Api {

    @Autowired
    private ${entity.simpleName}Dao dataDao;

    <#if daoList??>
    <#list daoList as item>
    @Autowired
    private ${item.dao} ${item.daoField}Dao;
    </#list>
    </#if>

    @Override
    public ${entity.simpleName}Response create(${entity.simpleName}DataRequest request) {
        ${entity.simpleName}Response result = new ${entity.simpleName}Response();

        ${entity.simpleName} bean = new ${entity.simpleName}();
        handleData(request, bean);
        dataDao.save(bean);
        result = new ${entity.simpleName}ResponseConvert().conver(bean);
        return result;
    }

    @Override
    public ${entity.simpleName}Response update(${entity.simpleName}DataRequest request) {
        ${entity.simpleName}Response result = new ${entity.simpleName}Response();
        if (request.getId() == null) {
            result.setCode(501);
            result.setMsg("无效id");
            return result;
        }
        ${entity.simpleName} bean = dataDao.findById(request.getId());
        if (bean == null) {
            result.setCode(502);
            result.setMsg("无效id");
            return result;
        }
        handleData(request, bean);
        result = new ${entity.simpleName}ResponseConvert().conver(bean);
        return result;
    }

    private void handleData(${entity.simpleName}DataRequest request, ${entity.simpleName} bean) {
        BeanDataUtils.copyProperties(request,bean);
        <#if simples??>
        <#list simples as item>
            <#if item.fieldType==2>
            if(request.get${item.id?cap_first}()!=null){
               bean.set${item.id?cap_first}(${item.id}Dao.findById(request.get${item.id?cap_first}()));
            }
            </#if>
         </#list>
         </#if>

    }

    @Override
    public ${entity.simpleName}Response delete(${entity.simpleName}DataRequest request) {
        ${entity.simpleName}Response result = new ${entity.simpleName}Response();
        if (request.getId() == null) {
            result.setCode(501);
            result.setMsg("无效id");
            return result;
        }
        dataDao.deleteById(request.getId());
        return result;
    }

    @Override
    public ${entity.simpleName}Response view(${entity.simpleName}DataRequest request) {
        ${entity.simpleName}Response result=new ${entity.simpleName}Response();
        ${entity.simpleName} bean = dataDao.findById( request.getId());
        if (bean==null){
            result.setCode(1000);
            result.setMsg("无效id");
            return result;
        }
        result=new ${entity.simpleName}ResponseConvert().conver(bean);
        return result;
    }
    @Override
    public ${entity.simpleName}List list(${entity.simpleName}SearchRequest request) {
        ${entity.simpleName}List result = new ${entity.simpleName}List();

        List<Filter> filters = new ArrayList<>();
        filters.addAll(FilterUtils.getFilters(request));
        List<Order> orders = new ArrayList<>();
        if ("asc".equals(request.getSortMethod())){
           orders.add(Order.asc(""+request.getSortField()));
        }
        else if ("desc".equals(request.getSortMethod())){
           orders.add(Order.desc(""+request.getSortField()));
        }else{
           orders.add(Order.desc("id"));
        }
        List<${entity.simpleName}> organizations = dataDao.list(0, request.getSize(), filters, orders);
        ${entity.simpleName}SimpleConvert convert=new ${entity.simpleName}SimpleConvert();
        <#if catalog>
        convert.setFetch(request.getFetch());
        </#if>
        ConverResourceUtils.converList(result, organizations,convert);
        return result;
    }

    @Override
    public ${entity.simpleName}Page search(${entity.simpleName}SearchRequest request) {
        ${entity.simpleName}Page result=new ${entity.simpleName}Page();
        Pageable pageable = new PageableConver().conver(request);
        pageable.getFilters().addAll(FilterUtils.getFilters(request));
        if ("asc".equals(request.getSortMethod())){
            pageable.getOrders().add(Order.asc(""+request.getSortField()));
        }
        else if ("desc".equals(request.getSortMethod())){
            pageable.getOrders().add(Order.desc(""+request.getSortField()));
        }else{
            pageable.getOrders().add(Order.desc("id"));
        }
        Page<${entity.simpleName}> page=dataDao.page(pageable);
        ${entity.simpleName}SimpleConvert convert=new ${entity.simpleName}SimpleConvert();
        <#if catalog>
        convert.setFetch(request.getFetch());
        </#if>
        ConverResourceUtils.converPage(result,page,convert);
        return result;
    }
}
